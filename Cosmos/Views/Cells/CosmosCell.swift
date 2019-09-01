//
//  CosmosCell.swift
//  Cosmos
//
//  Created by Samuel Yanez on 7/21/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import UIKit

// TODO: Combine Cosmos cell and base cell into one

class CosmosCell: BaseCell {
    
    static let identifier = "com.samuelyanez.CosmosCell"
    
    static let cornerRadius: CGFloat = 20
    
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
        setupShadow()
        setupBorderRadius()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        imageView.af_cancelImageRequest()
    }
    
    private func setupShadow() {
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: -1, height: 2)
        layer.masksToBounds = false
    }
    
    private func setupBorderRadius() {
        containerView.layer.cornerRadius = CosmosCell.cornerRadius
    }
}
