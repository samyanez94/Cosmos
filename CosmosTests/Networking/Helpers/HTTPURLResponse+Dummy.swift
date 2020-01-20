//
//  HTTPURLResponse+Dummy.swift
//  CosmosTests
//
//  Created by Samuel Yanez on 1/19/20.
//  Copyright © 2020 Samuel Yanez. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
    static func dummy(url: String = "www.sample.com", statusCode: Int = 200) -> HTTPURLResponse? {
        if let url = URL(string: url) {
            return HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)
        }
        return nil
    }
}
