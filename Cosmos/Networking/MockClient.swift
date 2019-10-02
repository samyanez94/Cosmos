//
//  MockClient.swift
//  Cosmos
//
//  Created by Samuel Yanez on 7/7/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import Foundation

class MockClient: CosmosClient {
    
    init(data: Data?, response: URLResponse?, error: Error?) {
        super.init(session: MockSession(data: data, response: response, error: error))
    }
    
    convenience init() {
        guard let path = Bundle.main.path(forResource: "apod-response", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
            let url = URL(string: "https://cosmos-app-staging.herokuapp.com") else {
                self.init(data: nil, response: nil, error: nil)
                return
        }
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        self.init(data: data, response: response, error: nil)
    }
}
