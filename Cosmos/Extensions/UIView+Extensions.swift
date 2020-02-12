//
//  UIView+Extensions.swift
//  Cosmos
//
//  Created by Samuel Yanez on 11/5/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    static var defaultName: String {
        String(describing: self)
    }
    
    static func loadFromDefaultNib<T: UIView>() -> T {
        loadFromNib(defaultName)
    }
    
    static func loadFromNib<T: UIView>(_ nibName: String) -> T {
        loadFromNib(nibName, bundle: Bundle(for: self))
    }
    
    static func loadFromNib<T: UIView>(_ nibName: String, bundle: Bundle) -> T {
        guard let view = bundle.loadNibNamed(nibName, owner: nil, options: nil)?.first as? T else {
            fatalError("\(self) has not been initialized properly from nib \(nibName)")
        }
        return view
    }
}

extension UIView {
    func roundCorners(radius: CGFloat, corners: UIRectCorner = .allCorners) {
        let cornerRadii = CGSize(width: radius, height: radius)
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: cornerRadii)
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func setShadow(
        withColor color: UIColor = .black, opacity: Float = 1, offSet: CGSize = .zero, radius: CGFloat = 0) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        layer.masksToBounds = false
    }
}

extension UIView {
    func pinSubView(_ view: UIView) {
        view.frame = frame
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
}
