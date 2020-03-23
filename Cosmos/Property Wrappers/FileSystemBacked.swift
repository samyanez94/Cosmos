//
//  FileSystemBacked.swift
//  Cosmos
//
//  Created by Samuel Yanez on 3/23/20.
//  Copyright © 2020 Samuel Yanez. All rights reserved.
//

import Foundation

@propertyWrapper struct FileSystemBacked<T: Codable> {
    let url: URL
    let defaultValue: T
    
    let encoder = PropertyListEncoder()
    let decoder = PropertyListDecoder()
    
    var wrappedValue: T {
        get {
            guard let data = try? Data(contentsOf: url), let wrappedValue = try? decoder.decode(T.self, from: data) else { return defaultValue }
            return  wrappedValue
        }
        set {
            guard let data = try? encoder.encode(newValue) else { return }
            do {
                 try data.write(to: url)
             } catch {
                 print("Error writting to file: \(error)")
             }
        }
    }
}
