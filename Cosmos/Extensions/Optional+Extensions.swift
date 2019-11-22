//
//  Optional+Extensions.swift
//  Cosmos
//
//  Created by Samuel Yanez on 11/21/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import Foundation

extension Optional {
    var isNil: Bool {
        return self == nil
    }
    
    var isNotNil: Bool {
        return self != nil
    }
}
