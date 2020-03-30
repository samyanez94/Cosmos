//
//  Bundle+Extensions.swift
//  Cosmos
//
//  Created by Samuel Yanez on 3/28/20.
//  Copyright © 2020 Samuel Yanez. All rights reserved.
//

import Foundation

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
