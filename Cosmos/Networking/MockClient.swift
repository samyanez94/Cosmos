//
//  MockClient.swift
//  Cosmos
//
//  Created by Samuel Yanez on 7/7/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import Foundation

class MockClient: APIClient {
    
    var session: URLSession
    
    let decoder = JSONDecoder(dateDecodingStrategy: .formatted(DateFormatter(locale: .current, format: "yyyy-MM-dd")))
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    func fetch(completion: @escaping (Swift.Result<[APOD], APIError>) -> Void) {
        guard let path = Bundle.main.path(forResource: "apod-response", ofType: "json") else {
            completion(.failure(.invalidLocation))
            return
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            completion(.failure(.invalidData))
            return
        }
        guard let apods = try? decoder.decode([APOD].self, from: data) else {
            completion(.failure(.jsonParsingFailure))
            return
        }
        completion(.success(apods))
    }
}
