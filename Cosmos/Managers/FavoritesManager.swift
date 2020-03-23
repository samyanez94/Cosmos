//
//  FavoritesManager.swift
//  Cosmos
//
//  Created by Samuel Yanez on 3/22/20.
//  Copyright © 2020 Samuel Yanez. All rights reserved.
//

import Foundation

protocol FavoritesManaging {
    var isRefreshRequired: Bool { get }
    
    func getFavorites(completion: (([Apod]) -> Void))
    
    func isFavorite(_ apod: Apod, completion: ((Bool) -> Void))
    
    func addToFavorites(_ apod: Apod)
    
    func removeFromFavorites(_ apod: Apod)
}

class FavoritesManager: FavoritesManaging {
    
    static var shared = FavoritesManager()
    
    var isRefreshRequired: Bool = true
        
    static let url = FileManager.documentDirectoryUrl.appendingPathComponent("favorites.plist")
    
    @FileSystemBacked(url: url, defaultValue: [])
    var favorites: [Apod]
    
    func getFavorites(completion: (([Apod]) -> Void)) {
        isRefreshRequired = false
        completion(favorites)
    }
    
    func isFavorite(_ apod: Apod, completion: ((Bool) -> Void)) {
        completion(favorites.contains(apod))
    }
    
    func addToFavorites(_ apod: Apod) {
        isRefreshRequired = true
        favorites.append(apod)
    }
    
    func removeFromFavorites(_ apod: Apod) {
        isRefreshRequired = true
        favorites.removeAll { $0 == apod }
    }
}
