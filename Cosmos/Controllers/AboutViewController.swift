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
    @IBOutlet private var aboutTitleLabel: UILabel! {
        didSet {
            aboutTitleLabel.accessibilityIdentifier = AboutViewAccessibilityIdentifier.Label.aboutTitleLabel
            aboutTitleLabel.font = scaledFont.font(forTextStyle: .headline)
            aboutTitleLabel.adjustsFontForContentSizeCategory = true
        }
    }
    
    /// About body
    @IBOutlet private var aboutBodyLabel: UILabel! {
        didSet {
            aboutBodyLabel.accessibilityIdentifier = AboutViewAccessibilityIdentifier.Label.aboutBodyLabel
            aboutBodyLabel.font = scaledFont.font(forTextStyle: .body)
            aboutBodyLabel.adjustsFontForContentSizeCategory = true
        }
    }
    
    /// Acknowledgements title
    @IBOutlet private var acknowledgementsTitleLabel: UILabel! {
        didSet {
            acknowledgementsTitleLabel.accessibilityIdentifier = AboutViewAccessibilityIdentifier.Label.acknowledgementsTitleLabel
            acknowledgementsTitleLabel.font = scaledFont.font(forTextStyle: .headline)
            acknowledgementsTitleLabel.adjustsFontForContentSizeCategory = true
        }
    }
    
    /// Acknowledgements body
    @IBOutlet private var acknowledgementsBodyLabel: UILabel! {
        didSet {
            acknowledgementsBodyLabel.accessibilityIdentifier = AboutViewAccessibilityIdentifier.Label.acknowledgementsBodyLabel
            acknowledgementsBodyLabel.font = scaledFont.font(forTextStyle: .body)
            acknowledgementsBodyLabel.adjustsFontForContentSizeCategory = true
        }
    }
    
    /// Visit button
    @IBOutlet private var visitButton: UIButton! {
        didSet {
            visitButton.accessibilityIdentifier = AboutViewAccessibilityIdentifier.Button.visitButton
            visitButton.titleLabel?.font = scaledFont.font(forTextStyle: .body)
            visitButton.titleLabel?.adjustsFontForContentSizeCategory = true
        }
    }
    
    /// Utility used for dynamic types
    private lazy var scaledFont: ScaledFont = {
         return ScaledFont()
     }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTapOnAboutButton(_ sender: Any) {
        if let url = URL(string: "https://apod.nasa.gov/apod/") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
