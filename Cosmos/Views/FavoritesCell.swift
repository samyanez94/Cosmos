//
//  FavoritesCell.swift
//  Cosmos
//
//  Created by Samuel Yanez on 10/22/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import UIKit

class FavoritesCell: UITableViewCell {

    @IBOutlet var thumbnailImageView: UIImageView! {
        didSet {
            thumbnailImageView.roundCorners(radius: 5)
            thumbnailImageView.setShadow(opacity: 0.2, radius: 5)
        }
    }
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var explanationLabel: UILabel!
    
    /// Cell height
    static let height: CGFloat = 140
}
