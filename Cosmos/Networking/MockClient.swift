//
//  MockClient.swift
//  Cosmos
//
//  Created by Samuel Yanez on 10/16/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import Foundation

class MockClient: APIClient {
    
    let decoder = JSONDecoder(dateDecodingStrategy: .formatted(DateFormatter(locale: .current, format: "yyyy-MM-dd")))
    
    func fetch(with completion: @escaping ([APOD]?, CosmosNetworkingError?) -> Void) {
        
        guard let url = Bundle.main.url(forResource: "sample", withExtension: "json") else {
            completion(nil, .invalidData)
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            parse(from: data, completion: completion)
        } catch {
            completion(nil, .invalidData)
            return
        }
    }
    
    private func parse(from json: Data, completion: @escaping ([APOD]?, CosmosNetworkingError?) -> Void) {
        do {
            let apods = try decoder.decode([APOD].self, from: json)
            completion(apods, nil)
        } catch {
            completion(nil, .jsonParsingError)
            return
        }
    }
}
