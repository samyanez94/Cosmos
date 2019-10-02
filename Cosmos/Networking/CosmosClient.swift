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
    
    let decoder = JSONDecoder(dateDecodingStrategy: .formatted(DateFormatter(locale: .current, format: "yyyy-MM-dd")))
    
    init(session: URLSession) {
        self.session = session
    }
    
    convenience init() {
        self.init(session: URLSession(configuration: .default))
    }
        
    func fetch(count: Int, offset: Int = 0, completion: @escaping (Swift.Result<[APOD], APIError>) -> Void) {
        let to = Calendar.current.date(byAdding: .day, value: -offset, to: Date())!
        let from = Calendar.current.date(byAdding: .day, value: -count, to: to)!
        
        let endpoint = CosmosEndpoint.ranged(from: from, to: to, thumbnails: true)
        
        fetch(with: endpoint.request, parse: { data -> [APOD]? in
            return try? self.decoder.decode([APOD].self, from: data)
        }, completion: completion)
    }
}
