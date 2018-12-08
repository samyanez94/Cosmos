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
    
    private let collectionView: UICollectionView
    private(set) var apods: [APOD] = []
        
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
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "com.samuelyanez.CosmosCellFooter", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CosmosCell.identifier, for: indexPath) as! CosmosCell
        
        let apod = apods[indexPath.row]
        
        cell.updateAppearence(for: APODViewModel(apod: apod))
        
        if apod.mediaType == .image {
            if let url = URL(string: apod.url) {
                cell.imageView.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "placeholder"), imageTransition: .crossDissolve(1))
            }
        } else {
            cell.imageView.image = #imageLiteral(resourceName: "invalid_placeholder")
        }
        return cell
    }
}
