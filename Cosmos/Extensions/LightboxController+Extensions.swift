//
//  LightboxController+Extensions.swift
//  Cosmos
//
//  Created by Samuel Yanez on 11/21/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import Foundation
import Lightbox

extension LightboxController {
    convenience init(image: UIImage) {
        self.init(images: [LightboxImage(image: image)])
        modalPresentationStyle = .fullScreen
        dynamicBackground = true
    }
}
