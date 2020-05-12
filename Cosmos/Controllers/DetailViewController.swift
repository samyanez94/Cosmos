//
//  DetailViewController.swift
//  Cosmos
//
//  Created by Samuel Yanez on 8/11/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import Photos
import UIKit
import Lightbox
import Toast_Swift

final class DetailViewController: UIViewController {
        
    /// Scroll view
    @IBOutlet private var scrollView: UIScrollView! {
        didSet {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
    }
    
    /// Media view
    @IBOutlet private var mediaView: MediaView! {
        didSet {
            mediaView.delegate = self
        }
    }
    
    /// Favorites button
    @IBOutlet private var favoritesButton: UIImageView! {
        didSet {
            favoritesButton.accessibilityIdentifier = DetailViewAccessibilityIdentifier.Button.favoritesButton
            favoritesButton.accessibilityLabel = "Favorites"
            favoritesButton.showsLargeContentViewer = true
            favoritesButton.largeContentTitle = "Favorites"
            favoritesButton.addInteraction(UILargeContentViewerInteraction())
        }
    }
    
    /// Share button
    @IBOutlet private var shareButton: UIImageView! {
        didSet {
            shareButton.accessibilityIdentifier = DetailViewAccessibilityIdentifier.Button.shareButton
            shareButton.accessibilityLabel = "Share"
            shareButton.accessibilityHint = "Double tap to share."
            shareButton.showsLargeContentViewer = true
            shareButton.largeContentTitle = "Share"
            shareButton.addInteraction(UILargeContentViewerInteraction())
        }
    }
    
    /// Save button
    @IBOutlet private var saveButton: UIImageView! {
        didSet {
            saveButton.accessibilityIdentifier = DetailViewAccessibilityIdentifier.Button.saveToPhotosButton
            saveButton.accessibilityLabel = "Save to Photos"
            saveButton.accessibilityHint = "Double tap save to Photos."
            saveButton.showsLargeContentViewer = true
            saveButton.largeContentTitle = "Save to Photos"
            saveButton.addInteraction(UILargeContentViewerInteraction())
        }
    }
    
    /// Date label
    @IBOutlet private var dateLabel: UILabel! {
        didSet {
            dateLabel.accessibilityIdentifier = DetailViewAccessibilityIdentifier.Label.dateLabel
            dateLabel.font = DynamicFont.shared.font(forTextStyle: .subheadline)
            dateLabel.adjustsFontForContentSizeCategory = true
            dateLabel.text = viewModel.preferredDate ?? viewModel.date
        }
    }
    
    /// Title label
    @IBOutlet private var titleLabel: UILabel! {
        didSet {
            titleLabel.accessibilityIdentifier = DetailViewAccessibilityIdentifier.Label.titleLabel
            titleLabel.font = DynamicFont.shared.font(forTextStyle: .headline)
            titleLabel.adjustsFontForContentSizeCategory = true
            titleLabel.text = viewModel.title
        }
    }
    
    /// Explanation label
    @IBOutlet private var explanationLabel: UILabel! {
        didSet {
            explanationLabel.accessibilityIdentifier = DetailViewAccessibilityIdentifier.Label.explanationLabel
            explanationLabel.font = DynamicFont.shared.font(forTextStyle: .body)
            explanationLabel.adjustsFontForContentSizeCategory = true
            explanationLabel.text = viewModel.explanation
        }
    }
    
    /// Copyright label
    @IBOutlet private var copyrightLabel: UILabel! {
        didSet {
            copyrightLabel.accessibilityIdentifier = DetailViewAccessibilityIdentifier.Label.copyrightLabel
            copyrightLabel.font = DynamicFont.shared.font(forTextStyle: .body)
            copyrightLabel.adjustsFontForContentSizeCategory = true
            copyrightLabel.attributedText = viewModel.copyright
            copyrightLabel.isHidden = viewModel.copyright.isNil
        }
    }
    
    /// Save button gesture recognizer
    @IBOutlet private var saveButtonGestureRecognizer: UITapGestureRecognizer!
    
    /// Date label gesture recognizer
    @IBOutlet private var dateLabelGestureRecognizer: UITapGestureRecognizer! {
        didSet {
            dateLabelGestureRecognizer.isEnabled = viewModel.preferredDate.isNotNil
        }
    }
    
    // View controller identifier
    static let identifier = String(describing: DetailViewController.self)
        
    /// Feedback generator
    private var feedbackGenerator = UISelectionFeedbackGenerator()
    
    /// Favorites manager
    private let favoritesManager = FavoritesManager.shared
    
    /// Share manager
    private let shareManager = ShareManager()
    
    /// View model
    var viewModel: ApodViewModel
    
    private var resourceType: Apod.MediaType = .image {
        didSet {
            switch resourceType {
            case .image:
                mediaView.setup(for: .image(url: viewModel.mediaURL, label: viewModel.title))
                saveButton.isHidden = false
            case .video:
                mediaView.setup(for: .video(url: viewModel.mediaURL, label: viewModel.title))
                saveButton.isHidden = true
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init?(coder: NSCoder, viewModel: ApodViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Update the resource type
        resourceType = viewModel.mediaType
        
        // Update the favorites button
        updateFavoritesButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Update favorites button every time the view appears
        updateFavoritesButton()
    }
    
    // MARK: View Updates
    
    private func updateFavoritesButton() {
        favoritesManager.isFavorite(viewModel.apod) { [unowned self] isFavorite in
            self.animateFavoritesButtonTransition(isFavorite: isFavorite)
            self.updateAccesibilityAttributesForFavoritesButton(isFavorite: isFavorite)
        }
    }
    
    private func animateFavoritesButtonTransition(isFavorite: Bool) {
        let animations: (() -> Void) = { [unowned self] in
            self.favoritesButton.image = isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        }
        UIView.transition(with: favoritesButton,
                          duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: animations,
                          completion: nil)
    }
    
    // MARK: User Interaction
    
    @IBAction private func didTapOnDateLabel(_ sender: Any) {
        guard let preferredDate = viewModel.preferredDate else {
            return
        }
        let animations: (() -> Void) = { [unowned self] in
            self.dateLabel.text = self.dateLabel.text == preferredDate ? self.viewModel.date : preferredDate
        }
        UIView.transition(with: dateLabel,
                          duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: animations,
                          completion: nil)
    }
    
    @IBAction private func didTapOnFavorites(_ sender: Any) {
        favoritesManager.isFavorite(viewModel.apod) { [unowned self] isFavorite in
            isFavorite ? self.favoritesManager.removeFromFavorites(viewModel.apod) : self.favoritesManager.addToFavorites(viewModel.apod)
            feedbackGenerator.selectionChanged()
            self.animateFavoritesButtonTransition(isFavorite: !isFavorite)
            self.updateAccesibilityAttributesForFavoritesButton(isFavorite: !isFavorite)
        }
    }
        
    @IBAction private func didTapOnShare(_ sender: Any) {
        switch viewModel.mediaType {
        case .image:
            guard let image = mediaView.image else { return }
            let activityViewController = shareManager.activityViewController(for: .image(image))
            present(activityViewController, animated: true)
        case .video:
            let activityViewController = shareManager.activityViewController(for: .video(viewModel.apod.mediaURL.absoluteString))
            present(activityViewController, animated: true)
        }
    }
    
    @IBAction private func didTapOnSaveToPhotos(_ sender: Any) {
        guard let image = mediaView.image else { return }
        saveButtonGestureRecognizer.isEnabled = false
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveToPhotosHandler), nil)
        feedbackGenerator.selectionChanged()
    }
    
    @objc func saveToPhotosHandler(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        guard error == nil else {
            presentAlertForDeniedAccessToPhotos()
            saveButtonGestureRecognizer.isEnabled = true
            return
        }
        view.makeToast(DetailViewStrings.saveToPhotosSucceededMessage.localized, duration: 2.0, position: .bottom) { _ in
            self.saveButtonGestureRecognizer.isEnabled = true
        }
    }
    
    // MARK: Alert
    
    private func presentAlertForDeniedAccessToPhotos() {
        let alertController = UIAlertController (title: DetailViewStrings.deniedAccessToPhotosTitle.localized, message: DetailViewStrings.deniedAccessToPhotosMessage.localized, preferredStyle: .alert)
        let settingsActionHandler: ((UIAlertAction) -> Void)? = { (_) in
            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
        let settingsAction = UIAlertAction(title: DetailViewStrings.settingsAction.localized, style: .default, handler: settingsActionHandler)
        let cancelAction = UIAlertAction(title: DetailViewStrings.cancelAction.localized, style: .default, handler: nil)
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: MediaViewDelegate

extension DetailViewController: MediaViewDelegate {
    func mediaView(_ mediaView: MediaView, didTapImage image: UIImage) {
        if !UIAccessibility.isVoiceOverRunning {
            let lightboxController = LightboxController(image: image)
            present(lightboxController, animated: true)
        }
    }
}

// MARK: Accessibility

extension DetailViewController {
    private func updateAccesibilityAttributesForFavoritesButton(isFavorite: Bool) {
        if isFavorite {
            favoritesButton.accessibilityValue = "Added"
            favoritesButton.accessibilityHint = "Double tap to remove from favorites."
        } else {
            favoritesButton.accessibilityValue = "Not added"
            favoritesButton.accessibilityHint = "Double tap to add to favorites."
        }
    }
}
