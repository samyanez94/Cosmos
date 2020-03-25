//
//  EnvironmentManager.swift
//  Cosmos
//
//  Created by Samuel Yanez on 9/24/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import Foundation

protocol EnvironmentManaging {
    var environment: Environment { get }
}

final class EnvironmentManager: EnvironmentManaging {
    
    static let shared: EnvironmentManaging = EnvironmentManager()
    
    private let buildConfigurationKey = "Build configuration"
    
    var environment: Environment {
        guard let infoDictionary = Bundle.main.infoDictionary, let buildConfiguration = infoDictionary[buildConfigurationKey] as? String else {
            fatalError("Unable to get build configuration from info dictionary")
        }
        if buildConfiguration == Environment.debug.name {
            return Environment.debug
        } else {
            return Environment.production
        }
    }
}

enum Environment {
    case debug
    case production
    
    var name: String {
        switch self {
        case .debug: return "Debug"
        case .production: return "Production"
        }
    }
    
    var url: String {
        switch self {
        case .debug: return "https://cosmos-app-staging.herokuapp.com"
        case .production: return "https://cosmos-app-production.herokuapp.com"
        }
    }
}
