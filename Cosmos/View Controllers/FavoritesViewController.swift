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
    
    /// API Client
    lazy var client =  Configuration.isUITest ? MockClient() : CosmosClient()
    
    /// Data Source
    lazy var dataSource: FavoritesDataSource = {
        FavoritesDataSource(tableView: tableView)
    }()
    
    /// Favorites manager
    private lazy var favoritesManager: FavoritesManager = {
        CosmosFavoritesManager()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetch(favorites: favoritesManager.getFavorites())
    }
    
    
    // MARK: Table View
    
    @objc func handleRefreshControl() {
        fetch(favorites: favoritesManager.getFavorites()) {
            self.tableView.refreshControl?.endRefreshing()
        }
     }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetails" {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndexPath, animated: true)
                let apod = dataSource.element(at: selectedIndexPath)
                if let detailViewController = segue.destination as? DetailViewController {
                    detailViewController.apod = apod
                }
            }
        }
    }
    
    // MARK: Networking
    
    func fetch(favorites: [Date], completion: (() -> Void)? = nil) {
        client.fetch(dates: favorites) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let apods):
                self?.dataSource.set(withCollection: apods)
                self?.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
            }
            completion?()
        }
    }
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        FavoritesCell.height
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let removeAction = UIContextualAction(style: .destructive, title: "Remove", handler: { _, _, completionHandler  in
            self.favoritesManager.removeFromFavorites(self.dataSource.element(at: indexPath))
            self.dataSource.removeElement(at: indexPath)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        })

        return UISwipeActionsConfiguration(actions: [removeAction])
    }
}
