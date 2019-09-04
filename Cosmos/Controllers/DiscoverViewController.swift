//
//  ViewController.swift
//  Cosmos
//
//  Created by Samuel Yanez on 7/21/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {
        
    /// API Client
    lazy var client = CosmosClient()
    
    /// Data Source
    lazy var dataSource: DiscoverDataSource = {
        return DiscoverDataSource(collectionView: collectionView)
    }()
    
    /// Collection View
    @IBOutlet var collectionView: UICollectionView!
    
    /// Ativity indicator
    @IBOutlet var activityIndicatorView: UIView!
    
    /// Error View
    @IBOutlet var errorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        
        activityIndicatorView.isHidden = false
        fetch {
            self.activityIndicatorView.isHidden = true
        }
    }
    
    override func viewWillLayoutSubviews() {
    collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: Collection View
    
    private func configureCollectionView() {
       collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.isHidden = true
        collectionView.refreshControl = UIRefreshControl()
        
        collectionView.refreshControl?.addTarget(self, action:
        #selector(handleRefreshControl),
        for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
       // TODO: Uptade collection view here...
        
       DispatchQueue.main.async {
          self.collectionView.refreshControl?.endRefreshing()
       }
    }

    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetails" {
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems {
                let selectedAPOD = dataSource.object(at: selectedIndexPath[0])
                if let detailViewController = segue.destination as? DetailViewController {
                    detailViewController.apod = selectedAPOD
                }
            }
        }
    }
        
    // MARK: Networking
    
    func fetch(completion: (() -> Void)? = nil) {
        client.fetch { [weak self] result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                self?.collectionView.isHidden = true
                self?.errorView.isHidden = false
            case .success(let apods):
                self?.dataSource.append(apods.reversed())
                self?.collectionView.reloadData()
                self?.collectionView.isHidden = false
                self?.errorView.isHidden = true
            }
            if let completion = completion {
                completion()
            }
        }
    }
    
    @IBAction func didTapOnRefreshButton(_ sender: Any) {
        errorView.isHidden = true
        activityIndicatorView.isHidden = false
        fetch {
            self.activityIndicatorView.isHidden = true
        }
    }
    
    func scrollToTop() {
    self.collectionView.setContentOffset(CGPoint.zero, animated: true)
    }
}

// MARK: UICollectionView Delegate

extension DiscoverViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if dataSource.apods.count == indexPath.row + 1 {
            fetch()
        }
    }
}

extension DiscoverViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.width * 1.2)
    }
}
