//
//  CosmosCell.swift
//  Cosmos
//
//  Created by Samuel Yanez on 7/21/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import UIKit

class CosmosCell: BaseCell {
    
    static let identifier = "com.samuelyanez.CosmosCell"
    
    static let cornerRadius: CGFloat = 14.0

    /// Image View
    @IBOutlet var imageView: UIImageView!
    
    /// Header View
    @IBOutlet var headerView: UIView!
    
    /// Container View
    @IBOutlet var containerView: UIView!
    
    /// Title Label
    @IBOutlet var titleLabel: UILabel!
    
    /// Date Label
    @IBOutlet var dateLabel: UILabel!
    
    override func draw(_ rect: CGRect) {
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = CosmosCell.cornerRadius
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        imageView.af_cancelImageRequest()
    }
}
