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

struct CosmosEndpoint: Endpoint {

    private let key = "kMfnNhMKgdodjARiUj98FhQ9W0ogrnGjdnBda66n"
    
    var base: String {
        return "https://api.nasa.gov"
    }
    
    var path: String {
        return "/planetary/apod"
    }
    
    var queryItems = [URLQueryItem]()
    
    init(withDate date: Date) {
        
        // Format String from date
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        
        let apiKeyItem = URLQueryItem(name: "api_key", value: key)
        let dateKeyItem = URLQueryItem(name: "date", value: dateString)
        
        queryItems.append(apiKeyItem)
        queryItems.append(dateKeyItem)
    }
    
    
}
