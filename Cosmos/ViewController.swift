//
//  ViewController.swift
//  Cosmos
//
//  Created by Samuel Yanez on 7/21/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    /// API Client
    let client = CosmosAPIClient()
    
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
        
        client.downloadAPOD(fromDate: Date()) { (apod, error) in
            if let apod = apod {
                print(apod)
            } else {
                print(error)
            }
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Stub.apodDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: CosmosCell.identifier, for: indexPath) as! CosmosCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "apodHeader", for: indexPath)
        }
        return UICollectionReusableView()
    }
}

