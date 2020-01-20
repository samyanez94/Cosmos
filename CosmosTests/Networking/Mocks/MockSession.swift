//
//  MockSession.swift
//  Cosmos
//
//  Created by Samuel Yanez on 10/1/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import Foundation

final class MockSession: APISession {
    let data: Data?
    let response: URLResponse?
    let error: Error?
    
    init(data: Data? = nil, response: URLResponse? = nil, error: Error? = nil) {
        self.data = data
        self.response = response
        self.error = error
    }
    
    func loadData(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> APISessionDataTask {
        completionHandler(data, response, error)
        return MockSessionDataTask()
    }
}

final class MockSessionDataTask: APISessionDataTask {
    var resumeWasCalled = false
    
    func resume() {
        resumeWasCalled = true
    }
}
