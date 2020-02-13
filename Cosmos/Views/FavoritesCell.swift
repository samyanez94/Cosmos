//
//  FavoritesCell.swift
//  Cosmos
//
//  Created by Samuel Yanez on 10/22/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import UIKit

class FavoritesCell: UITableViewCell {

    /// Thumbnail image view
    @IBOutlet var thumbnailImageView: UIImageView!
    
    /// Date label
    @IBOutlet var dateLabel: UILabel!
    
    /// Title label
    @IBOutlet var titleLabel: UILabel!
    
    /// Explanation label
    @IBOutlet var explanationLabel: UILabel!
    
    /// Cell height
    static let height: CGFloat = 140
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
        thumbnailImageView.af_cancelImageRequest()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        thumbnailImageView.roundCorners(radius: 5)
    }
}
