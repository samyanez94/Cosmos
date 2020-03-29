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
            fatalError("Unable to locate or create the documents directory")
        }
        return documentsDirectoryUrl
    }
    
    static var applicationSupportDirectoryUrl: URL {
        guard let applicationSupportDirectoryUrl = try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else {
            fatalError("Unable to locate or create the application support directory")
        }
        return applicationSupportDirectoryUrl
    }
}
