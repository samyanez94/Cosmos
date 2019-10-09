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
    @IBOutlet var aboutTitleLabel: UILabel! {
        didSet {
            aboutTitleLabel.accessibilityIdentifier = AboutAccessibilityIdentifier.Label.aboutTitleLabel
        }
    }
    
    /// About body
    @IBOutlet var aboutBodyLabel: UILabel! {
        didSet {
            aboutBodyLabel.accessibilityIdentifier = AboutAccessibilityIdentifier.Label.aboutBodyLabel
        }
    }
    
    /// Acknowledgements title
    @IBOutlet var acknowledgementsTitleLabel: UILabel! {
        didSet {
            acknowledgementsTitleLabel.accessibilityIdentifier = AboutAccessibilityIdentifier.Label.acknowledgementsTitleLabel
        }
    }
    
    /// Acknowledgements body
    @IBOutlet var acknowledgementsBodyLabel: UILabel! {
        didSet {
            acknowledgementsBodyLabel.accessibilityIdentifier = AboutAccessibilityIdentifier.Label.acknowledgementsBodyLabel
        }
    }
    
    /// Visit button
    @IBOutlet var visitButton: UIButton! {
        didSet {
            visitButton.accessibilityIdentifier = AboutAccessibilityIdentifier.Button.visitButton
        }
    }
    
    /// Utility used for dynamic types
    private lazy var scaledFont: ScaledFont = {
         return ScaledFont()
     }()
    
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
        aboutTitleLabel.font = scaledFont.font(forTextStyle: .headline)
        aboutTitleLabel.adjustsFontForContentSizeCategory = true
        aboutBodyLabel.font = scaledFont.font(forTextStyle: .body)
        aboutBodyLabel.adjustsFontForContentSizeCategory = true
        acknowledgementsTitleLabel.font = scaledFont.font(forTextStyle: .headline)
        acknowledgementsTitleLabel.adjustsFontForContentSizeCategory = true
        acknowledgementsBodyLabel.font = scaledFont.font(forTextStyle: .body)
        acknowledgementsBodyLabel.adjustsFontForContentSizeCategory = true
        visitButton.titleLabel?.font = scaledFont.font(forTextStyle: .body)
        visitButton.titleLabel?.adjustsFontForContentSizeCategory = true
     }
}
