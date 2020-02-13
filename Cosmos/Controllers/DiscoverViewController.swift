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
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    /// Message view
    @IBOutlet var messageView: UIView!
    
    /// Message image
    @IBOutlet var messageImage: UIImageView!
    
    /// Message label
    @IBOutlet var messageLabel: UILabel! {
        didSet {
            messageLabel.font = DynamicFont.shared.font(forTextStyle: .body)
            messageLabel.adjustsFontForContentSizeCategory = true
            messageLabel.text = DiscoverViewStrings.errorMessage.localized
        }
    }
    
    /// API Client
    lazy var client = CosmosClient()
    
    /// Data Source
    lazy var dataSource: DiscoverDataSource = {
        return DiscoverDataSource(collectionView: collectionView)
    }()
    
    /// Pagination offset
    var collectionOffset = 0
    
    /// Pagination page size
    var collectionPageSize = 10
    
    enum State {
        case loading
        case displayCollection
        case error
    }
    
    var state: State = .loading {
        didSet {
            switch state {
            case .loading:
                activityIndicator.startAnimating()
                messageView.isHidden = true
                collectionView.isHidden = true
            case .displayCollection:
                activityIndicator.stopAnimating()
                messageView.isHidden = true
                collectionView.isHidden = false
            case .error:
                activityIndicator.stopAnimating()
                messageView.isHidden = false
                collectionView.isHidden = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = DiscoverViewStrings.title.localized
        fetch(count: collectionPageSize, offset: collectionOffset)
    }
    
    override func viewWillLayoutSubviews() {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: Collection View
    
    @objc func handleRefreshControl() {
        fetch(count: collectionPageSize) {
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
            guard let self = self else { return }
            switch result {
            case .failure:
                self.state = .error
            case .success(let apods):
                if apods.isEmpty {
                    self.state = .error
                } else {
                    self.dataSource.append(apods.sorted(by: >))
                    self.collectionView.reloadData()
                    self.state = .displayCollection
                    self.collectionOffset = offset + self.collectionPageSize
                }
            }
            completion?()
        }
    }
    
    @IBAction func didTapOnRefreshButton(_ sender: Any) {
        state = .loading
        fetch(count: collectionPageSize, offset: collectionOffset)
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
        return CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.width * 1.1)
    }
}
