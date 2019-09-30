//
//  CosmosCell.swift
//  Cosmos
//
//  Created by Samuel Yanez on 7/21/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import UIKit

class CosmosCell: UICollectionViewCell {

    /// Image view
    @IBOutlet var imageView: UIImageView!
    
    /// Header view
    @IBOutlet var headerView: UIView!
    
    /// Container view
    @IBOutlet var containerView: UIView!
    
    /// Title label
    @IBOutlet var titleLabel: UILabel!
    
    /// Date label
    @IBOutlet var dateLabel: UILabel!
    
    /// Activity indicator
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    /// Missing thumbnail view
    @IBOutlet var missingThumbnailView: MissingThumbnailView!
    
    /// Identifier
    static let identifier = "com.samuelyanez.CosmosCell"
    
    /// Height
    static let height: CGFloat = 450
    
    /// Corner radius
    static let cornerRadius: CGFloat = 20
    
    /// Feedback generator
    var feedbackGenerator: UISelectionFeedbackGenerator?
    
    /// Utility used for dynamic types
    private lazy var scaledFont: ScaledFont = {
         return ScaledFont()
     }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureGestureRecognizer()
    }
    
    override func draw(_ rect: CGRect) {
        setupShadow()
        setupBorderRadius()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        imageView.af_cancelImageRequest()
        
        missingThumbnailView.isHidden = true
    }
    
    private func setupShadow() {
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: -1, height: 2)
        layer.masksToBounds = false
    }
    
    private func setupBorderRadius() {
        containerView.layer.cornerRadius = CosmosCell.cornerRadius
    }
}
// MARK: - Accesibility

extension CosmosCell {
    
    func applyAccessibilityAttributes(for apod: APOD) {
        containerView.accessibilityTraits = UIAccessibilityTraits.button
        containerView.accessibilityLabel = "\(apod.preferredDateString ?? apod.dateString). \(apod.title)"
        containerView.accessibilityHint = "Double tap to show more details about this media."
    }
    
    func setupDynamicFonts() {
        dateLabel.font = scaledFont.font(forTextStyle: .subheadline)
        dateLabel.adjustsFontForContentSizeCategory = true
        titleLabel.font = scaledFont.font(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
     }
}

// MARK: - Gesture Recognizer

extension CosmosCell {
        
    private func configureGestureRecognizer() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(gestureRecognizer:)))
        longPressGestureRecognizer.minimumPressDuration = 0.25
        addGestureRecognizer(longPressGestureRecognizer)
    }
    
    @objc internal func handleLongPressGesture(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            handleLongPressBegan()
        } else if gestureRecognizer.state == .ended || gestureRecognizer.state == .cancelled {
            handleLongPressEnded()
        }
    }
    
    private func handleLongPressBegan() {
        feedbackGenerator = UISelectionFeedbackGenerator()
        feedbackGenerator?.prepare()
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: .beginFromCurrentState, animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.feedbackGenerator?.selectionChanged()
        }, completion: { _ in
            self.feedbackGenerator = nil
        })
    }
    
    private func handleLongPressEnded() {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: .beginFromCurrentState, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}
