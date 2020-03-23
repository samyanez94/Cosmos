//
//  FavoritesManaging.swift
//  Cosmos
//
//  Created by Samuel Yanez on 3/22/20.
//  Copyright © 2020 Samuel Yanez. All rights reserved.
//

import Foundation

protocol FavoritesManaging {
    var isRefreshRequired: Bool { get }
    
    func getFavoriteDates(completion: (([Date]) -> Void))
    
    func isFavorite(_ apod: Apod, completion: ((Bool) -> Void))
    
    func addToFavorites(_ apod: Apod)
    
    func removeFromFavorites(_ apod: Apod)
}
