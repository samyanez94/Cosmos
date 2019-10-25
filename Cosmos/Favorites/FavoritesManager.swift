//
//  FavoritesManager.swift
//  Cosmos
//
//  Created by Samuel Yanez on 10/24/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import Foundation

protocol FavoritesManager {
    func getFavorites() -> [Date]
    
    func isFavorite(apod: APOD) -> Bool
    
    func addToFavorites(apod: APOD)
    
    func removeFromFavorites(apod: APOD)
}

struct CosmosFavoritesManager: FavoritesManager {
    private let favoritesUserDefaultsKey = "FAVORITE_APODS"
    
    func getFavorites() -> [Date] {
        UserDefaults.standard.array(forKey: favoritesUserDefaultsKey) as? [Date] ?? []
    }
    
    func isFavorite(apod: APOD) -> Bool {
        getFavorites().contains(apod.date)
    }
    
    func addToFavorites(apod: APOD) {
        var favorites = getFavorites()
        favorites.append(apod.date)
        UserDefaults.standard.set(favorites, forKey: favoritesUserDefaultsKey)
    }
    
    func removeFromFavorites(apod: APOD) {
        var favorites = getFavorites()
        favorites.removeAll { $0 == apod.date }
        UserDefaults.standard.set(favorites, forKey: favoritesUserDefaultsKey)
    }
}
