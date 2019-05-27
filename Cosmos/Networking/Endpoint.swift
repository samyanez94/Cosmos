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
    case today
    case dated(date: Date)
    case ranged(from: Date, to: Date)
    case randomized(count: Int)
}

extension CosmosEndpoint: Endpoint {

    private var key: String {
        return "kMfnNhMKgdodjARiUj98FhQ9W0ogrnGjdnBda66n"
    }
    
    var base: String {
        return "https://api.nasa.gov"
    }
    
    var path: String {
        return "/planetary/apod"
    }
    
    var formatter: DateFormatter {
        return DateFormatter(locale: Locale(identifier: "en_US_POSIX"), format: "yyyy-MM-dd")
    }

    var queryItems: [URLQueryItem] {
        switch self  {
        case .today:
            return [
                URLQueryItem(name: "api_key", value: key)
            ]
        case .dated(let date):
            return [
                URLQueryItem(name: "api_key", value: key),
                URLQueryItem(name: "date", value: formatter.string(from: date))
            ]
        case .ranged(let from, let to):
            return [
                URLQueryItem(name: "api_key", value: key),
                URLQueryItem(name: "start_date", value: formatter.string(from: from)),
                URLQueryItem(name: "end_date", value: formatter.string(from: to))
            ]
        case .randomized(let count):
            return [
                URLQueryItem(name: "api_key", value: key),
                URLQueryItem(name: "count", value: String(count))
            ]
        }
    }
}
