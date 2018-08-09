//
//  DiscoverDataSource.swift
//  Cosmos
//
//  Created by Samuel Yanez on 8/8/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import Foundation
import UIKit

class DiscoverDataSource: NSObject, UICollectionViewDataSource {
    
    private let collectionView: UICollectionView
    private var apods: [APOD] = []
    
    init(collectionView: UICollectionView, apods: [APOD]) {
        self.collectionView = collectionView
        self.apods = apods
    }
    
    // MARK - Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return apods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CosmosCell.identifier, for: indexPath) as! CosmosCell
        
        let apod = apods[indexPath.row]
        let viewModel = CosmosCellViewModel(apod: apod)
        
        cell.configure(with: viewModel)
        
        if apod.imageState == .placeholder {
            downloadArtwork(for: apod, atIndexPath: indexPath)
        }
        return cell
    }
    
    // MARK - Helpers
    
    let pendingOperations = PendingOperations()
    
    func apod(at indexPath: IndexPath) -> APOD {
        return apods[indexPath.row]
    }
    
    func update(with apods: [APOD]) {
        self.apods = apods
    }
    
    func downloadArtwork(for apod: APOD, atIndexPath indexPath: IndexPath) {
        if let _ = pendingOperations.downloadsInProgress[indexPath] {
            return
        }
        
        let downloader = ArtworkDownloader(apod: apod)
        
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }
            DispatchQueue.main.async {
                self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                self.collectionView.reloadItems(at: [indexPath])
            }
        }
        
        pendingOperations.downloadsInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }
}
