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
        // Bound subviews to the visible bounds of the container view.
        containerView.clipsToBounds = true
        
        // Set the corner radius
        containerView.layer.cornerRadius = 14.0
    }
    
    func updateLabels(for viewModel: APODViewModel) {
        titleLabel.text = viewModel.title
        dateLabel.text = viewModel.date
    }

}
