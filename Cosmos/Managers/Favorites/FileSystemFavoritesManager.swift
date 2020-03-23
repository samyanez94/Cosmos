//
//  FileSystemFavoritesManager.swift
//  Cosmos
//
//  Created by Samuel Yanez on 3/22/20.
//  Copyright © 2020 Samuel Yanez. All rights reserved.
//

import Foundation

class FileSystemFavoritesManager: FavoritesManaging {
    
    static var shared: FavoritesManaging = FileSystemFavoritesManager()
    
    var isRefreshRequired: Bool = true
        
    static let url = FileManager.documentDirectoryUrl.appendingPathComponent("favorites.plist")
    
    @FileSystemBacked(url: url, defaultValue: [])
    var favorites: [Date]
    
    func getFavoriteDates(completion: (([Date]) -> Void)) {
        isRefreshRequired = false
        completion(favorites)
    }
    
    func isFavorite(_ apod: Apod, completion: ((Bool) -> Void)) {
        completion(favorites.contains(apod.id))
    }
    
    func addToFavorites(_ apod: Apod) {
        isRefreshRequired = true
        favorites.append(apod.id)
    }
    
    func removeFromFavorites(_ apod: Apod) {
        isRefreshRequired = true
        favorites.removeAll { $0 == apod.id }
    }
}
