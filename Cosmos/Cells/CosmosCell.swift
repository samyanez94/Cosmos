//
//  CosmosCell.swift
//  Cosmos
//
//  Created by Samuel Yanez on 7/21/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import UIKit

class CosmosCell: BaseCardCell {
    
    static let identifier = "com.samuelyanez.CosmosCell"

    /// Image View
    @IBOutlet var imageView: UIImageView!
    
    /// Overlay View
    @IBOutlet var overlayView: UIView!
    
    /// Corner View
    @IBOutlet var cornerView: UIView!
    
    /// Title View
    @IBOutlet var titleView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cornerView.layer.cornerRadius = 14.0
        cornerView.clipsToBounds = true
    }

}
