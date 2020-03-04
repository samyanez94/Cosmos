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
    private(set) var apods = OrderedSet<Apod>()
    
    init(tableView: UITableView) {
        self.tableView = tableView
    }
    
    func update(fromCollection collection: [Apod]) {
        apods = OrderedSet(fromCollection: collection)
    }
    
    func element(at indexPath: IndexPath) -> Apod {
        apods.element(at: indexPath.row)
    }
    
    func append(_ apods: [Apod]) {
        self.apods.append(apods)
    }
    
    @discardableResult func remove(_ apod: Apod) -> Apod? {
        apods.remove(apod)
    }
    
    @discardableResult func removeElement(at indexPath: IndexPath) -> Apod? {
        apods.remove(apods[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        apods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FavoritesCell = FavoritesCell.dequeue(from: tableView, for: indexPath)
        let apod = apods.element(at: indexPath.row)
        let viewModel = ApodViewModel(apod: apod)
        cell.update(with: viewModel)
        return cell
    }
}
