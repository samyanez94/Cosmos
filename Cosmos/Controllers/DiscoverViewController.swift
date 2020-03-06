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
    @IBOutlet var messageView: MessageView! {
        didSet {
            messageView.delegate = self
            messageView.setImage(to: UIImage(systemName: "exclamationmark.circle"))
            messageView.setMessage(to: MessageViewStrings.errorMessage.localized)
            messageView.refreshButton.isHidden = false
            messageView.refreshButton.titleLabel?.text = MessageViewStrings.refreshButton.localized
        }
    }
    
    /// API Client
    lazy var client = CosmosClient()
    
    /// Data Source
    lazy var dataSource: DiscoverDataSource = {
        return DiscoverDataSource(collectionView: collectionView)
    }()
    
    /// Pagination offset
    var paginationOffset = 0
    
    /// Pagination page size
    var pageSize = 10
    
    /// Different view states
    enum State {
        case loading
        case displayCollection
        case error
    }
    
    /// View state
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
        
        fetch(count: pageSize, offset: paginationOffset)
    }
    
    // MARK: Collection View
    
    @objc func handleRefreshControl() {
        fetch(count: pageSize) {
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
        
    // MARK: Networking
    
    private func fetch(count: Int, offset: Int = 0, completion: (() -> Void)? = nil) {
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
                    self.paginationOffset = offset + self.pageSize
                }
            }
            completion?()
        }
    }
    
    func scrollToTop() {
        self.collectionView.setContentOffset(CGPoint(x: 0, y: -120), animated: true)
    }
}

// MARK: UICollectionView Delegate

extension DiscoverViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let detailViewController = storyboard?.instantiateViewController(identifier: DetailViewController.identifier, creator: { coder in
            DetailViewController(coder: coder, viewModel: ApodViewModel(apod: self.dataSource.element(at: indexPath)))
        }) {
            show(detailViewController, sender: collectionView.cellForItem(at: indexPath))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if dataSource.apods.count == indexPath.row + 1 {
            fetch(count: pageSize, offset: paginationOffset)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.width * 1.1)
    }
}

// MARK: MessageView Delegate

extension DiscoverViewController: MessageViewDelegate {
    func messageView(_ messageView: MessageView, didTapOnRefreshButton refreshButton: UIButton) {
        state = .loading
        fetch(count: pageSize, offset: paginationOffset)
    }
}
