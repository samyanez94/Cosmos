//
//  Environment.swift
//  Cosmos
//
//  Created by Samuel Yanez on 9/24/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import Foundation

class Environment {
    
    static let shared = Environment()
    
    private init() { }
    
    private var buildConfigurationKey: String {
        "Build configuration"
    }
    
    private var infoDictionary: [String: Any]? {
        Bundle.main.infoDictionary
    }
    
    private var baseUrlKey: String {
        "Cosmos base URL"
    }
    
    var description: String {
        if let infoDictionary = infoDictionary, let buildConfiguration = infoDictionary[buildConfigurationKey] as? String {
            if buildConfiguration == "Debug" {
                return "Stage"
            } else {
                return "Production"
            }
        }
        return ""
    }
    
    var baseUrl: String {
        if let infoDictionary = Bundle.main.infoDictionary, let baseUrl = infoDictionary[baseUrlKey] as? String {
            return baseUrl
        }
        return ""
    }
}
