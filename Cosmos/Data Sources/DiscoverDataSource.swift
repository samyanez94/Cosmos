//
//  DiscoverDataSource.swift
//  Cosmos
//
//  Created by Samuel Yanez on 8/8/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class DiscoverDataSource: NSObject, UICollectionViewDataSource {
    
    /// Collection view.
    weak private var collectionView: UICollectionView?
    
    /// List of astronomy pictures of the day.
    private(set) var apods: SortedSet<APOD> = SortedSet()
    
    /// The identifier for the footer cell
    private let footerCellIdentifier = "com.samuelyanez.CosmosCellFooter"
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    func element(at indexPath: IndexPath) -> APOD {
        apods.element(at: indexPath.row)
    }
    
    func append(_ apods: [APOD]) {
        self.apods.append(apods)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return apods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerCellIdentifier, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: DiscoverCell = DiscoverCell.dequeue(from: collectionView, for: indexPath)
        
        let apod = apods.element(at: indexPath.row)
        
        // View model
        let viewModel = APODViewModel(apod: apod)
                
        // Setup cell
        cell.titleLabel.text = viewModel.title
        cell.dateLabel.text = viewModel.preferredDate ?? viewModel.date
        cell.activityIndicator.startAnimating()
        
        // Accessibility
        cell.applyAccessibilityAttributes(for: viewModel)
        
        // Load preview
        setImageView(for: cell, apod: apod)
        
        return cell
    }
    
    // TODO: Try to refactor or move this logic
    private func setImageView(for cell: DiscoverCell, apod: APOD) {
        if let url = apod.thumbnailUrl {
            cell.imageView.af_setImage(withURL: url, imageTransition: .crossDissolve(0.2)) { data in
                if data.response?.statusCode == 404 {
                    cell.imageView.image = DiscoverCell.placeholderImage
                }
                cell.activityIndicator.stopAnimating()
            }
        } else {
            cell.activityIndicator.stopAnimating()
            cell.imageView.image = DiscoverCell.placeholderImage
        }
    }
}
