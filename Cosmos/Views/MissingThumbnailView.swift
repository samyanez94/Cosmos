//
//  MissingThumbnailView.swift
//  Cosmos
//
//  Created by Samuel Yanez on 9/22/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import UIKit

class MissingThumbnailView: UIView {
    
    @IBOutlet var view: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("MissingThumbnailView", owner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
