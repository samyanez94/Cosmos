//
//  DetailViewController.swift
//  Cosmos
//
//  Created by Samuel Yanez on 8/11/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import Photos
import UIKit
import WebKit
import AlamofireImage
import Lightbox
import Toast_Swift

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
            favoritesButton.isAccessibilityElement = true
            favoritesButton.accessibilityTraits = .button
            favoritesButton.accessibilityLabel = "Add to favorites"
        }
    }
    
    /// Share button
    @IBOutlet private var shareButton: UIImageView! {
        didSet {
            shareButton.accessibilityIdentifier = DetailViewAccessibilityIdentifier.Button.shareButton
            shareButton.isAccessibilityElement = true
            shareButton.accessibilityTraits = .button
            shareButton.accessibilityLabel = "Share"
            shareButton.accessibilityHint = "Double tap to share."
        }
    }
    
    /// Save button
    @IBOutlet private var saveButton: UIImageView! {
        didSet {
            saveButton.accessibilityIdentifier = DetailViewAccessibilityIdentifier.Button.saveToPhotosButton
            saveButton.isAccessibilityElement = true
            saveButton.accessibilityTraits = .button
            saveButton.accessibilityLabel = "Save to Photos"
            saveButton.accessibilityHint = "Double tap save to Photos."
            saveButton.isHidden = viewModel.mediaType == .video
        }
    }
    
    /// Save button gesture recognizer
    @IBOutlet private var saveButtonGestureRecognizer: UITapGestureRecognizer!
    
    /// Date label
    @IBOutlet private var dateLabel: UILabel! {
        didSet {
            dateLabel.accessibilityIdentifier = DetailViewAccessibilityIdentifier.Label.dateLabel
            dateLabel.font = DynamicFont.shared.font(forTextStyle: .subheadline)
            dateLabel.adjustsFontForContentSizeCategory = false
            dateLabel.text = viewModel.preferredDate ?? viewModel.date
        }
    }
    
    /// Title label
    @IBOutlet private var titleLabel: UILabel! {
        didSet {
            titleLabel.accessibilityIdentifier = DetailViewAccessibilityIdentifier.Label.titleLabel
            titleLabel.font = DynamicFont.shared.font(forTextStyle: .headline)
            titleLabel.adjustsFontForContentSizeCategory = false
            titleLabel.text = viewModel.title
        }
    }
    
    /// Explanation label
    @IBOutlet private var explanationLabel: UILabel! {
        didSet {
            explanationLabel.accessibilityIdentifier = DetailViewAccessibilityIdentifier.Label.explanationLabel
            explanationLabel.font = DynamicFont.shared.font(forTextStyle: .body)
            explanationLabel.adjustsFontForContentSizeCategory = false
            explanationLabel.text = viewModel.explanation
        }
    }
    
    /// Copyright label
    @IBOutlet private var copyrightLabel: UILabel! {
        didSet {
            copyrightLabel.accessibilityIdentifier = DetailViewAccessibilityIdentifier.Label.copyrightLabel
            copyrightLabel.font = DynamicFont.shared.font(forTextStyle: .body)
            copyrightLabel.adjustsFontForContentSizeCategory = false
            copyrightLabel.attributedText = viewModel.copyright
            copyrightLabel.isHidden = viewModel.copyright.isNil
        }
    }
    
    /// Date label gesture recognizer
    @IBOutlet private var dateLabelGestureRecognizer: UITapGestureRecognizer! {
        didSet {
            dateLabelGestureRecognizer.isEnabled = viewModel.preferredDate.isNotNil
        }
    }
    
    // View controller identifier
    static let identifier = String(describing: DetailViewController.self)
    
    /// Image view
    private lazy var imageView = UIImageView()
    
    /// Web view
    private lazy var webView = WKWebView()
        
    /// Feedback generator
    private var feedbackGenerator = UISelectionFeedbackGenerator()
    
    /// Share manager
    private let shareManager = ShareManager()
    
    /// View model
    var viewModel: ApodViewModel
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init?(coder: NSCoder, viewModel: ApodViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    // MARK: View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = viewModel.url {
            switch viewModel.mediaType {
            case .image:
                setupImageView(with: url)
            case .video:
                setupWebView(with: url)
            }
        }
        updateFavoritesButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Update favorites button everytime the view appears
        updateFavoritesButton()
    }
    
    // MARK: View Updates
    
    private func updateFavoritesButton() {
        UserDefaultsFavoritesManager.shared.isFavorite(viewModel.apod) { isFavorite in
            animateFavoritesButtonTransition(isFavorite: isFavorite)
            updateAccesibilityValueForFavoritesButton(isFavorite: isFavorite)
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
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        mediaContainerView.pinSubView(imageView)
        imageView.af_setImage(withURL: url, imageTransition: .crossDissolve(0.2))
        applyAccessibilityAttributesforImageView(imageView)
        
        // Cannot add accessibility attributes to Lightbox. Therefore, we disable the feature when using VoiceOver
        if !UIAccessibility.isVoiceOverRunning {
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnImage(_:))))
        }
    }
    
    private func setupWebView(with url: URL) {
        mediaContainerView.pinSubView(webView)
        webView.load(URLRequest(url: url))
        applyAccesibilityAttributesforWebView(webView)
    }
    
    // MARK: User interaction
    
    @objc private func didTapOnImage(_ sender: UITapGestureRecognizer? = nil) {
        if let sender = sender, let imageView = sender.view as? UIImageView, let image = imageView.image {
            let lightboxController = LightboxController(image: image)
            present(lightboxController, animated: true)
        }
    }
    
    @IBAction private func didTapOnDateLabel(_ sender: Any) {
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
    
    @IBAction private func didTapOnFavorites(_ sender: Any) {
        UserDefaultsFavoritesManager.shared.isFavorite(viewModel.apod) { [weak self] isFavorite in
            guard let self = self else { return }
            isFavorite ? UserDefaultsFavoritesManager.shared.removeFromFavorites(viewModel.apod) : UserDefaultsFavoritesManager.shared.addToFavorites(viewModel.apod)
            feedbackGenerator.selectionChanged()
            self.animateFavoritesButtonTransition(isFavorite: !isFavorite)
            self.updateAccesibilityValueForFavoritesButton(isFavorite: !isFavorite)
        }
    }
        
    @IBAction private func didTapOnShare(_ sender: Any) {
        switch viewModel.mediaType {
        case .image:
            if let image = imageView.image {
                let activityViewController = shareManager.activityViewController(with: .image(image))
                present(activityViewController, animated: true)
            }
        case .video:
            let activityViewController = shareManager.activityViewController(with: .video(viewModel.apod.urlString))
            present(activityViewController, animated: true)
        }
    }
    
    @IBAction private func didTapOnSave(_ sender: Any) {
        guard let image = imageView.image else { return }
        saveButtonGestureRecognizer.isEnabled = false
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompletionHandler), nil)
        feedbackGenerator.selectionChanged()
    }
    
    @objc func saveCompletionHandler(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        guard error == nil else {
            presentAlertForDeniedAccessToPhotos()
            self.saveButtonGestureRecognizer.isEnabled = true
            return
        }
        view.makeToast(DetailViewStrings.saveToPhotosSucceededMessage.localized, duration: 2.0, position: .bottom) { _ in
            self.saveButtonGestureRecognizer.isEnabled = true
        }
    }
    
    // MARK: Alert
    
    private func presentAlertForDeniedAccessToPhotos() {
        let alertController = UIAlertController (title: "Allow Cosmos access to your photos", message: "To save images please allow Cosmos access from Settings.", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: Accessibility

extension DetailViewController {
    private func applyAccessibilityAttributesforImageView(_ imageView: UIImageView) {
        imageView.isAccessibilityElement = true
        imageView.accessibilityLabel = viewModel.title
        imageView.accessibilityTraits = .image
        imageView.accessibilityIdentifier = DetailViewAccessibilityIdentifier.Image.imageView
    }
    
    private func applyAccesibilityAttributesforWebView(_ webView: WKWebView) {
        webView.isAccessibilityElement = true
        webView.accessibilityLabel = viewModel.title
        webView.accessibilityTraits = .startsMediaSession
        webView.accessibilityHint = "Double tap to play media."
        webView.accessibilityIdentifier = DetailViewAccessibilityIdentifier.WebView.webView
    }
    
    private func updateAccesibilityValueForFavoritesButton(isFavorite: Bool) {
        if isFavorite {
            favoritesButton.accessibilityValue = "Added"
            favoritesButton.accessibilityHint = "Double tap to remove from favorites."
        } else {
            favoritesButton.accessibilityValue = "Not in favorites"
            favoritesButton.accessibilityHint = "Double tap to add to favorites."
        }
    }
}
