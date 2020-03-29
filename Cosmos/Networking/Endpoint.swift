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
    var queryItems: [URLQueryItem]? { get }
}

extension Endpoint {
    var components: URLComponents {
        var components = URLComponents(string: base)!
        components.path = path
        components.queryItems = queryItems
        return components
    }
    
    var url: URL {
        components.url!
    }
    
    var request: URLRequest {
        return URLRequest(url: url)
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
        return EnvironmentManager.shared.environment.url
    }
    
    var path: String {
        return "/v1/cosmos"
    }
    
    static var dateFormatter: DateFormatter {
        return DateFormatter(locale: Locale(identifier: "en_US_POSIX"), format: "yyyy-MM-dd")
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .today(let thumbnails):
            return [
                URLQueryItem(name: "thumbnails", value: String(thumbnails))
            ]
        case .dated(let date, let thumbnails):
            return [
                URLQueryItem(name: "date", value: CosmosEndpoint.dateFormatter.string(from: date)),
                URLQueryItem(name: "thumbnails", value: String(thumbnails))
            ]
        case .ranged(let from, let to, let thumbnails):
            return [
                URLQueryItem(name: "start_date", value: CosmosEndpoint.dateFormatter.string(from: from)),
                URLQueryItem(name: "end_date", value: CosmosEndpoint.dateFormatter.string(from: to)),
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

enum AppStoreEndpoint: Endpoint {
    case share
    case review
    
    var appStoreId: String {
        "1481310548"
    }
    
    var base: String {
        "https://apps.apple.com"
    }
    
    var path: String {
        "/app/app/cosmos-discover-our-universe/id\(appStoreId)"
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .share:
            return nil
        case .review:
            return [
                URLQueryItem(name: "action", value: "write-review")
            ]
        }
    }
}
