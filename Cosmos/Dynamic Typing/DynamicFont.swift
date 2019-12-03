//
//  DynamicFont.swift
//  Cosmos
//
//  Created by Samuel Yanez on 9/7/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import UIKit

public final class DynamicFont {
    private struct FontDescription: Decodable {
        let fontSize: CGFloat
        let fontWeight: String
    }
    
    private typealias StyleDictionary = [UIFont.TextStyle.RawValue: FontDescription]
    
    private var styleDictionary: StyleDictionary?
    
    static let shared = DynamicFont()
    
    private init() {
        if let url = Bundle.main.url(forResource: "DynamicFonts", withExtension: "plist"),
            let data = try? Data(contentsOf: url) {
            let decoder = PropertyListDecoder()
            styleDictionary = try? decoder.decode(StyleDictionary.self, from: data)
        }
    }
    
    public func font(forTextStyle textStyle: UIFont.TextStyle) -> UIFont {
        guard let fontDescription = styleDictionary?[textStyle.rawValue],
            let weight = UIFont.fontWeight(from: fontDescription.fontWeight) else {
                return UIFont.preferredFont(forTextStyle: textStyle)
        }
        let font = UIFont.systemFont(ofSize: fontDescription.fontSize, weight: weight)
        let fontMetrics = UIFontMetrics(forTextStyle: textStyle)
        return fontMetrics.scaledFont(for: font)
    }
}
