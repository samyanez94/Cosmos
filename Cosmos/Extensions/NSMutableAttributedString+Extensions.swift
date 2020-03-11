//
//  NSMutableAttributedString+Extensions.swift
//  Cosmos
//
//  Created by Samuel Yanez on 11/5/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    func addForegroundColorAttribute(toSubString subString: String, foregroundColor: UIColor) {
        let range = (string as NSString).range(of: subString)
        addAttribute(.foregroundColor, value: foregroundColor, range: range)
    }
    
    func addLinkAttribute(toSubString subString: String, link: String) {
        let range = (string as NSString).range(of: subString)
        addAttribute(.link, value: link, range: range)
    }
}
