//
//  ViewController.swift
//  Cosmos
//
//  Created by Samuel Yanez on 7/21/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {
    
    /// Different view states
    private enum State {
        case loading
        case displayCollection
        case error
    }
    
    /// Collection view sections
    private enum Section: CaseIterable {
        case main
    }
    
    /// Collection view
    @IBOutlet private var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = dataSource
            collectionView.isHidden = true
            collectionView.refreshControl = UIRefreshControl()
            collectionView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        }
    }
    
    /// Ativity indicator
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    /// Message view
    @IBOutlet private var messageView: MessageView! {
        didSet {
            messageView.imageView.image = UIImage(named: "Error Illustration")
            messageView.label.text = MessageViewStrings.errorMessage.localized
            messageView.refreshButton.isHidden = false
            messageView.refreshButton.titleLabel?.text = MessageViewStrings.refreshButton.localized
            messageView.refreshButtonHandler = { [unowned self] in
                self.state = .loading
                self.fetch(count: self.pageSize, offset: self.paginationOffset)
            }
        }
    }
    
    /// API Client
    private lazy var client = CosmosClient()
    
    /// Data Source
    private lazy var dataSource = collectionViewDataSource()
    
    /// Astronomy pictures of the day
    private var viewModels = OrderedSet<ApodViewModel>()
    
    /// Pagination offset
    private var paginationOffset = 0
    
    /// Pagination page size
    private var pageSize = 10
    
    /// View state
    private var state: State = .loading {
        didSet {
            switch state {
            case .loading:
                activityIndicator.startAnimating()
                messageView.isHidden = true
                collectionView.isHidden = true
            case .displayCollection:
                activityIndicator.stopAnimating()
                updateDataSource(with: viewModels)
                messageView.isHidden = true
                collectionView.isHidden = false
            case .error:
                activityIndicator.stopAnimating()
                messageView.isHidden = false
                collectionView.isHidden = true
            }
        }
    }
    
    /// The identifier for the footer cell
    private static let footerCellIdentifier = "com.samuelyanez.CosmosCellFooter"
    
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
                switch apods.isEmpty {
                case true:
                    self.state = .error
                case false:
                    let viewModels = apods.reversed().map({ ApodViewModel(apod: $0) })
                    self.viewModels.append(contentsOf: viewModels)
                    self.state = .displayCollection
                    self.paginationOffset = offset + self.pageSize
                }
            }
            completion?()
        }
    }
}

// MARK: Collection Data Source

extension DiscoverViewController {
    private func collectionViewDataSource() -> UICollectionViewDiffableDataSource<Section, ApodViewModel> {
        let dataSource =  UICollectionViewDiffableDataSource<Section, ApodViewModel>(collectionView: collectionView) { collectionView, indexPath, viewModel in
            let cell: DiscoverCell = DiscoverCell.dequeue(from: collectionView, for: indexPath)
            cell.viewModel = viewModel
            return cell
        }
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DiscoverViewController.footerCellIdentifier, for: indexPath)
        }
        return dataSource
    }
    
    private func updateDataSource(with viewModels: OrderedSet<ApodViewModel>, animate: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ApodViewModel>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(viewModels.elements)
        dataSource.apply(snapshot, animatingDifferences: animate)
    }
}

// MARK: UICollectionView Delegate

extension DiscoverViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let viewModel = dataSource.itemIdentifier(for: indexPath), let detailViewController = storyboard?.instantiateViewController(identifier: DetailViewController.identifier, creator: { coder in
            DetailViewController(coder: coder, viewModel: viewModel)
        }) {
            show(detailViewController, sender: collectionView.cellForItem(at: indexPath))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if viewModels.count == indexPath.row + 1 {
            fetch(count: pageSize, offset: paginationOffset)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            fatalError("Unable to cast UICollectionViewLayout as UICollectionViewFlowLayout")
        }
        let itemHeight: CGFloat = 425.0
        let minimumItemWidth: CGFloat = 280.0
        let sectionInset = flowLayout.sectionInset
        let availableWidth = collectionView.bounds.size.width - sectionInset.left - sectionInset.right
        let maxNumberOfItemsPerRow = (availableWidth / minimumItemWidth).rounded(.down)
        let interItemspace = flowLayout.minimumInteritemSpacing * (maxNumberOfItemsPerRow - 1)
        let itemWidth = (availableWidth - interItemspace) / maxNumberOfItemsPerRow
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

// MARK: ScrollableViewController

extension DiscoverViewController: ScrollableViewController {
    func scrollToTop() {
        self.collectionView.setContentOffset(CGPoint(x: 0, y: -120), animated: true)
    }
}
