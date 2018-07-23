//
//  APIClient.swift
//  Cosmos
//
//  Created by Samuel Yanez on 7/22/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import Foundation

class CosmosAPIClient {
    
    let downloader = JSONDownloader()
    
    func downloadAPOD(fromDate date: Date, completion: @escaping (APOD?, CosmosNetworkingError?) -> Void) {
        
        let endpoint = CosmosEndpoint(withDate: date)
        
        performRequest(with: endpoint) { (json, error) in
            guard let json = json else {
                completion(nil, error)
                return
            }
            
            let apod = APOD(json: json)
            completion(apod, nil)
        }
    }
    
    private func performRequest(with endpoint: Endpoint, completion: @escaping ([String: Any]?, CosmosNetworkingError?) -> Void) {
        
        let task = downloader.jsonTask(with: endpoint.request) { json, error in
            DispatchQueue.main.async {
                
                if let json = json {
                   completion(json, nil)
                } else {
                   completion(nil, error)
                    return
                }
            }
        }
        task.resume()
    }
}
