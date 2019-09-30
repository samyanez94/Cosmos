//
//  ScaledFont.swift
//  Cosmos
//
//  Created by Samuel Yanez on 9/7/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import UIKit

public final class ScaledFont {
    public class func font(forTextStyle textStyle: UIFont.TextStyle, size: CGFloat = UIFont.systemFontSize, weight: UIFont.Weight = .regular) -> UIFont {
        let font = UIFont.systemFont(ofSize: size, weight: weight)
        let fontMetrics = UIFontMetrics(forTextStyle: textStyle)
        return fontMetrics.scaledFont(for: font)
    }
}
