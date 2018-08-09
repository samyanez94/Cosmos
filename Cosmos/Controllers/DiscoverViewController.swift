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
    @IBOutlet var collectionView: UICollectionView! {
        willSet {
            let nib = UINib(nibName: "CosmosCell", bundle: nil)
            newValue.register(nib, forCellWithReuseIdentifier: CosmosCell.identifier)
        }
    }
    
    /// Data Source
    lazy var dataSource: DiscoverDataSource = {
        return DiscoverDataSource(collectionView: collectionView, apods: [])
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        getAPOD()
    }
    
    func getAPOD() {
        client.downloadAPOD(fromDate: Date()) { [unowned self] (apods, error) in
            
            if let apods = apods {
                self.dataSource.update(with: apods)
                self.collectionView.reloadData()
            } else {
                print(error?.localizedDescription)
            }
        }
    }
}

