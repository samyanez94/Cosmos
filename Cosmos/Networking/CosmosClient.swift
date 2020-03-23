//
//  CosmosClient.swift
//  Cosmos
//
//  Created by Samuel Yanez on 5/26/19.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import Foundation

class CosmosClient: APIClient {

    var session: APISession
    
    let decoder = JSONDecoder()
    
    init(session: APISession) {
        self.session = session
        decoder.dateDecodingStrategy = .formatted(DateFormatter(locale: .current, format: "yyyy-MM-dd"))
    }
    
    convenience init() {
        self.init(session: URLSession.shared)
    }
    
    /**
     Fetches today's astronomy picture of the day.

     - Parameters:
        - completion: Completion hanlder for response. The response may contain an single APOD or an error.
     */
    func fetch(completion: ((Swift.Result<Apod, APIError>) -> Void)? = nil) {
        let endpoint = CosmosEndpoint.today(thumbnails: true)
        
        fetch(with: endpoint.request, parse: { data -> Apod? in
            return try? self.decoder.decode(Apod.self, from: data)
        }, completion: completion)
    }
    
    /**
     Fetches the astronomy picture of the day for a particular date.

     - Parameters:
        - date: The date for the APOD being fetched.
        - completion: Completion hanlder for response. The response may contain an single APOD or an error.
     */
    func fetch(date: Date, completion: ((Swift.Result<Apod, APIError>) -> Void)? = nil) {
        let endpoint = CosmosEndpoint.dated(date: date, thumbnails: true)
        
        fetch(with: endpoint.request, parse: { data -> Apod? in
            return try? self.decoder.decode(Apod.self, from: data)
        }, completion: completion)
    }
    
    /**
     Fetches random astronomy pictures of the day.

     - Parameters:
        - count: The number of random APODs.
        - completion: Completion hanlder for response. The response may contain a list of APODs or an error.
     */
    func fetch(count: Int, completion: ((Swift.Result<[Apod], APIError>) -> Void)? = nil) {
        let endpoint = CosmosEndpoint.randomized(count: count, thumbnails: true)
        
        fetch(with: endpoint.request, parse: { data -> [Apod]? in
            return try? self.decoder.decode([Apod].self, from: data)
        }, completion: completion)
    }
    
    /**
     Fetches a range of astronomy pictures of the day.

     - Parameters:
        - count: The number of APODs.
        - offset: The offset days from today's date for the range of APODs.
        - completion: Completion hanlder for response. The response may contain a list of APODs or an error.
     */
    func fetch(count: Int, offset: Int, completion: ((Swift.Result<[Apod], APIError>) -> Void)? = nil) {
        if let to = Calendar.current.date(byAdding: .day, value: -offset, to: Date()),
            let from = Calendar.current.date(byAdding: .day, value: -count + 1, to: to) {
        
            let endpoint = CosmosEndpoint.ranged(from: from, to: to, thumbnails: true)
            
            fetch(with: endpoint.request, parse: { data -> [Apod]? in
                return try? self.decoder.decode([Apod].self, from: data)
            }, completion: completion)
        } else {
            completion?(.failure(.incorrectParameters))
        }
    }
}
