//
//  MissingThumbnailView.swift
//  Cosmos
//
//  Created by Samuel Yanez on 9/22/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import UIKit

class MissingThumbnailView: UIView {
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let view = MissingThumbnailView.loadFromDefaultNib()
        view.frame = bounds
        addSubview(view)
    }
}
