//
//  AboutViewController.swift
//  Cosmos
//
//  Created by Samuel Yanez on 9/1/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    /// Image view
    @IBOutlet private var imageView: UIImageView! {
        didSet {
            imageView.accessibilityIdentifier = AboutViewAccessibilityIdentifier.Image.imageView
        }
    }
    
    /// About quote
    @IBOutlet private var aboutQuoteLabel: UILabel! {
        didSet {
            aboutQuoteLabel.accessibilityIdentifier = AboutViewAccessibilityIdentifier.Label.aboutQuoteLabel
            aboutQuoteLabel.font = DynamicFont.shared.font(forTextStyle: .body)
            aboutQuoteLabel.adjustsFontForContentSizeCategory = false
            aboutQuoteLabel.text = AboutViewStrings.aboutQuote.localized
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
    @IBOutlet private var acknowledgementsBodyTextView: UITextView! {
        didSet {
            acknowledgementsBodyTextView.accessibilityIdentifier = AboutViewAccessibilityIdentifier.TextView.acknowledgementsBodyLabel
            let attributedText = NSMutableAttributedString(string: AboutViewStrings.acknowledgementsBody.localized)
            attributedText.addLinkAttribute(toSubString: AboutViewStrings.acknowledgementsBodyAttributedText1.localized, link: "https://apod.nasa.gov/apod/")
            attributedText.addLinkAttribute(toSubString: AboutViewStrings.acknowledgementsBodyAttributedText2.localized, link: "https://toriduong.com")
            acknowledgementsBodyTextView.attributedText = attributedText
            acknowledgementsBodyTextView.font = DynamicFont.shared.font(forTextStyle: .body)
            acknowledgementsBodyTextView.textColor = .secondaryLabel
            acknowledgementsBodyTextView.textContainerInset = .zero
            acknowledgementsBodyTextView.textContainer.lineFragmentPadding = 0.0
        }
    }
    
    /// Version label
    @IBOutlet private var versionLabel: UILabel! {
        didSet {
            if let versionNumber = Bundle.main.releaseVersionNumber, let buildNumber = Bundle.main.buildVersionNumber {
                versionLabel.accessibilityIdentifier = AboutViewAccessibilityIdentifier.Label.versionLabel
                versionLabel.font = DynamicFont.shared.font(forTextStyle: .body)
                versionLabel.adjustsFontForContentSizeCategory = false
                versionLabel.text = String(format: AboutViewStrings.version.localized, versionNumber, buildNumber)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = AboutViewStrings.title.localized
    }
}
