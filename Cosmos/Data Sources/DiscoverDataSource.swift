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
    
    /// List of astronomy pictures of the day
    private(set) var apods = OrderedSet<Apod>()
    
    /// The identifier for the footer cell
    private let footerCellIdentifier = "com.samuelyanez.CosmosCellFooter"
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    func element(at indexPath: IndexPath) -> Apod {
        apods.element(at: indexPath.row)
    }
    
    func append(_ apods: [Apod]) {
        self.apods.append(apods)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        apods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerCellIdentifier, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: DiscoverCell = DiscoverCell.dequeue(from: collectionView, for: indexPath)
        let apod = apods.element(at: indexPath.row)
        let viewModel = ApodViewModel(apod: apod)
        cell.update(with: viewModel)
        return cell
    }
}
