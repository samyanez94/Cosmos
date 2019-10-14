//
//  DetailViewController.swift
//  Cosmos
//
//  Created by Samuel Yanez on 8/11/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import UIKit
import WebKit
import Alamofire
import AlamofireImage
import Lightbox

class DetailViewController: UIViewController {
        
    /// Scroll view
    @IBOutlet var scrollView: UIScrollView! {
        didSet {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
    }
    
    /// Media view
    @IBOutlet var mediaView: UIView!
    
    /// Date label
    @IBOutlet var dateLabel: UILabel! {
        didSet {
            dateLabel.accessibilityIdentifier = DetailViewAccessibilityIdentifier.Label.dateLabel
            dateLabel.font = scaledFont.font(forTextStyle: .subheadline)
            dateLabel.adjustsFontForContentSizeCategory = true
        }
    }
    
    /// Title label
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.accessibilityIdentifier = DetailViewAccessibilityIdentifier.Label.titleLabel
            titleLabel.font = scaledFont.font(forTextStyle: .headline)
            titleLabel.adjustsFontForContentSizeCategory = true
        }
    }
    
    /// Explanation label
    @IBOutlet var explanationLabel: UILabel! {
        didSet {
            explanationLabel.accessibilityIdentifier = DetailViewAccessibilityIdentifier.Label.explanationLabel
            explanationLabel.font = scaledFont.font(forTextStyle: .body)
            explanationLabel.adjustsFontForContentSizeCategory = true
        }
    }
    
    /// Copyright label
    @IBOutlet var copyrightLabel: UILabel! {
        didSet {
            copyrightLabel.accessibilityLabel = DetailViewAccessibilityIdentifier.Label.copyrightLabel
            copyrightLabel.font = scaledFont.font(forTextStyle: .body)
            copyrightLabel.adjustsFontForContentSizeCategory = true
        }
    }
    
    /// Share button
    @IBOutlet var shareButton: UIButton! {
        didSet {
            shareButton.accessibilityLabel = DetailViewAccessibilityIdentifier.Button.shareButton
            shareButton.layer.cornerRadius = 5
        }
    }
    
    /// Date label gesture recognizer
    @IBOutlet var dateLabelGestureRecognizer: UITapGestureRecognizer!
    
    /// Share button to explanation label constraint
    @IBOutlet var shareButtonToExplanationLabelConstraint: NSLayoutConstraint!
    
    /// Share button to copyright label constraint
    @IBOutlet var shareButtonToCopyrightLabelConstraint: NSLayoutConstraint!
    
    /// Image view
    private lazy var imageView = UIImageView()
    
    /// Activity indicator
    private let activityIndicator = UIActivityIndicatorView()
    
    /// The current astronomical picture of the day.
    var apod: APOD!
    
    /// Utility used for dynamic types
    private lazy var scaledFont: ScaledFont = {
         return ScaledFont()
     }()
    
    /// App ID for sharing purposes
    private var appId: String {
        "1481310548"
    }
    
    /// App Store URL
    private var appStoreUrl: String {
        "https://apps.apple.com/app/\(appId)"
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
                
        if apod.copyright == nil {
            shareButtonToCopyrightLabelConstraint.isActive = false
            shareButtonToExplanationLabelConstraint.isActive = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view
        configure(for: apod)
    }
    
    // MARK: Configuration
    
    private func configure(for apod: APOD) {
        configureDateLabel()
        configureTitleLabel()
        configureExplanationLabel()
        configureCopyrightLabel()

        loadResource(for: apod)
    }
    
    private func configureDateLabel() {
        dateLabel.text = apod.preferredDateString ?? apod.dateString
        if apod.preferredDateString == nil {
            dateLabelGestureRecognizer.isEnabled = false
        }
    }
    
    private func configureTitleLabel() {
        titleLabel.text = apod.title
    }
    
    private func configureExplanationLabel() {
        explanationLabel.text = apod.explanation.isEmpty ? "There is no description available for this media." : apod.explanation
    }
    
    private func configureCopyrightLabel() {
        if let author = apod.copyright {
            copyrightLabel.attributedText = attributedText(withString: "Copyright: \(author)", blackString: "Copyright:", font: scaledFont.font(forTextStyle: .body))
        } else {
            copyrightLabel.isHidden = true
        }
    }
    
    private func attributedText(withString string: String, blackString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string, attributes: [.font: font])
        let blackFontAttribute: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.label]
        let range = (string as NSString).range(of: blackString)
        attributedString.addAttributes(blackFontAttribute, range: range)
        return attributedString
    }
    
    // MARK: Media view
    
    private func loadResource(for apod: APOD) {
        if let url = URL(string: apod.url) {
            switch apod.mediaType {
            case .image:
                setupImageView(with: url)
            case .video:
                setupWebView(with: url)
                setupActivityIndicator()
            }
        }
    }
        
    private func setupImageView(with url: URL) {
        imageView.frame = mediaView.frame
        imageView.contentMode = .scaleAspectFill
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.isUserInteractionEnabled = true
        imageView.af_setImage(withURL: url, imageTransition: .crossDissolve(0.2))
        
        // We cannot add accessibility attributes to Lightbox. Therefore, I'm disabling the feature when using VoiceOver.
        if !UIAccessibility.isVoiceOverRunning {
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnImage(_:))))
        }
        
        mediaView.addSubview(imageView)
        applyAccessibilityAttributesforImageView(imageView)
    }
    
    private func setupWebView(with url: URL) {
        let webView = WKWebView(frame: mediaView.frame)
        webView.navigationDelegate = self
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.load(URLRequest(url: url))
        
        mediaView.addSubview(webView)
        applyAccesibilityAttributesforWebView(webView)
    }
    
    private func setupActivityIndicator() {
        activityIndicator.center = mediaView.center
        activityIndicator.style = .medium
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        activityIndicator.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        
        mediaView.addSubview(activityIndicator)
    }
    
    // MARK: User interaction
    
    @objc func didTapOnImage(_ sender: UITapGestureRecognizer? = nil) {
        if let sender = sender, let imageView = sender.view as? UIImageView, let image = imageView.image {
            let lighboxImage = LightboxImage(image: image)
            let lightboxController = LightboxController(images: [lighboxImage])
            lightboxController.modalPresentationStyle = .fullScreen
            lightboxController.dynamicBackground = true
            present(lightboxController, animated: true)
        }
    }
    
    @IBAction func didTapOnDateLabel(_ sender: Any) {
        guard let preferredDate = apod.preferredDateString else {
            return
        }
        
        let animation: (() -> Void) = { [unowned self] in
            if self.dateLabel.text == preferredDate {
                self.dateLabel.text = self.apod.dateString
            } else {
                self.dateLabel.text = preferredDate
            }
        }
        UIView.transition(with: dateLabel,
                          duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: animation,
                          completion: nil)
    }
    
    @IBAction func didTapOnShare(_ sender: Any) {
        var activityViewController: UIActivityViewController!
        
        switch apod.mediaType {
        case .image:
            if let image = imageView.image {
                let text = """
                Checkout this image I discovered using the Cosmos app.
                
                The Cosmos app is available on the App Store. \(appStoreUrl)
                """
                
                activityViewController = UIActivityViewController(activityItems: [image, text], applicationActivities: nil)
            }
        case .video:
            let text = """
            Checkout this video I discovered using the Cosmos app: \(apod.url).

            The Cosmos app is available on the App Store. \(appStoreUrl)
            """
            activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        }
        
        activityViewController.excludedActivityTypes  = [
            UIActivity.ActivityType.postToFacebook,
            UIActivity.ActivityType("net.whatsapp.WhatsApp.ShareExtension")
        ]
        
        present(activityViewController, animated: true, completion: nil)
    }
}

// MARK: Web View Navigation Delegate

extension DetailViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }
}

// MARK: Accessibility

extension DetailViewController {
    
    private func applyAccessibilityAttributesforImageView(_ imageView: UIImageView) {
        imageView.isAccessibilityElement = true
        imageView.accessibilityLabel = apod.title
        imageView.accessibilityTraits = .image
        imageView.accessibilityIdentifier = DetailViewAccessibilityIdentifier.Image.imageView
    }
    
    private func applyAccesibilityAttributesforWebView(_ webView: WKWebView) {
        webView.isAccessibilityElement = true
        webView.accessibilityLabel = apod.title
        webView.accessibilityTraits = .startsMediaSession
        webView.accessibilityHint = "Double tap to play media."
        webView.accessibilityIdentifier = DetailViewAccessibilityIdentifier.WebView.webView

    }
}
