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
    private(set) var apods: [APOD] = []
    
    /// The identifier for the footer cell
    private let footerCellIdentifier = "com.samuelyanez.CosmosCellFooter"
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    func object(at indexPath: IndexPath) -> APOD {
        return apods[indexPath.row]
    }
    
    func append(_ apods: [APOD]) {
        for apod in apods {
            if !self.apods.contains(apod) {
                self.apods.append(apod)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return apods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerCellIdentifier, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CosmosCell.identifier, for: indexPath) as? CosmosCell {
        
            let apod = apods[indexPath.row]
            
            let viewModel = APODViewModel(with: apod)
            
            cell.titleLabel.text = viewModel.title
            cell.dateLabel.text = viewModel.date
            
            cell.activityIndicator.startAnimating()
            
            let url: URL? = {
                switch apod.mediaType {
                case .image:
                    return URL(string: apod.url)
                case .video:
                    if let thumbnailUrl = apod.thumbnailUrl {
                        return URL(string: thumbnailUrl)
                    }
                    return nil
                }
            }()
            
            // TODO: Handle case where there is no thumbnail URL
            if let url = url {
                cell.imageView.af_setImage(withURL: url, imageTransition: .crossDissolve(0.2)) { _ in
                    cell.activityIndicator.stopAnimating()
                }
            } else {
                print("Error: No thumbnail URL")
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}
