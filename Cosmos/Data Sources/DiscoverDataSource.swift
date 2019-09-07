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
    
    /// List of astronomy pictures to display by the collection view.
    private(set) var apods: SortedSet<APOD> = SortedSet()
    
    /// The identifier for the footer cell
    private let footerCellIdentifier = "com.samuelyanez.CosmosCellFooter"
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    func element(at indexPath: IndexPath) -> APOD {
        return apods.element(at: indexPath.row)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CosmosCell.identifier, for: indexPath) as! CosmosCell
        
        let apod = apods.element(at: indexPath.row)
        
        let viewModel = APODViewModel(with: apod)
        
        cell.titleLabel.text = viewModel.title
        cell.dateLabel.text = viewModel.date
        
        cell.activityIndicator.startAnimating()
        
        setImageView(for: cell, apod: apod)
        
        return cell
    }
    
    private func setImageView(for cell: CosmosCell, apod: APOD) {
        if let url = getUrl(from: apod) {
            cell.imageView.af_setImage(withURL: url, imageTransition: .crossDissolve(0.2)) { _ in
                cell.activityIndicator.stopAnimating()
            }
        // TODO: Handle case where there is no URL
        } else {
            print("Error: No thumbnail URL")
        }
    }
    
    private func getUrl(from apod: APOD) -> URL? {
        switch apod.mediaType {
        case .image:
            return URL(string: apod.url)
        case .video:
            if let thumbnailUrl = apod.thumbnailUrl {
                return URL(string: thumbnailUrl)
            }
            return nil
        }
    }
}
