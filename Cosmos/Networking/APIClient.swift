//
//  APIClient.swift
//  Cosmos
//
//  Created by Samuel Yanez on 7/22/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import Foundation
import Alamofire

protocol APIClient {
    
    func fetch(with completion: @escaping ([APOD]?, CosmosNetworkingError?) -> Void)
}

class CosmosAPIClient: APIClient {
    
    let decoder = JSONDecoder(dateDecodingStrategy: .formatted(DateFormatter(locale: .current, format: "yyyy-MM-dd")))
    
    var date: Date = Date()
    
    func fetch(with completion: @escaping ([APOD]?, CosmosNetworkingError?) -> Void) {
        
        let to = date
        let from = Calendar.current.date(byAdding: .day, value: -9, to: to)
        
        if let from = from {
            let endpoint = CosmosEndpoint(from: from, to: to)
            downloadAPODs(with: endpoint, completion: completion)
            date = from
        }
    }
    
    private func downloadAPODs(with endpoint: Endpoint, completion: @escaping ([APOD]?, CosmosNetworkingError?) -> Void) {
        request(with: endpoint) { (data, error) in
            
            guard let data = data else {
                completion(nil, error)
                return
            }
            do {
                let apods = try self.decoder.decode([APOD].self, from: data)
                completion(apods.reversed(), nil)
            } catch {
                completion(nil, .jsonParsingError)
            }
        }
    }
    
    private func request(with endpoint: Endpoint, completion: @escaping (Data?, CosmosNetworkingError?) -> Void) {
        Alamofire.request(endpoint.request).responseJSON { response in
            
            guard let _ = response.response else {
                completion(nil, .requestFailed)
                return
            }
            guard let data = response.data else {
                completion(nil, .responseUnsuccessful)
                return
            }
            completion(data, nil)
        }
    }
}
