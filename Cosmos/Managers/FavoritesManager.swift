//
//  FavoritesManager.swift
//  Cosmos
//
//  Created by Samuel Yanez on 10/24/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import Foundation

protocol FavoritesManaging {
    var isRefreshRequired: Bool { get }
    
    func getFavoriteDates(completion: (([Date]) -> Void))
    
    func isFavorite(_ apod: Apod, completion: ((Bool) -> Void))
    
    func addToFavorites(_ apod: Apod)
    
    func removeFromFavorites(_ apod: Apod)
}

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
