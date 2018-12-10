//
//  DiscoverDataSource.swift
//  Cosmos
//
//  Created by Samuel Yanez on 8/8/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

class DiscoverDataSource: NSObject, UICollectionViewDataSource {
    
    /// Collection view.
    private let collectionView: UICollectionView
    
    /// List of astronomy pictures to display by the collection view.
    private(set) var apods: [APOD] = []
    
    /// The identifier for the footer cell
    private let footerCellIdentifier = "com.samuelyanez.CosmosCellFooter"
        
    init(collectionView: UICollectionView, apods: [APOD]) {
        self.collectionView = collectionView
        self.apods = apods
    }
    
    func apod(at indexPath: IndexPath) -> APOD {
        return apods[indexPath.row]
    }
    
    func append(_ apods: [APOD]) {
        self.apods.append(contentsOf: apods)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return apods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerCellIdentifier, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CosmosCell.identifier, for: indexPath) as! CosmosCell
        
        // Current apod
        let apod = self.apod(at: indexPath)
        
        // View model for the current apod
        let viewModel = APODViewModel(for: apod)
        
        // Update labels
        cell.updateLabels(for: viewModel)
        
        // Check for a valid url
        guard let url = URL(string: apod.url) else {
            return cell
        }
        
        // Switch media type
        switch apod.mediaType {
        case .image:
            cell.imageView.af_setImage(withURL: url)
        default:
            cell.imageView.image = #imageLiteral(resourceName: "invalid_placeholder")
        }
        
        // Return the cell
        return cell
    }
}
