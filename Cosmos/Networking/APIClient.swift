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
    
    func downloadAPOD(fromDate date: Date, completion: @escaping ([APOD]?, CosmosNetworkingError?) -> Void) {
        
        let fromDate = Calendar.current.date(byAdding: .day, value: -10, to: date)
        
        if let fromDate = fromDate {
            let endpoint = CosmosEndpoint(fromDate: fromDate, toDate: date)
        
            performRequest(with: endpoint) { (json, error) in
                guard let json = json else {
                    completion(nil, error)
                    return
                }
                
                let apod = json.compactMap { APOD(json: $0)}
                completion(apod.reversed(), nil)
            }
        }
    }
    
    private func performRequest(with endpoint: Endpoint, completion: @escaping ([[String: Any]]?, CosmosNetworkingError?) -> Void) {
        
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

class JSONDownloader {
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    typealias JSON = [[String: AnyObject]]
    typealias JSONTaskCompletionHandler = (JSON?, CosmosNetworkingError?) -> Void
    
    func jsonTask(with request: URLRequest, completionHandler completion: @escaping JSONTaskCompletionHandler) -> URLSessionDataTask {
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed)
                return
            }
            
            if httpResponse.statusCode == 200 {
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: AnyObject]]
                        completion(json, nil)
                    } catch {
                        completion(nil, .jsonConversionFailure)
                    }
                } else {
                    completion(nil, .invalidData)
                }
            } else {
                completion(nil, .responseUnsuccessful)
            }
        }
        return task
    }
}
