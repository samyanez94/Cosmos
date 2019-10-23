//
//  FavoritesViewController.swift
//  Cosmos
//
//  Created by Samuel Yanez on 10/22/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.dataSource = dataSource
        }
    }
    
    /// Data Source
    lazy var dataSource: FavoritesDataSource = {
        return FavoritesDataSource(tableView: tableView)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
