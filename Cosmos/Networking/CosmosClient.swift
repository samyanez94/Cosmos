//
//  CosmosClient.swift
//  Cosmos
//
//  Created by Samuel Yanez on 5/26/19.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import Foundation

class CosmosClient: APIClient {

    var session: URLSession
    
    var pageSize = 10
    
    var offset: Date = Date()
    
    let decoder = JSONDecoder(dateDecodingStrategy: .formatted(DateFormatter(locale: .current, format: "yyyy-MM-dd")))
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    // TODO: Figure out how to do a better paging in iOS
    
    func fetch(completion: @escaping (Swift.Result<[APOD], APIError>) -> Void) {
        
        let from = Calendar.current.date(byAdding: .day, value: -pageSize, to: offset)!
        
        let endpoint = CosmosEndpoint.ranged(from: from, to: offset)
            
        fetch(with: endpoint.request, parse: { data -> [APOD]? in
            return try? self.decoder.decode([APOD].self, from: data)
        }, completion: completion)
            
        offset = Calendar.current.date(byAdding: .day, value: -1, to: from)!
    }
}
