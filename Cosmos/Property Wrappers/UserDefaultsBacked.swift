//
//  Storage.swift
//  Cosmos
//
//  Created by Samuel Yanez on 11/29/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import Foundation

@propertyWrapper struct UserDefaultsBacked<T> {
    let key: String
    let defaultValue: T

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
