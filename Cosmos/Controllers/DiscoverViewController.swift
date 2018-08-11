//
//  ViewController.swift
//  Cosmos
//
//  Created by Samuel Yanez on 7/21/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController, UICollectionViewDelegate {
        
    /// API Client
    let client = CosmosAPIClient()
    
    /// Collection View
    @IBOutlet var collectionView: UICollectionView!
    
    /// Data Source
    lazy var dataSource: DiscoverDataSource = {
        return DiscoverDataSource(collectionView: collectionView, apods: [])
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        donwloadBatch()
    }
    
    // Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetails" {
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems {
                let selectedAPOD = dataSource.apod(at: selectedIndexPath[0])
                let detailViewController = segue.destination as! DetailViewController
                
                detailViewController.apod = selectedAPOD
            }
        }
    }
    
    // Networking
    
    func donwloadBatch() {
        client.downloadAPODs(fromDate: Date()) { [unowned self] (apods, error) in
            
            if let apods = apods {
                self.dataSource.update(with: apods)
                self.collectionView.reloadData()
            }
        }
    }
    
    
}

