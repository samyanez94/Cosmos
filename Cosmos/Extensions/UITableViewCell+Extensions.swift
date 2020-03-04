//
//  UITableViewCell+Extensions.swift
//  Cosmos
//
//  Created by Samuel Yanez on 11/5/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
    
    static var defaultReuseIdentifier: String {
        "com.samuelyanez.\(defaultName)"
    }
    
    static var defaultNib: UINib {
        getNib(nibName: defaultName)
    }
    
    static func getNib(nibName: String) -> UINib {
        return UINib(nibName: nibName, bundle: Bundle(for: self))
    }
    
    static func getCellFromDefaultNib<T: UITableViewCell>() -> T {
        return getCell(fromNib: defaultName)
    }
    
    static func getCell<T: UITableViewCell>(fromNib nibName: String) -> T {
        guard let cell = getNib(nibName: nibName).instantiate(withOwner: nil, options: nil).first as? T else {
            fatalError("\(self) has not been initialized properly from nib \(nibName)")
        }
        return cell
    }
    
    static func registerNib(for tableView: UITableView) {
        registerNib(for: tableView, reuseIdentifier: defaultReuseIdentifier)
    }
    
    static func registerNib(for tableView: UITableView, reuseIdentifier: String) {
        let nib = UINib(nibName: defaultName, bundle: Bundle(for: self))
        tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
    }
    
    static func dequeue<T: UITableViewCell>(from tableView: UITableView, for indexPath: IndexPath) -> T {
        return dequeue(from: tableView, for: indexPath, reuseIdentifier: defaultReuseIdentifier)
    }
    
    static func dequeue<T: UITableViewCell>(from tableView: UITableView, for indexPath: IndexPath, reuseIdentifier: String) -> T {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue cell of type \(T.self) with reuse identifier '\(reuseIdentifier)'")
        }
        return cell
    }
}

extension UITableView {
    func reloadFirstSection(with animation: UITableView.RowAnimation = .fade) {
        reloadSections(IndexSet(integer: 0), with: animation)
    }
}
