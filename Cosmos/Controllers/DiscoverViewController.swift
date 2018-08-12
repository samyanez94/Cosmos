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
    
    var date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        fetch(from: date)
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
    
    // Collection View Delegate
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (dataSource.apods.count - 1 == indexPath.row) {
            if let date = Calendar.current.date(byAdding: .day, value: -11, to: self.date) {
                self.date = date
                fetch(from: date)
            }
        }
    }
    
    // Networking
    func fetch(from date: Date) {
        client.downloadAPODs(to: date) { [unowned self] (apods, error) in
            
            if let error = error {
                print(error.localizedDescription)
            }
        
            if let apods = apods {
                self.dataSource.append(apods)
                self.collectionView.reloadData()
            }
        }
    }
}
