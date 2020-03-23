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
            messageView.refreshButton.titleLabel?.text = MessageViewStrings.refreshButton.localized
            messageView.refreshButtonHandler = { [unowned self] in
                self.state = .loading
                self.favoritesManager.getFavoriteDates { [unowned self] dates in
                    self.fetch(favorites: dates)
                }
            }
        }
    }
    
    /// API client
    lazy var client = CosmosClient()
    
    /// Favorites manager
    let favoritesManager = FileSystemFavoritesManager.shared
    
    /// Data source
    lazy var dataSource = tableViewDataSource()
    
    /// Astronomy pictures of the day
    private var viewModels = OrderedSet<ApodViewModel>()
    
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
                messageView.imageView.image = UIImage(named: "Favorites Illustration")
                messageView.label.text = MessageViewStrings.emptyFavoritesMessage.localized
                messageView.refreshButton.isHidden = true
            case .error:
                activityIndicator.stopAnimating()
                tableView.isHidden = true
                messageView.isHidden = false
                messageView.imageView.image = UIImage(named: "Error Illustration")
                messageView.label.text = MessageViewStrings.errorMessage.localized
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
        if favoritesManager.isRefreshRequired {
            favoritesManager.getFavoriteDates { [weak self] dates in
                self?.fetch(favorites: dates)
            }
        }
    }
    
    // MARK: Table View
    
    @objc private func handleRefreshControl() {
        favoritesManager.getFavoriteDates { [weak self] dates in
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
                guard !apods.isEmpty else {
                    self.state = .emptyFavorites
                    break
                }
                self.viewModels = OrderedSet(fromCollection: apods.sorted(by: >).map({ ApodViewModel(apod: $0) }))
                self.updateDataSource(with: self.viewModels.elements)
                self.state = .displayCollection
            }
            completion?()
        }
    }
}

// MARK: Table View Data Source

extension FavoritesViewController {
    private func tableViewDataSource() -> SwipeableDiffableDataSource {
        return SwipeableDiffableDataSource(tableView: tableView) { tableView, indexPath, viewModel in
            let cell: FavoritesCell = FavoritesCell.dequeue(from: tableView, for: indexPath)
            cell.viewModel = viewModel
            return cell
        }
    }
    
    private func updateDataSource(with viewModels: [ApodViewModel], animate: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ApodViewModel>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(viewModels)
        dataSource.apply(snapshot, animatingDifferences: animate)
    }
    
    private func removeFromDataSource(_ viewModels: [ApodViewModel], animate: Bool = true) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems(viewModels)
        dataSource.apply(snapshot, animatingDifferences: animate)
    }
}

// MARK: UITableView Delegate

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewModel = dataSource.itemIdentifier(for: indexPath), let detailViewController = storyboard?.instantiateViewController(identifier: DetailViewController.identifier, creator: { coder in
            DetailViewController(coder: coder, viewModel: viewModel)
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
            guard let viewModel = self.viewModels.removeAt(indexPath.row) else {
                completionHandler(false)
                return
            }
            self.favoritesManager.removeFromFavorites(viewModel.apod)
            self.removeFromDataSource([viewModel])
            
            // Check the table view still contains identifiers
            if self.dataSource.snapshot().itemIdentifiers.isEmpty {
                self.state = .emptyFavorites
            }
            completionHandler(true)
        })
        return UISwipeActionsConfiguration(actions: [removeAction])
    }
}

// MARK: ScrollableViewController

extension FavoritesViewController: ScrollableViewController {
    func scrollToTop() {
        tableView.setContentOffset(CGPoint(x: 0, y: -120), animated: true)
    }
}

class SwipeableDiffableDataSource: UITableViewDiffableDataSource<FavoritesViewController.Section, ApodViewModel> {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
