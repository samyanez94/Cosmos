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
    
    init(tableView: UITableView) {
        self.tableView = tableView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesCell.identifier, for: indexPath) as! FavoritesCell
        
        cell.textLabel?.text = "Bonjour!"
        cell.imageView?.image = UIImage(systemName: "flame")
        
        return cell
    }
}
