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
    
    /**
     Fetches today's astronomy picture of the day.

     - Parameters:
        - completion: Completion hanlder for response. The response may contain an single APOD or an error.
     */
    func fetch(completion: ((Swift.Result<APOD, APIError>) -> Void)? = nil) {
        let endpoint = CosmosEndpoint.today(thumbnails: true)
        
        fetch(with: endpoint.request, parse: { data -> APOD? in
            return try? self.decoder.decode(APOD.self, from: data)
        }, completion: completion)
    }
    
    /**
     Fetches the astronomy picture of the day for a particular date.

     - Parameters:
        - date: The date for the APOD being fetched.
        - completion: Completion hanlder for response. The response may contain an single APOD or an error.
     */
    func fetch(date: Date, completion: ((Swift.Result<APOD, APIError>) -> Void)? = nil) {
        let endpoint = CosmosEndpoint.dated(date: date, thumbnails: true)
        
        fetch(with: endpoint.request, parse: { data -> APOD? in
            return try? self.decoder.decode(APOD.self, from: data)
        }, completion: completion)
    }
    
    /**
     Fetches random astronomy pictures of the day.

     - Parameters:
        - count: The number of random APODs.
        - completion: Completion hanlder for response. The response may contain a list of APODs or an error.
     */
    func fetch(count: Int, completion: ((Swift.Result<[APOD], APIError>) -> Void)? = nil) {
        let endpoint = CosmosEndpoint.randomized(count: count, thumbnails: true)
        
        fetch(with: endpoint.request, parse: { data -> [APOD]? in
            return try? self.decoder.decode([APOD].self, from: data)
        }, completion: completion)
    }
    
    /**
     Fetches a range of astronomy pictures of the day.

     - Parameters:
        - count: The number of APODs.
        - offset: The offset days from today's date for the range of APODs.
        - completion: Completion hanlder for response. The response may contain a list of APODs or an error.
     */
    func fetch(count: Int, offset: Int, completion: ((Swift.Result<[APOD], APIError>) -> Void)? = nil) {
        if let to = Calendar.current.date(byAdding: .day, value: -offset, to: Date()),
            let from = Calendar.current.date(byAdding: .day, value: -count, to: to) {
        
            let endpoint = CosmosEndpoint.ranged(from: from, to: to, thumbnails: true)
            
            fetch(with: endpoint.request, parse: { data -> [APOD]? in
                return try? self.decoder.decode([APOD].self, from: data)
            }, completion: completion)
        } else {
            completion?(.failure(.incorrectParameters))
        }
    }
    
    func fetch(dates: [Date], completion: ((Swift.Result<[APOD], APIError>) -> Void)? = nil) {
        var endpoint: [CosmosEndpoint] = []
        
        for date in dates {
            endpoint.append(CosmosEndpoint.dated(date: date, thumbnails: true))
        }
        
        let requests = endpoint.map { $0.request }
        
        fetch(with: requests, parse: { data -> APOD? in
            return try? self.decoder.decode(APOD.self, from: data)
        }, completion: completion)
    }
}
