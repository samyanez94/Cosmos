//
//  JSONDecoder+DateDecodingStrategy.swift
//  Cosmos
//
//  Created by Samuel Yanez on 8/28/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import Foundation

extension JSONDecoder {
    convenience init(dateDecodingStrategy: DateDecodingStrategy) {
        self.init()
        self.dateDecodingStrategy = dateDecodingStrategy
    }
}
