//
//  APIClient.swift
//  Cosmos
//
//  Created by Samuel Yanez on 7/22/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import Foundation
import Alamofire

class CosmosAPIClient {
        
    func downloadAPODs(to: Date, completion: @escaping ([APOD]?, CosmosNetworkingError?) -> Void) {
        
        let from = Calendar.current.date(byAdding: .day, value: -9, to: to)
        
        if let from = from {
            downloadAPODs(from: from, to: to, completion: completion)
        }
    }
    
    func downloadAPODs(from: Date, to: Date, completion: @escaping ([APOD]?, CosmosNetworkingError?) -> Void) {
        
        let endpoint = CosmosEndpoint(from: from, to: to)
        
        request(with: endpoint) { (json, error) in
            
            guard let json = json else {
                completion(nil, error)
                return
            }
            let apods = json.compactMap { APOD(json: $0) }
            
            completion(apods.reversed(), nil)
        }
    }
    
    private func request(with endpoint: Endpoint, completion: @escaping ([[String: Any]]?, CosmosNetworkingError?) -> Void) {
        Alamofire.request(endpoint.request).responseJSON { response in
            
            guard let _ = response.response else {
                completion(nil, .requestFailed)
                return
            }
            guard let value = response.result.value else {
                completion(nil, .responseUnsuccessful)
                return
            }
            guard let json = value as? [[String: Any]] else {
                completion(nil, .jsonConversionFailure)
                return
            }
            completion(json, nil)
        }
    }
}
