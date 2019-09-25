//
//  Endpoint.swift
//  Cosmos
//
//  Created by Samuel Yanez on 7/22/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import Foundation

protocol Endpoint {
    var base: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
}

extension Endpoint {
    var urlComponents: URLComponents {
        
        var components = URLComponents(string: base)!
        components.path = path
        components.queryItems = queryItems
        
        return components
    }
    
    var request: URLRequest {
        return URLRequest(url: urlComponents.url!)
    }
}

enum CosmosEndpoint {
    case today(thumbnails: Bool)
    case dated(date: Date, thumbnails: Bool)
    case ranged(from: Date, to: Date, thumbnails: Bool)
    case randomized(count: Int, thumbnails: Bool)
}

extension CosmosEndpoint: Endpoint {
    
    var base: String {
        return Environment.shared.baseUrl
    }
    
    var path: String {
        return "/v1/cosmos"
    }
    
    var formatter: DateFormatter {
        return DateFormatter(locale: Locale(identifier: "en_US_POSIX"), format: "yyyy-MM-dd")
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .today(let thumbnails):
            return [
                URLQueryItem(name: "thumbnails", value: String(thumbnails))
            ]
        case .dated(let date, let thumbnails):
            return [
                URLQueryItem(name: "date", value: formatter.string(from: date)),
                URLQueryItem(name: "thumbnails", value: String(thumbnails))
            ]
        case .ranged(let from, let to, let thumbnails):
            return [
                URLQueryItem(name: "start_date", value: formatter.string(from: from)),
                URLQueryItem(name: "end_date", value: formatter.string(from: to)),
                URLQueryItem(name: "thumbnails", value: String(thumbnails))
            ]
        case .randomized(let count, let thumbnails):
            return [
                URLQueryItem(name: "count", value: String(count)),
                URLQueryItem(name: "thumbnails", value: String(thumbnails))
            ]
        }
    }
}
