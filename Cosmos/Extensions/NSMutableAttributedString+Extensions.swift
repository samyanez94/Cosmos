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
    convenience init(string: String, blackString: String, font: UIFont) {
        self.init(string: string, attributes: [.font: font])
        
        let blackFontAttribute: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.label]
        let range = (string as NSString).range(of: blackString)
        
        self.addAttributes(blackFontAttribute, range: range)
    }
}
