//
//  EnvironmentManager.swift
//  Cosmos
//
//  Created by Samuel Yanez on 9/24/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import Foundation

protocol EnvironmentManaging {
    var description: String { get }
    var baseUrl: String { get }
}

final class EnvironmentManager: EnvironmentManaging {
    
    private enum Keys: String {
        case buildConfiguration = "Build configuration"
        case baseUrl = "Cosmos base URL"
    }
    
    private enum Environments: String {
        case debug = "Debug"
        case stage = "Stage"
        case production = "Production"
    }
    
    static let shared: EnvironmentManaging = EnvironmentManager()
        
    var description: String {
        if let infoDictionary = Bundle.main.infoDictionary, let buildConfiguration = infoDictionary[Keys.buildConfiguration.rawValue] as? String {
            if buildConfiguration == Environments.debug.rawValue {
                return Environments.stage.rawValue
            } else {
                return Environments.production.rawValue
            }
        }
        return ""
    }
    
    var baseUrl: String {
        if let infoDictionary = Bundle.main.infoDictionary, let baseUrl = infoDictionary[Keys.baseUrl.rawValue] as? String {
            return baseUrl
        }
        return ""
    }
}
