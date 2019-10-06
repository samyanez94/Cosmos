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
    
    /// Collection view
    @IBOutlet var collectionView: UICollectionView!
    
    /// Ativity indicator
    @IBOutlet var activityIndicatorView: UIView!
    
    /// Error view
    @IBOutlet var errorView: UIView!
    
    /// Error label
    @IBOutlet var errorLabel: UILabel!
    
    /// Pagination offset
    var collectionOffset = 0
    
    /// Pagination page size
    var collectionPageSize = 10
    
    /// Utility used for dynamic types
    private lazy var scaledFont: ScaledFont = {
         return ScaledFont()
     }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Accessibility
        applyAccessibilityAttributes()
        setupDynamicFonts()
        
        // Configure Collection View
        configureCollectionView()
        
        // Load APODs
        activityIndicatorView.isHidden = false
        fetch(count: collectionPageSize, offset: collectionOffset) {
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
        collectionView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        fetch(count: 10) {
            self.collectionView.refreshControl?.endRefreshing()
        }
    }

    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetails" {
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems {
                let selectedApod = dataSource.element(at: selectedIndexPath[0])
                if let detailViewController = segue.destination as? DetailViewController {
                    detailViewController.apod = selectedApod
                }
            }
        }
    }
        
    // MARK: Networking
    
    func fetch(count: Int, offset: Int = 0, completion: (() -> Void)? = nil) {
        client.fetch(count: count, offset: offset) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
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
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.width * 1.2)
    }
}

// MARK: Accessibility

extension DiscoverViewController {
    
    private func applyAccessibilityAttributes() {
        errorView.isAccessibilityElement = true
        errorView.accessibilityTraits = .button
        errorView.accessibilityLabel = errorLabel.text
        errorView.accessibilityHint = "Double tap to load the view one more time."
    }
    
    private func setupDynamicFonts() {
        errorLabel.font = scaledFont.font(forTextStyle: .body)
        errorLabel.adjustsFontForContentSizeCategory = true
    }
}
