//
//  AboutViewController.swift
//  Cosmos
//
//  Created by Samuel Yanez on 9/1/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    /// About quote
    @IBOutlet private var aboutBodyQuoteLabel: UILabel! {
        didSet {
            aboutBodyQuoteLabel.accessibilityIdentifier = AboutViewAccessibilityIdentifier.Label.aboutBodyQuoteLabel
            aboutBodyQuoteLabel.font = DynamicFont.shared.font(forTextStyle: .body)
            aboutBodyQuoteLabel.adjustsFontForContentSizeCategory = false
            aboutBodyQuoteLabel.text = AboutViewStrings.aboutBodyQuote.localized
        }
    }
    
    /// About body
    @IBOutlet private var aboutBodyLabel: UILabel! {
        didSet {
            aboutBodyLabel.accessibilityIdentifier = AboutViewAccessibilityIdentifier.Label.aboutBodyLabel
            aboutBodyLabel.font = DynamicFont.shared.font(forTextStyle: .body)
            aboutBodyLabel.adjustsFontForContentSizeCategory = false
            aboutBodyLabel.text = AboutViewStrings.aboutBody.localized
        }
    }
    
    /// Acknowledgements title
    @IBOutlet private var acknowledgementsTitleLabel: UILabel! {
        didSet {
            acknowledgementsTitleLabel.accessibilityIdentifier = AboutViewAccessibilityIdentifier.Label.acknowledgementsTitleLabel
            acknowledgementsTitleLabel.font = DynamicFont.shared.font(forTextStyle: .headline)
            acknowledgementsTitleLabel.adjustsFontForContentSizeCategory = false
            acknowledgementsTitleLabel.text = AboutViewStrings.acknowledgementsTitle.localized
        }
    }
    
    /// Acknowledgements body
    @IBOutlet private var acknowledgementsBodyLabel: UILabel! {
        didSet {
            acknowledgementsBodyLabel.accessibilityIdentifier = AboutViewAccessibilityIdentifier.Label.acknowledgementsBodyLabel
            acknowledgementsBodyLabel.font = DynamicFont.shared.font(forTextStyle: .body)
            acknowledgementsBodyLabel.adjustsFontForContentSizeCategory = false
            acknowledgementsBodyLabel.text = AboutViewStrings.acknowledgementsBody.localized
        }
    }
    
    /// Visit button
    @IBOutlet private var visitButton: UIButton! {
        didSet {
            visitButton.accessibilityIdentifier = AboutViewAccessibilityIdentifier.Button.visitButton
            visitButton.accessibilityTraits = .link
            visitButton.titleLabel?.font = DynamicFont.shared.font(forTextStyle: .body)
            visitButton.titleLabel?.adjustsFontForContentSizeCategory = false
            visitButton.titleLabel?.text = AboutViewStrings.visitButton.localized
            visitButton.titleLabel?.numberOfLines = 0
        }
    }
    
    /// Version label
    @IBOutlet private var versionLabel: UILabel! {
        didSet {
            if let versionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
                versionLabel.accessibilityIdentifier = AboutViewAccessibilityIdentifier.Label.versionLabel
                versionLabel.font = DynamicFont.shared.font(forTextStyle: .body)
                versionLabel.adjustsFontForContentSizeCategory = false
                versionLabel.text = String(format: AboutViewStrings.version.localized, versionNumber)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = AboutViewStrings.title.localized
    }
    
    @IBAction func didTapOnAboutButton() {
       if let url = URL(string: "https://apod.nasa.gov/apod/") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
