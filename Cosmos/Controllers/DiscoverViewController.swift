//
//  ViewController.swift
//  Cosmos
//
//  Created by Samuel Yanez on 7/21/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import UIKit

final class DiscoverViewController: UIViewController {
    
    /// Different view states
    private enum State {
        case loading
        case error
        case loaded(data: [ApodViewModel])
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
            messageView.refreshButtonHandler = { [weak self] in
                guard let self = self else { return }
                self.state = .loading
                self.fetch(count: self.pageSize, offset: self.paginationOffset)
            }
        }
    }
    
    /// API Client
    private lazy var client = CosmosClient()
    
    /// Data Source
    private lazy var dataSource = collectionViewDataSource()
    
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
            case .error:
                activityIndicator.stopAnimating()
                messageView.isHidden = false
                collectionView.isHidden = true
            case .loaded(let data):
                activityIndicator.stopAnimating()
                messageView.isHidden = true
                collectionView.isHidden = false
                let animate = collectionView.numberOfItems(inSection: 0) != 0
                insert(data, animate: animate)
            }
        }
    }
    
    /// The identifier for the footer cell
    private static let footerCellIdentifier = "com.samuelyanez.CosmosCellFooter"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = DiscoverViewStrings.title.localized
        fetch(count: pageSize, offset: paginationOffset) { [weak self] in
            guard let self = self else { return }
            self.paginationOffset += self.pageSize
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
                self.state = .loaded(data: apods.reversed().map({ ApodViewModel(apod: $0) }))
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
        // Apply initial snapshot
        var snapshot = NSDiffableDataSourceSnapshot<Section, ApodViewModel>()
        snapshot.appendSections(Section.allCases)
        dataSource.apply(snapshot, animatingDifferences: false)
        return dataSource
    }
    
    private func insert(_ identifiers: [ApodViewModel], animate: Bool = true) {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems(identifiers)
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
        if collectionView.numberOfItems(inSection: indexPath.section) == indexPath.row + 1 {
            fetch(count: pageSize, offset: paginationOffset) { [weak self] in
                guard let self = self else { return }
                self.paginationOffset += self.pageSize
            }
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
