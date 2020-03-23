//
//  FileManager+Extensions.swift
//  Cosmos
//
//  Created by Samuel Yanez on 3/23/20.
//  Copyright © 2020 Samuel Yanez. All rights reserved.
//

import Foundation

extension FileManager {
    static var documentDirectoryUrl: URL {
        guard let documentsDirectoryUrl = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else {
            fatalError("Error unable to find documents directory")
        }
        return documentsDirectoryUrl
    }
}
