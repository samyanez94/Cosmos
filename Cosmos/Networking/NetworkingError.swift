//
//  NetworkingError.swift
//  Cosmos
//
//  Created by Samuel Yanez on 7/22/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import Foundation

enum CosmosNetworkingError: Error {
    case requestFailed
    case responseUnsuccessful
    case invalidData
    case jsonConversionFailure
    case jsonParsingError(message: String)
}
