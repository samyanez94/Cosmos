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
    
    /// Favorites button
    @IBOutlet var favoritesButton: UIImageView! {
        didSet {
            if favoritesManager.isFavorite(apod) {
                favoritesButton.image = UIImage(systemName: "heart.fill")
            }
        }
    }
    
    /// Share button
    @IBOutlet var shareButton: UIImageView!
    
    /// Save button
    @IBOutlet var saveButton: UIImageView! {
        didSet {
            if apod.mediaType == .video {
                saveButton.isHidden = true
            }
        }
    }
    
    /// Date label
    @IBOutlet var dateLabel: UILabel! {
        didSet {
            dateLabel.text = viewModel.preferredDate ?? viewModel.date
            dateLabel.accessibilityIdentifier = DetailViewAccessibilityIdentifier.Label.dateLabel
            dateLabel.font = scaledFont.font(forTextStyle: .subheadline)
            dateLabel.adjustsFontForContentSizeCategory = true
        }
    }
    
    /// Title label
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.text = viewModel.title
            titleLabel.accessibilityIdentifier = DetailViewAccessibilityIdentifier.Label.titleLabel
            titleLabel.font = scaledFont.font(forTextStyle: .headline)
            titleLabel.adjustsFontForContentSizeCategory = true
        }
    }
    
    /// Explanation label
    @IBOutlet var explanationLabel: UILabel! {
        didSet {
            explanationLabel.text = viewModel.explanation
            explanationLabel.accessibilityIdentifier = DetailViewAccessibilityIdentifier.Label.explanationLabel
            explanationLabel.font = scaledFont.font(forTextStyle: .body)
            explanationLabel.adjustsFontForContentSizeCategory = true
        }
    }
    
    /// Copyright label
    @IBOutlet var copyrightLabel: UILabel! {
        didSet {
            guard let copyright = viewModel.copyright else {
                copyrightLabel.isHidden = true
                return
            }
            
            copyrightLabel.attributedText = copyright
            copyrightLabel.accessibilityLabel = DetailViewAccessibilityIdentifier.Label.copyrightLabel
            copyrightLabel.font = scaledFont.font(forTextStyle: .body)
            copyrightLabel.adjustsFontForContentSizeCategory = true
        }
    }
    
    /// Date label gesture recognizer
    @IBOutlet var dateLabelGestureRecognizer: UITapGestureRecognizer!
    
    /// Image view
    private lazy var imageView = UIImageView()
    
    /// Activity indicator
    private lazy var activityIndicator = UIActivityIndicatorView()
    
    /// The current astronomical picture of the day.
    var apod: APOD! {
        didSet {
            viewModel = APODViewModel(apod: apod)
        }
    }
    
    /// View model
    var viewModel: APODViewModel!
    
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
    
    /// Favorites manager
    private let favoritesManager = CosmosFavoritesManager()
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if viewModel.preferredDate == nil {
            dateLabelGestureRecognizer.isEnabled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load resources
        loadResource(for: apod)
    }
    
    // MARK: Media view
    
    private func loadResource(for apod: APOD) {
        if let url = URL(string: apod.urlString) {
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
        
        // I cannot add accessibility attributes to Lightbox. Therefore, I'm disabling the feature when using VoiceOver.
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
        guard let preferredDate = viewModel.preferredDate else {
            return
        }
        
        let animation: (() -> Void) = { [unowned self] in
            if self.dateLabel.text == preferredDate {
                self.dateLabel.text = self.viewModel.date
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
    
    @IBAction func didTapOnFavorites(_ sender: Any) {
        let isFavorite = favoritesManager.isFavorite(apod)
        
        if isFavorite {
            favoritesManager.removeFromFavorites(apod)
        } else {
            favoritesManager.addToFavorites(apod)
        }
        
        let animation: (() -> Void) = { [unowned self] in
            self.favoritesButton.image = isFavorite ? UIImage(systemName: "heart") : UIImage(systemName: "heart.fill")
        }
        
        UIView.transition(with: favoritesButton,
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
            Checkout this video I discovered using the Cosmos app: \(apod.urlString).

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
    
    @IBAction func didTapOnSave(_ sender: Any) {
        if let image = imageView.image {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
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
