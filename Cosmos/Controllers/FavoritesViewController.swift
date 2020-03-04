//
//  FavoritesViewController.swift
//  Cosmos
//
//  Created by Samuel Yanez on 10/22/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    /// Fasvorites table view
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.dataSource = dataSource
            tableView.delegate = self
            tableView.refreshControl = UIRefreshControl()
            tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        }
    }
    
    /// Activity indicator
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
        
        // Update view only when required
        if UserDefaultsFavoritesManager.shared.isRefreshRequired {
            UserDefaultsFavoritesManager.shared.getFavoriteDates { [weak self] dates in
                self?.fetch(favorites: dates)
            }
        }
    }
    
    // MARK: Table View
    
    @objc private func handleRefreshControl() {
        UserDefaultsFavoritesManager.shared.getFavoriteDates { [weak self] dates in
            self?.fetch(favorites: dates) {
                self?.tableView.refreshControl?.endRefreshing()
            }
        }
     }
    
    // MARK: Networking
    
    private func fetch(favorites: [Date], completion: (() -> Void)? = nil) {
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
                    self.tableView.reloadFirstSection()
                    self.state = .displayCollection
                }
            }
            completion?()
        }
    }
    
    @IBAction private func didTapOnRefreshButton(_ sender: Any) {
        state = .loading
        UserDefaultsFavoritesManager.shared.getFavoriteDates { [weak self] dates in
            self?.fetch(favorites: dates)
        }
    }
    
    func scrollToTop() {
        self.tableView.setContentOffset(CGPoint(x: 0, y: -120), animated: true)
    }
}

// MARK: UITableViewDelegate

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailViewController = storyboard?.instantiateViewController(identifier: DetailViewController.identifier, creator: { coder in
            DetailViewController(coder: coder, viewModel: ApodViewModel(apod: self.dataSource.element(at: indexPath)))
        }) {
            show(detailViewController, sender: tableView.cellForRow(at: indexPath))
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        FavoritesCell.height
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let removeAction = UIContextualAction(style: .destructive, title: FavoritesViewStrings.remove.localized, handler: { _, _, completionHandler  in
            guard let apod = self.dataSource.removeElement(at: indexPath) else {
                completionHandler(false)
                return
            }
            UserDefaultsFavoritesManager.shared.removeFromFavorites(apod)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            // Check there are APODs left after removing
            if self.dataSource.apods.isEmpty {
                self.state = .missingFavorites
            }
            completionHandler(true)
        })
        return UISwipeActionsConfiguration(actions: [removeAction])
    }
}
