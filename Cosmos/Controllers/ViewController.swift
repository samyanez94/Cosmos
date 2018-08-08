//
//  ViewController.swift
//  Cosmos
//
//  Created by Samuel Yanez on 7/21/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let pendingOperations = PendingOperations()
    
    /// API Client
    let client = CosmosAPIClient()
    
    /// Data Source
    var dataSource: [APOD] = []
    
    /// Collection View
    @IBOutlet var collectionView: UICollectionView! {
        willSet {
            let nib = UINib(nibName: "CosmosCell", bundle: nil)
            newValue.register(nib, forCellWithReuseIdentifier: CosmosCell.identifier)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        getAPOD()
    }
    
    func getAPOD() {
        client.downloadAPOD(fromDate: Date()) { [unowned self] (apod, error) in
            
            if let apod = apod {
                self.dataSource = apod
                self.collectionView.reloadData()
            } else {
                print(error?.localizedDescription)
            }
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CosmosCell.identifier, for: indexPath) as! CosmosCell
        
        let apod = dataSource[indexPath.row]
        let viewModel = CosmosCellViewModel(apod: apod)
        
        cell.configure(with: viewModel)
        
        if apod.imageState == .placeholder {
            downloadArtwork(for: apod, atIndexPath: indexPath)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "apodHeader", for: indexPath)
        }
        
        return UICollectionReusableView()
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

