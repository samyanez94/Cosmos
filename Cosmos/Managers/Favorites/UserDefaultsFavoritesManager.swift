//
//  UserDefaultsFavoritesManager.swift
//  Cosmos
//
//  Created by Samuel Yanez on 3/22/20.
//  Copyright © 2020 Samuel Yanez. All rights reserved.
//

import Foundation

class UserDefaultsFavoritesManager: FavoritesManaging {
    
    static var shared: FavoritesManaging = UserDefaultsFavoritesManager()
    
    var isRefreshRequired: Bool = true
        
    @UserDefaultsBacked(key: "favorites", defaultValue: [])
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
