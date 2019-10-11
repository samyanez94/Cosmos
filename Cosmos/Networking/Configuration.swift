//
//  Configuration.swift
//  Cosmos
//
//  Created by Samuel Yanez on 10/10/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import Foundation

struct Configuration {
    static let UITestArgument = "UI-TEST"
    
    static var isUITest: Bool {
        return ProcessInfo.processInfo.arguments.contains(UITestArgument)
    }
}
