//
//  Extensions.swift
//  Cosmos
//
//  Created by Samuel Yanez on 11/25/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import Foundation
import UIKit
import WebKit

extension DateFormatter {
    convenience init(locale: Locale, format: String) {
        self.init()
        self.locale = locale
        self.dateFormat = format
    }
}

extension JSONDecoder {
    convenience init(dateDecodingStrategy: DateDecodingStrategy) {
        self.init()
        self.dateDecodingStrategy = dateDecodingStrategy
    }
}

extension String {
    init(from date: Date) {
        self.init()
        self.write(DateFormatter(locale: .current, format: "EEEE, MMM d").string(from: date))
    }
}

extension NSMutableAttributedString {
    convenience init(string: String, blackString: String, font: UIFont) {
        self.init(string: string, attributes: [.font: font])
        
        let blackFontAttribute: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.label]
        let range = (string as NSString).range(of: blackString)
        
        self.addAttributes(blackFontAttribute, range: range)
    }
}

extension UIFont {
    public static func fontWeight(from string: String) -> UIFont.Weight? {
        switch string {
        case "Ultra Light":
            return .ultraLight
        case "Thin":
            return .thin
        case "Light":
            return .light
        case "Regular":
            return .regular
        case "Medium":
            return .medium
        case "Semi-bold":
            return .semibold
        case "Bold":
            return .bold
        case "Heavy":
            return .heavy
        case "Black":
            return .black
        default:
            return nil
        }
    }
}
