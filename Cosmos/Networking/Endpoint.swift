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

    private var key: String {
        return "kMfnNhMKgdodjARiUj98FhQ9W0ogrnGjdnBda66n"
    }
    
    var base: String {
        return "https://api.nasa.gov"
    }
    
    var path: String {
        return "/planetary/apod"
    }
    
    var queryItems = [URLQueryItem]()
    
    var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    init() {
        let apiKeyItem = URLQueryItem(name: "api_key", value: key)
        queryItems.append(apiKeyItem)
    }
    
    init(fromDate date: Date) {
        self.init()
        let dateString = formatter.string(from: date)
        let dateKeyItem = URLQueryItem(name: "date", value: dateString)
        queryItems.append(dateKeyItem)
    }
    
    init(fromDate from: Date, toDate to: Date) {
        self.init()
        let startDate = formatter.string(from: from)
        let endDate = formatter.string(from: to)
        let startDateKeyItem = URLQueryItem(name: "start_date", value: startDate)
        let endDateKeyItem = URLQueryItem(name: "end_date", value: endDate)
        queryItems.append(startDateKeyItem)
        queryItems.append(endDateKeyItem)
    }
    
    init(withCount count: Int) {
        let countKeyItem = URLQueryItem(name: "count", value: String(count))
        queryItems.append(countKeyItem)
    }
}
