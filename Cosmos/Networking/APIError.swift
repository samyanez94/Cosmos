//
//  APIError.swift
//  Cosmos
//
//  Created by Samuel Yanez on 4/28/20.
//  Copyright © 2020 Samuel Yanez. All rights reserved.
//

import Foundation

enum APIError: LocalizedError {
    case incorrectParameters
    case requestError
    case invalidResponse
    case responseUnsuccessful
    case invalidData
    case jsonParsingError
    
    var errorDescription: String {
        switch self {
        case .incorrectParameters: return "Incorrect parameters for request"
        case .requestError: return "Request error"
        case .invalidResponse: return "Invalid response"
        case .responseUnsuccessful: return "Response unsuccessful"
        case .invalidData: return "Invalid data"
        case .jsonParsingError: return "JSON parsing error"
        }
    }
}
