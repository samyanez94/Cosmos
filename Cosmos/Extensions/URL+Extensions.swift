//
//  URL+Extensions.swift
//  Cosmos
//
//  Created by Samuel Yanez on 11/5/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import Foundation

extension URL {
    init?(string: String?) {
        if let string = string {
            self.init(string: string)
        }
        return nil
    }
}
