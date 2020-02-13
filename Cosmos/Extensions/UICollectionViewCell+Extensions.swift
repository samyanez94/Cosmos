//
//  UICollectionViewCell+Extensions.swift
//  Cosmos
//
//  Created by Samuel Yanez on 11/5/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionViewCell {
    
    static var defaultReuseIdentifier: String {
        "com.samuelyanez.\(defaultName)"
    }
    
    static var defaultNib: UINib {
        getNib(nibName: defaultName)
    }
    
    static func getNib(nibName: String) -> UINib {
        return UINib(nibName: nibName, bundle: Bundle(for: self))
    }
    
    static func getCellFromDefaultNib<T: UICollectionViewCell>() -> T {
        return getCell(fromNib: defaultName)
    }
    
    static func getCell<T: UICollectionViewCell>(fromNib nibName: String) -> T {
        guard let cell = getNib(nibName: nibName).instantiate(withOwner: nil, options: nil).first as? T else {
            fatalError("\(self) has not been initialized properly from nib \(nibName)")
        }
        return cell
    }
    
    static func registerNib(for collectionView: UICollectionView) {
        registerNib(for: collectionView, reuseIdentifier: defaultReuseIdentifier)
    }
    
    static func registerNib(for collectionView: UICollectionView, reuseIdentifier: String) {
        let nib = UINib(nibName: defaultName, bundle: Bundle(for: self))
        collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    static func dequeue<T: UICollectionViewCell>(from collectionView: UICollectionView, for indexPath: IndexPath) -> T {
        return dequeue(from: collectionView, for: indexPath, reuseIdentifier: defaultReuseIdentifier)
    }
    
    static func dequeue<T: UICollectionViewCell>(from collectionView: UICollectionView, for indexPath: IndexPath, reuseIdentifier: String) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue cell of type \(T.self) with reuse identifier '\(reuseIdentifier)'")
        }
        return cell
    }
}
