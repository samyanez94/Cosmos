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
    var apods = OrderedSet<APOD>()
    
    init(tableView: UITableView) {
        self.tableView = tableView
    }
    
    func update(withCollection collection: [APOD]) {
        apods = OrderedSet(withCollection: collection)
    }
    
    func element(at indexPath: IndexPath) -> APOD {
        apods.element(at: indexPath.row)
    }
    
    func append(_ apods: [APOD]) {
        self.apods.append(apods)
    }
    
    @discardableResult func remove(_ apod: APOD) -> APOD? {
        return apods.remove(apod)
    }
    
    @discardableResult func removeElement(at indexPath: IndexPath) -> APOD? {
        return apods.remove(apods[indexPath.row])
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
        setImageView(for: cell, viewModel: viewModel)
                
        return cell
    }
    
    private func setImageView(for cell: FavoritesCell, viewModel: APODViewModel) {
        guard let url = viewModel.thumbnailUrl else {
            cell.thumbnailImageView.image = DiscoverCell.placeholderImage
            return
        }
        cell.thumbnailImageView.af_setImage(withURL: url, imageTransition: .crossDissolve(0.2)) { data in
            if data.response?.statusCode == 404 {
                cell.thumbnailImageView.image = DiscoverCell.placeholderImage
            }
        }
    }
}
