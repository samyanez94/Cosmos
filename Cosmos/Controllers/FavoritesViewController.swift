//
//  FavoritesViewController.swift
//  Cosmos
//
//  Created by Samuel Yanez on 10/22/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.dataSource = dataSource
            tableView.delegate = self
            tableView.refreshControl = UIRefreshControl()
            tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        }
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    /// Message view
    @IBOutlet var messageView: UIView!
    
    /// Message image
    @IBOutlet var messageImage: UIImageView!
    
    /// Message label
    @IBOutlet var messageLabel: UILabel! {
        didSet {
            messageLabel.font = DynamicFont.shared.font(forTextStyle: .body)
            messageLabel.adjustsFontForContentSizeCategory = false
        }
    }
    
    /// API Client
    lazy var client = CosmosClient()
    
    /// Data source
    lazy var dataSource: FavoritesDataSource = {
        FavoritesDataSource(tableView: tableView)
    }()
    
    /// Different view states
    enum State {
        case loading
        case displayCollection
        case missingFavorites
        case error
    }
    
    /// View state
    var state: State = .loading {
        didSet {
            switch state {
            case .loading:
                activityIndicator.startAnimating()
                tableView.isHidden = true
                messageView.isHidden = true
            case .displayCollection:
                activityIndicator.stopAnimating()
                tableView.isHidden = false
                messageView.isHidden = true
                tableView.reloadSections(IndexSet(integer: 0), with: .fade)
            case .missingFavorites:
                activityIndicator.stopAnimating()
                tableView.isHidden = true
                messageView.isHidden = false
                messageImage.image = UIImage(systemName: "heart.fill")
                messageLabel.text = FavoritesViewStrings.missingFavoritesMessage.localized
            case .error:
                activityIndicator.stopAnimating()
                tableView.isHidden = true
                messageView.isHidden = false
                messageImage.image = UIImage(systemName: "arrow.clockwise")
                messageLabel.text = FavoritesViewStrings.errorMessage.localized
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = FavoritesViewStrings.title.localized
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Update view on view did appear only when required
        if UserDefaultsFavoritesManager.shared.isRefreshRequired {
            UserDefaultsFavoritesManager.shared.getFavorites { [weak self] dates in
                self?.fetch(favorites: dates)
            }
        }
    }
    
    // MARK: Table View
    
    @objc func handleRefreshControl() {
        UserDefaultsFavoritesManager.shared.getFavorites { [weak self] dates in
            self?.fetch(favorites: dates) {
                self?.tableView.refreshControl?.endRefreshing()
            }
        }
     }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetails" {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                let apod = dataSource.element(at: selectedIndexPath)
                if let detailViewController = segue.destination as? DetailViewController {
                    detailViewController.viewModel = ApodViewModel(apod: apod)
                    
                    // Inform the tab bar controller of the last view controller shown
                    if let tabBarController = tabBarController as? TabBarViewController {
                        tabBarController.previousSelectedViewController = detailViewController
                    }
                }
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }
    
    // MARK: Networking
    
    func fetch(favorites: [Date], completion: (() -> Void)? = nil) {
        client.fetch(dates: favorites) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure:
                self.state = .error
            case .success(let apods):
                if apods.isEmpty {
                    self.state = .missingFavorites
                } else {
                    self.dataSource.update(fromCollection: apods.sorted(by: >))
                    self.tableView.reloadFirstSecction()
                    self.state = .displayCollection
                }
            }
            completion?()
        }
    }
    
    @IBAction func didTapOnRefreshButton(_ sender: Any) {
        state = .loading
        UserDefaultsFavoritesManager.shared.getFavorites { [weak self] dates in
            self?.fetch(favorites: dates)
        }
    }
    
    func scrollToTop() {
        self.tableView.setContentOffset(CGPoint(x: 0, y: -120), animated: true)
    }
}

// MARK: UITableViewDelegate

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        FavoritesCell.height
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let removeAction = UIContextualAction(style: .destructive, title: FavoritesViewStrings.remove.localized, handler: { _, _, completionHandler  in
            if let apod = self.dataSource.removeElement(at: indexPath) {
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                UserDefaultsFavoritesManager.shared.removeFromFavorites(apod.date)
                if self.dataSource.apods.count == 0 {
                    self.state = .missingFavorites
                }
                completionHandler(true)
            } else {
                completionHandler(false)
            }
            
        })
        return UISwipeActionsConfiguration(actions: [removeAction])
    }
}
