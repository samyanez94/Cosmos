//
//  CosmosError.swift
//  Cosmos
//
//  Created by Samuel Yanez on 12/8/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import Foundation

enum CosmosError: Error {
    case invalidURL
}

extension CosmosError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL for for APOD.", comment: "")
        }
    }
}
