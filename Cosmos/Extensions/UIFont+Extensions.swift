//
//  UIFont+Extensions.swift
//  Cosmos
//
//  Created by Samuel Yanez on 11/5/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import Foundation
import UIKit

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
