//
//  NetworkingError.swift
//  Cosmos
//
//  Created by Samuel Yanez on 8/12/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import Foundation

enum CosmosNetworkingError: Error {
    case requestFailed
    case responseUnsuccessful
    case invalidData
    case jsonConversionFailure
    case jsonParsingError
}

extension CosmosNetworkingError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .requestFailed:
            return NSLocalizedString("Failed to send the request.", comment: "")
        case .responseUnsuccessful:
            return NSLocalizedString("No response received from the server.", comment: "")
        case .invalidData:
            return NSLocalizedString("Data received is not valid.", comment: "")
        case .jsonConversionFailure:
            return NSLocalizedString("Failed to convert the response into a JSON object.", comment: "")
        case .jsonParsingError:
            return NSLocalizedString("Failed to parse the JSON object.", comment: "")
        }
    }
}
