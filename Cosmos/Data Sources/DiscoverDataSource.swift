//
//  DiscoverDataSource.swift
//  Cosmos
//
//  Created by Samuel Yanez on 8/8/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import AlamofireImage
import Foundation
import UIKit

class DiscoverDataSource: NSObject, UICollectionViewDataSource {
    
    /// Collection view
    weak private var collectionView: UICollectionView?
    
    /// Astronomy pictures of the day
    private(set) var viewModels = OrderedSet<ApodViewModel>()
    
    /// The identifier for the footer cell
    private let footerCellIdentifier = "com.samuelyanez.CosmosCellFooter"
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    func element(at indexPath: IndexPath) -> ApodViewModel {
        viewModels.element(at: indexPath.row)
    }
    
    func append(_ viewModels: [ApodViewModel]) {
        self.viewModels.append(viewModels)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerCellIdentifier, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: DiscoverCell = DiscoverCell.dequeue(from: collectionView, for: indexPath)
        cell.viewModel = viewModels.element(at: indexPath.row)
        return cell
    }
}
