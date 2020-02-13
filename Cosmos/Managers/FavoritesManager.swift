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
    
    func getFavorites(completion: (([Date]) -> Void))
    
    func isFavorite(_ date: Date, completion: ((Bool) -> Void))
    
    func addToFavorites(_ date: Date)
    
    func removeFromFavorites(_ date: Date)
}

class UserDefaultsFavoritesManager: FavoritesManaging {
    
    static var shared: FavoritesManaging = UserDefaultsFavoritesManager()
    
    var isRefreshRequired: Bool = true
    
    @Storage(key: "favorites", defaultValue: [])
    var favorites: [Date]
    
    func getFavorites(completion: (([Date]) -> Void)) {
        isRefreshRequired = false
        completion(favorites)
    }
    
    func isFavorite(_ date: Date, completion: ((Bool) -> Void)) {
        completion(favorites.contains(date))
    }
    
    func addToFavorites(_ date: Date) {
        isRefreshRequired = true
        favorites.append(date)
    }
    
    func removeFromFavorites(_ date: Date) {
        isRefreshRequired = true
        favorites.removeAll { $0 == date }
    }
}
