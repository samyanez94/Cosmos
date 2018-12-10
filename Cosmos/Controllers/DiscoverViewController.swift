//
//  ViewController.swift
//  Cosmos
//
//  Created by Samuel Yanez on 7/21/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {
        
    /// API Client
    let client: APIClient = CosmosAPIClient()
    
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
        collectionView.isHidden = true

        fetch() {
            self.collectionView.isHidden = false
        }
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetails" {
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems {
                let selectedAPOD = dataSource.apod(at: selectedIndexPath[0])
                let detailViewController = segue.destination as! DetailViewController
                
                detailViewController.apod = selectedAPOD
            }
        }
    }
        
    // MARK: Networking
    
    func fetch(completion: (() -> Void)? = nil) {
        client.fetch { [unowned self] (apods, error) in
            
            if let error = error {
                print(error.localizedDescription)
            }
        
            if let apods = apods {
                self.dataSource.append(apods)
                self.collectionView.reloadData()
                
                if let completion = completion {
                    completion()
                }
            }
        }
    }
    
    func scrollToTop() {
        self.collectionView.setContentOffset(CGPoint.zero, animated: true)
    }
}

// MARK: UICollectionView Delegate

extension DiscoverViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (dataSource.apods.count == indexPath.row + 1) {
            fetch()
        }
    }
}
