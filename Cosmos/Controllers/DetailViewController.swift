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
        }
    }
    
    /// Save button gesture recognizer
    @IBOutlet var saveButtonGestureRecognizer: UITapGestureRecognizer!
    
    /// Date label
    @IBOutlet private var dateLabel: UILabel! {
        didSet {
            dateLabel.accessibilityIdentifier = DetailViewAccessibilityIdentifier.Label.dateLabel
            dateLabel.font = DynamicFont.shared.font(forTextStyle: .subheadline)
            dateLabel.adjustsFontForContentSizeCategory = false
        }
    }
    
    /// Title label
    @IBOutlet private var titleLabel: UILabel! {
        didSet {
            titleLabel.accessibilityIdentifier = DetailViewAccessibilityIdentifier.Label.titleLabel
            titleLabel.font = DynamicFont.shared.font(forTextStyle: .headline)
            titleLabel.adjustsFontForContentSizeCategory = false
        }
    }
    
    /// Explanation label
    @IBOutlet private var explanationLabel: UILabel! {
        didSet {
            explanationLabel.accessibilityIdentifier = DetailViewAccessibilityIdentifier.Label.explanationLabel
            explanationLabel.font = DynamicFont.shared.font(forTextStyle: .body)
            explanationLabel.adjustsFontForContentSizeCategory = false
        }
    }
    
    /// Copyright label
    @IBOutlet private var copyrightLabel: UILabel! {
        didSet {
            copyrightLabel.accessibilityIdentifier = DetailViewAccessibilityIdentifier.Label.copyrightLabel
            copyrightLabel.font = DynamicFont.shared.font(forTextStyle: .body)
            copyrightLabel.adjustsFontForContentSizeCategory = false
        }
    }
    
    /// Date label gesture recognizer
    @IBOutlet private var dateLabelGestureRecognizer: UITapGestureRecognizer!
    
    /// Image view
    private lazy var imageView = UIImageView()
    
    /// Web view
    private lazy var webView = WKWebView()
    
    /// View model
    var viewModel: ApodViewModel?
        
    /// Feedback generator
    private var feedbackGenerator = UISelectionFeedbackGenerator()
    
    /// Share manager
    private let shareManager = ShareManager()
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Update view everytime the view loads
        if let viewModel = viewModel {
            updateView(for: viewModel)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Update favorites button everytime the view appears
        if let viewModel = viewModel {
            updateFavoritesButton(for: viewModel)
        }
    }
    
    // MARK: View Updates
    
    private func updateView(for viewModel: ApodViewModel) {
        updateSubViews(for: viewModel)
        updateLabelsText(for: viewModel)
        updateMedia(for: viewModel)
        updateFavoritesButton(for: viewModel)
    }
    
    private func updateSubViews(for viewModel: ApodViewModel) {
        dateLabelGestureRecognizer.isEnabled = viewModel.preferredDate.isNotNil
        copyrightLabel.isHidden = viewModel.copyright.isNil
        saveButton.isHidden = viewModel.mediaType == .video
    }
    
    private func updateLabelsText(for viewModel: ApodViewModel) {
        dateLabel.text = viewModel.preferredDate ?? viewModel.date
        titleLabel.text = viewModel.title
        explanationLabel.text = viewModel.explanation
        copyrightLabel.attributedText = viewModel.copyright
    }
    
    private func updateMedia(for viewModel: ApodViewModel) {
        if let url = viewModel.url {
            switch viewModel.mediaType {
            case .image:
                setupImageView(with: url)
            case .video:
                setupWebView(with: url)
            }
        }
    }
    
    private func updateFavoritesButton(for viewModel: ApodViewModel) {
        UserDefaultsFavoritesManager.shared.isFavorite(viewModel.apod.date) { isFavorite in
            animateFavoritesButtonTransition(isFavorite: isFavorite)
            updateAccesibilityAttributesValueToFavoritesButton(isFavorite: isFavorite)
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
        // Observe user interaction events
        imageView.isUserInteractionEnabled = true
        
        // Image need to scale to always fill the size of the view
        imageView.contentMode = .scaleAspectFill
        
        // Pin view to container
        mediaContainerView.pinSubView(imageView)
        
        // Fetch image
        imageView.af_setImage(withURL: url, imageTransition: .crossDissolve(0.2))
        
        // Accessibility
        applyAccessibilityAttributesforImageView(imageView)
        
        // Cannot add accessibility attributes to Lightbox. Therefore, we disable the feature when using VoiceOver
        if !UIAccessibility.isVoiceOverRunning {
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnImage(_:))))
        }
    }
    
    private func setupWebView(with url: URL) {
        // Pin view to container
        mediaContainerView.pinSubView(webView)
        
        // Load URL
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
        UserDefaultsFavoritesManager.shared.isFavorite(viewModel.apod.date) { [weak self] isFavorite in
            guard let self = self, let viewModel = self.viewModel else { return }
            isFavorite ? UserDefaultsFavoritesManager.shared.removeFromFavorites(viewModel.apod.date) : UserDefaultsFavoritesManager.shared.addToFavorites(viewModel.apod.date)
            feedbackGenerator.selectionChanged()
            self.animateFavoritesButtonTransition(isFavorite: !isFavorite)
            self.updateAccesibilityAttributesValueToFavoritesButton(isFavorite: !isFavorite)
        }
    }
        
    @IBAction func didTapOnShare(_ sender: Any) {
        guard let viewModel = viewModel else { return }
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
    
    @IBAction func didTapOnSave(_ sender: Any) {
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
            guard let url = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(url) {
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
    
    private func updateAccesibilityAttributesValueToFavoritesButton(isFavorite: Bool) {
        if isFavorite {
            favoritesButton.accessibilityValue = "Added"
            favoritesButton.accessibilityHint = "Double tap to remove from favorites."
        } else {
            favoritesButton.accessibilityValue = "Not in favorites"
            favoritesButton.accessibilityHint = "Double tap to add to favorites."
        }
    }
}
