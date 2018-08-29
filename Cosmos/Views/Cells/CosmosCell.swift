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
    
    /// Overlay View
    @IBOutlet var overlayView: UIView!
    
    /// Corner View
    @IBOutlet var cornerView: UIView!
    
    /// Title View
    @IBOutlet var titleView: UILabel!
    
    /// Date View
    @IBOutlet var dateView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        cornerView.layer.cornerRadius = 14.0
        cornerView.clipsToBounds = true
    }
    
    func updateAppearence(for viewModel: APODViewModel) {
        titleView.text = viewModel.title
        dateView.text = viewModel.date
    }

}
