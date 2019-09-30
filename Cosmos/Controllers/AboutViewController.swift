//
//  AboutViewController.swift
//  Cosmos
//
//  Created by Samuel Yanez on 9/1/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    /// About title
    @IBOutlet var aboutTitleLabel: UILabel!
    
    /// About body
    @IBOutlet var aboutBodyLabel: UILabel!
    
    /// Acknowledgements title
    @IBOutlet var acknowledgementsTitleLabel: UILabel!
    
    /// Acknowledgements body
    @IBOutlet var acknowledgementsBodyLabel: UILabel!
    
    /// Visit button
    @IBOutlet var visitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Accessibility
        applyDynamicFonts()
    }
    
    @IBAction func didTapOnAboutButton(_ sender: Any) {
        if let url = URL(string: "https://apod.nasa.gov/apod/") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

// MARK: Accessibility

extension AboutViewController {
    
    private func applyDynamicFonts() {
        aboutTitleLabel.font = ScaledFont.font(forTextStyle: .title1, size: 24.0, weight: .bold)
        aboutTitleLabel.adjustsFontForContentSizeCategory = true
        aboutBodyLabel.font = ScaledFont.font(forTextStyle: .body, size: 20.0, weight: .regular)
        aboutBodyLabel.adjustsFontForContentSizeCategory = true
        acknowledgementsTitleLabel.font = ScaledFont.font(forTextStyle: .title1, size: 24.0, weight: .bold)
        acknowledgementsTitleLabel.adjustsFontForContentSizeCategory = true
        acknowledgementsBodyLabel.font = ScaledFont.font(forTextStyle: .body, size: 20.0, weight: .regular)
        acknowledgementsBodyLabel.adjustsFontForContentSizeCategory = true
        visitButton.titleLabel?.font = ScaledFont.font(forTextStyle: .body, size: 20.0, weight: .regular)
        visitButton.titleLabel?.adjustsFontForContentSizeCategory = true
     }
}
