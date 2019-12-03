//
//  ViewController.swift
//  Cosmos
//
//  Created by Samuel Yanez on 7/21/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {
    
    /// Collection view
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = dataSource
            collectionView.isHidden = true
            collectionView.refreshControl = UIRefreshControl()
            collectionView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        }
    }
    
    /// Ativity indicator
    @IBOutlet var activityIndicatorView: UIView! {
        didSet {
            activityIndicatorView.isHidden = false
        }
    }
    
    /// Error view
    @IBOutlet var errorView: UIView! {
        didSet {
            errorView.isAccessibilityElement = true
            errorView.accessibilityLabel = DiscoverViewStrings.errorMessage.localized
            errorView.accessibilityTraits = .button
            errorView.accessibilityHint = "Tap to load the view one more time."
        }
    }
    
    /// Error label
    @IBOutlet var errorLabel: UILabel! {
        didSet {
            errorLabel.font = DynamicFont.shared.font(forTextStyle: .body)
            errorLabel.adjustsFontForContentSizeCategory = true
            errorLabel.text = DiscoverViewStrings.errorMessage.localized
        }
    }
    
    // TODO: Consider using dependency injection here...
    
    /// API Client
    lazy var client =  Configuration.isUITest ? MockClient() : CosmosClient()
    
    /// Data Source
    lazy var dataSource: DiscoverDataSource = {
        return DiscoverDataSource(collectionView: collectionView)
    }()
    
    // TODO: Consider moving pagination logic somewhere else...
    
    /// Pagination offset
    var collectionOffset = 0
    
    /// Pagination page size
    var collectionPageSize = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = DiscoverViewStrings.title.localized
                
        fetch(count: collectionPageSize, offset: collectionOffset) {
            self.activityIndicatorView.isHidden = true
        }
    }
    
    override func viewWillLayoutSubviews() {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: Collection View
    
    @objc func handleRefreshControl() {
        fetch(count: 10) {
            self.collectionView.refreshControl?.endRefreshing()
        }
    }

    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetails" {
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems {
                let apod = dataSource.element(at: selectedIndexPath[0])
                if let detailViewController = segue.destination as? DetailViewController {
                    detailViewController.viewModel = APODViewModel(apod: apod)
                }
            }
        }
    }
        
    // MARK: Networking
    
    func fetch(count: Int, offset: Int = 0, completion: (() -> Void)? = nil) {
        client.fetch(count: count, offset: offset) { [weak self] result in
            switch result {
            case .failure:
                self?.collectionView.isHidden = true
                self?.errorView.isHidden = false
            case .success(let apods):
                self?.dataSource.append(apods)
                self?.collectionView.reloadData()
                self?.collectionView.isHidden = false
                self?.errorView.isHidden = true
                
                // Important to increase the offset for pagination
                self?.collectionOffset = offset + 10
            }
            if let completion = completion {
                completion()
            }
        }
    }
    
    @IBAction func didTapOnRefreshButton(_ sender: Any) {
        errorView.isHidden = true
        activityIndicatorView.isHidden = false
        fetch(count: collectionPageSize, offset: collectionOffset) {
            self.activityIndicatorView.isHidden = true
        }
    }
    
    func scrollToTop() {
        self.collectionView.setContentOffset(CGPoint(x: 0, y: -120), animated: true)
    }
}

// MARK: UICollectionView Delegate

extension DiscoverViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if dataSource.apods.count == indexPath.row + 1 {
            fetch(count: collectionPageSize, offset: collectionOffset)
        }
    }    
}

extension DiscoverViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.width * 1.2)
    }
}
