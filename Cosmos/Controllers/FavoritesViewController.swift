//
//  FavoritesViewController.swift
//  Cosmos
//
//  Created by Samuel Yanez on 10/22/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    /// Different view states
    enum State {
        case loading
        case displayCollection
        case emptyFavorites
        case error
    }
    
    /// Different view sections
    enum Section: CaseIterable {
        case main
    }
    
    /// Fasvorites table view
    @IBOutlet private var tableView: UITableView! {
        didSet {
            tableView.dataSource = dataSource
            tableView.delegate = self
            tableView.refreshControl = UIRefreshControl()
            tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        }
    }
    
    /// Activity indicator
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    /// Message view
    @IBOutlet private var messageView: MessageView! {
        didSet {
            messageView.delegate = self
            messageView.refreshButton.titleLabel?.text = MessageViewStrings.refreshButton.localized
        }
    }
    
    /// API Client
    lazy var client = CosmosClient()
    
    /// Data source
    lazy var dataSource = tableViewDataSource()
    
    /// Astronomy pictures of the day
    private var apods = OrderedSet<Apod>()
    
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
            case .emptyFavorites:
                activityIndicator.stopAnimating()
                tableView.isHidden = true
                messageView.isHidden = false
                messageView.setImage(to: UIImage(systemName: "heart.fill"))
                messageView.setMessage(to: MessageViewStrings.emptyFavoritesMessage.localized)
                messageView.refreshButton.isHidden = true
            case .error:
                activityIndicator.stopAnimating()
                tableView.isHidden = true
                messageView.isHidden = false
                messageView.setImage(to: UIImage(systemName: "exclamationmark.circle"))
                messageView.setMessage(to: MessageViewStrings.errorMessage.localized)
                messageView.refreshButton.isHidden = false
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
                    self.state = .emptyFavorites
                } else {
                    self.apods = OrderedSet(fromCollection: apods.sorted(by: >))
                    self.updateDataSource(with: self.apods.elements)
                    self.state = .displayCollection
                }
            }
            completion?()
        }
    }
    
    func scrollToTop() {
        self.tableView.setContentOffset(CGPoint(x: 0, y: -120), animated: true)
    }
}

// MARK: Table View Data Source

extension FavoritesViewController {
    private func tableViewDataSource() -> SwipeableDiffableDataSource {
        return SwipeableDiffableDataSource(tableView: tableView) { tableView, indexPath, apod in
            let cell: FavoritesCell = FavoritesCell.dequeue(from: tableView, for: indexPath)
            cell.update(with: ApodViewModel(apod: apod))
            return cell
        }
    }
    
    private func updateDataSource(with apods: [Apod], animate: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Apod>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(apods)
        dataSource.apply(snapshot, animatingDifferences: animate)
    }
    
    private func removeFromDataSource(_ apods: [Apod], animate: Bool = true) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems(apods)
        dataSource.apply(snapshot, animatingDifferences: animate)
    }
}

// MARK: UITableView Delegate

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let apod = dataSource.itemIdentifier(for: indexPath), let detailViewController = storyboard?.instantiateViewController(identifier: DetailViewController.identifier, creator: { coder in
            DetailViewController(coder: coder, viewModel: ApodViewModel(apod: apod))
        }) {
            show(detailViewController, sender: tableView.cellForRow(at: indexPath))
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        FavoritesCell.height
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let removeAction = UIContextualAction(style: .destructive, title: FavoritesViewStrings.removeButton.localized, handler: { _, _, completionHandler  in
            guard let apod = self.apods.removeAt(indexPath.row) else {
                completionHandler(false)
                return
            }
            UserDefaultsFavoritesManager.shared.removeFromFavorites(apod)
            self.removeFromDataSource([apod])
            
            // Check the table view still contains identifiers
            if self.dataSource.snapshot().itemIdentifiers.isEmpty {
                self.state = .emptyFavorites
            }
            completionHandler(true)
        })
        return UISwipeActionsConfiguration(actions: [removeAction])
    }
}

// MARK: MessageView Delegate

extension FavoritesViewController: MessageViewDelegate {
    func messageView(_ messageView: MessageView, didTapOnRefreshButton refreshButton: UIButton) {
        state = .loading
        UserDefaultsFavoritesManager.shared.getFavoriteDates { [weak self] dates in
            self?.fetch(favorites: dates)
        }
    }
}

class SwipeableDiffableDataSource: UITableViewDiffableDataSource<FavoritesViewController.Section, Apod> {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
