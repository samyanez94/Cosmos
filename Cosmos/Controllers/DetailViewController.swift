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
    @IBOutlet private var scrollView: UIScrollView! {
        didSet {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
    }
    
    /// Media view
    @IBOutlet private var mediaContainerView: UIView!
    
    /// Favorites button
    @IBOutlet private var favoritesButton: UIImageView! {
        didSet {
            favoritesButton.accessibilityIdentifier = DetailViewAccessibilityIdentifier.Button.favoritesButton
        }
    }
    
    /// Share button
    @IBOutlet private var shareButton: UIImageView! {
        didSet {
            shareButton.accessibilityIdentifier = DetailViewAccessibilityIdentifier.Button.shareButton
        }
    }
    
    /// Save button
    @IBOutlet private var saveButton: UIImageView! {
        didSet {
            saveButton.accessibilityIdentifier = DetailViewAccessibilityIdentifier.Button.saveToPhotosButton
        }
    }
    
    /// Date label
    @IBOutlet private var dateLabel: UILabel! {
        didSet {
            dateLabel.accessibilityIdentifier = DetailViewAccessibilityIdentifier.Label.dateLabel
            dateLabel.font = DynamicFont.shared.font(forTextStyle: .subheadline)
            dateLabel.adjustsFontForContentSizeCategory = true
        }
    }
    
    /// Title label
    @IBOutlet private var titleLabel: UILabel! {
        didSet {
            titleLabel.accessibilityIdentifier = DetailViewAccessibilityIdentifier.Label.titleLabel
            titleLabel.font = DynamicFont.shared.font(forTextStyle: .headline)
            titleLabel.adjustsFontForContentSizeCategory = true
        }
    }
    
    /// Explanation label
    @IBOutlet private var explanationLabel: UILabel! {
        didSet {
            explanationLabel.accessibilityIdentifier = DetailViewAccessibilityIdentifier.Label.explanationLabel
            explanationLabel.font = DynamicFont.shared.font(forTextStyle: .body)
            explanationLabel.adjustsFontForContentSizeCategory = true
        }
    }
    
    /// Copyright label
    @IBOutlet private var copyrightLabel: UILabel! {
        didSet {
            copyrightLabel.accessibilityLabel = DetailViewAccessibilityIdentifier.Label.copyrightLabel
            copyrightLabel.font = DynamicFont.shared.font(forTextStyle: .body)
            copyrightLabel.adjustsFontForContentSizeCategory = true
        }
    }
    
    /// Date label gesture recognizer
    @IBOutlet private var dateLabelGestureRecognizer: UITapGestureRecognizer!
    
    /// Image view
    private lazy var imageView = UIImageView()
    
    /// Web view
    private lazy var webView = WKWebView()
    
    /// View model
    var viewModel: APODViewModel?
        
    /// Feedback generator
    private var feedbackGenerator = UISelectionFeedbackGenerator()
    
    /// Favorites manager
    private let favoritesManager = UserDefaultsFavoritesManager()
    
    /// Share manager
    private let shareManager = ShareManager()
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = DetailViewStrings.title.localized
        
        if let viewModel = viewModel {
            updateView(for: viewModel)
        }
    }
    
    // MARK: View Updates
    
    private func updateView(for viewModel: APODViewModel) {
        updateViews(for: viewModel)
        updateLabels(for: viewModel)
        updateFavoritesButton(for: viewModel)
        updateMediaView(for: viewModel)
        updateFavoritesButton(for: viewModel)
    }
    
    private func updateViews(for viewModel: APODViewModel) {
        dateLabelGestureRecognizer.isEnabled = viewModel.preferredDate.isNotNil
        copyrightLabel.isHidden = viewModel.copyright.isNil
        saveButton.isHidden = viewModel.mediaType == .video
    }
    
    private func updateLabels(for viewModel: APODViewModel) {
        dateLabel.text = viewModel.preferredDate ?? viewModel.date
        titleLabel.text = viewModel.title
        explanationLabel.text = viewModel.explanation
        copyrightLabel.text = viewModel.copyright
    }
    
    private func updateMediaView(for viewModel: APODViewModel) {
        if let url = viewModel.url {
            switch viewModel.mediaType {
            case .image:
                setupImageView(with: url)
            case .video:
                setupWebView(with: url)
            }
        }
    }
    
    private func updateFavoritesButton(for viewModel: APODViewModel) {
        favoritesManager.isFavorite(viewModel.apod.date) { isFavorite in
            animateFavoritesButtonTransition(isFavorite: isFavorite)
        }
    }
    
    private func animateFavoritesButtonTransition(isFavorite: Bool) {
        let animation: (() -> Void) = { [unowned self] in
            self.favoritesButton.image = isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        }
        UIView.transition(with: favoritesButton,
                          duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: animation,
                          completion: nil)
    }
    
    // MARK: Media Updates
        
    private func setupImageView(with url: URL) {
        // Observe user interaction events.
        imageView.isUserInteractionEnabled = true
        
        // Image need to scale to allways fill the size of the view.
        imageView.contentMode = .scaleAspectFill
        
        // Pin view to container.
        mediaContainerView.pinSubView(imageView)
        
        // Fetch image
        imageView.af_setImage(withURL: url, imageTransition: .crossDissolve(0.2))
        
        // Accessibility
        applyAccessibilityAttributesforImageView(imageView)
        
        // Cannot add accessibility attributes to Lightbox. Therefore, we disable the feature when using VoiceOver.
        if !UIAccessibility.isVoiceOverRunning {
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnImage(_:))))
        }
    }
    
    private func setupWebView(with url: URL) {
        // Pin view to container.
        mediaContainerView.pinSubView(webView)
        
        // Load URL.
        webView.load(URLRequest(url: url))
        
        // Accessibility
        applyAccesibilityAttributesforWebView(webView)
    }
    
    // MARK: User interaction
    
    @objc func didTapOnImage(_ sender: UITapGestureRecognizer? = nil) {
        if let sender = sender, let imageView = sender.view as? UIImageView, let image = imageView.image {
            let lightboxController = LightboxController(image: image)
            present(lightboxController, animated: true)
        }
    }
    
    @IBAction func didTapOnDateLabel(_ sender: Any) {
        guard let viewModel = viewModel,
            let preferredDate = viewModel.preferredDate else {
            return
        }
        let animation: (() -> Void) = { [unowned self] in
            if self.dateLabel.text == preferredDate {
                self.dateLabel.text = viewModel.date
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
        guard let viewModel = viewModel else { return }
        feedbackGenerator.prepare()
        favoritesManager.isFavorite(viewModel.apod.date) { isFavorite in
            guard let viewModel = self.viewModel else { return }
            if isFavorite {
                self.favoritesManager.removeFromFavorites(viewModel.apod.date)
            } else {
                self.favoritesManager.addToFavorites(viewModel.apod.date)
            }
            print(viewModel.apod.date.description)
            feedbackGenerator.selectionChanged()
            self.animateFavoritesButtonTransition(isFavorite: !isFavorite)
        }
    }
        
    @IBAction func didTapOnShare(_ sender: Any) {
        guard let viewModel = viewModel else { return }
        let activityViewController: UIActivityViewController = {
            switch viewModel.mediaType {
            case .image:
                return shareManager.activityViewController(with: .image(imageView.image))
            case .video:
                return shareManager.activityViewController(with: .video(viewModel.apod.urlString))
            }
        }()
        present(activityViewController, animated: true)
    }
    
    @IBAction func didTapOnSave(_ sender: Any) {
        if let image = imageView.image {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
}

// MARK: Accessibility

extension DetailViewController {
    private func applyAccessibilityAttributesforImageView(_ imageView: UIImageView) {
        guard let viewModel = viewModel else { return }
        imageView.isAccessibilityElement = true
        imageView.accessibilityLabel = viewModel.title
        imageView.accessibilityTraits = .image
        imageView.accessibilityIdentifier = DetailViewAccessibilityIdentifier.Image.imageView
    }
    
    private func applyAccesibilityAttributesforWebView(_ webView: WKWebView) {
        guard let viewModel = viewModel else { return }
        webView.isAccessibilityElement = true
        webView.accessibilityLabel = viewModel.title
        webView.accessibilityTraits = .startsMediaSession
        webView.accessibilityHint = "Double tap to play media."
        webView.accessibilityIdentifier = DetailViewAccessibilityIdentifier.WebView.webView
    }
}
