//
//  MockSession.swift
//  Cosmos
//
//  Created by Samuel Yanez on 10/1/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import Foundation

class MockSession: URLSession {
    
    let data: Data?
    let response: URLResponse?
    let error: Error?
    
    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(data, response, error)
        return MockDataTask()
    }
}

class MockDataTask: URLSessionDataTask {
    override init() {}
    
    override func resume() {}
}
