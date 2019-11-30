//
//  JSONDecoder+Extensions.swift
//  Cosmos
//
//  Created by Samuel Yanez on 11/5/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import Foundation

extension JSONDecoder {
    convenience init(dateDecodingStrategy: DateDecodingStrategy) {
        self.init()
        self.dateDecodingStrategy = dateDecodingStrategy
    }
}
