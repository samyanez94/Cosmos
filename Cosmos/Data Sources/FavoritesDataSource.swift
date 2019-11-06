//
//  FavoritesDataSource.swift
//  Cosmos
//
//  Created by Samuel Yanez on 10/22/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import Foundation
import UIKit

class FavoritesDataSource: NSObject, UITableViewDataSource {

    /// Table view.
    weak private var tableView: UITableView?
    
    /// List of astronomy pictures of the day.
    private(set) var apods: SortedSet<APOD> = SortedSet()
    
    init(tableView: UITableView) {
        self.tableView = tableView
    }
    
    func element(at indexPath: IndexPath) -> APOD {
        return apods.element(at: indexPath.row)
    }
    
    func append(_ apod: APOD) {
         apods.append(apod)
     }
    
    func remove(_ apod: APOD) {
        apods.remove(apod)
    }
    
    func removeElement(at indexPath: IndexPath) {
        apods.remove(apods[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        apods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FavoritesCell = FavoritesCell.dequeue(from: tableView, for: indexPath)
        
        let apod = apods.element(at: indexPath.row)
        
        // View model
        let viewModel = APODViewModel(apod: apod)
        
        // Setup cell
        cell.dateLabel.text = viewModel.date
        cell.titleLabel.text = viewModel.title
        cell.explanationLabel.text = viewModel.explanation
        
        // Load preview
        setImageView(for: cell, apod: apod)
                
        return cell
    }
    
    private func setImageView(for cell: FavoritesCell, apod: APOD) {
        if let url = apod.thumbnailUrl {
            cell.thumbnailImageView.af_setImage(withURL: url, imageTransition: .crossDissolve(0.2))
        }
    }
}
