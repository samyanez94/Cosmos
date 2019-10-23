//
//  DiscoverCell.swift
//  Cosmos
//
//  Created by Samuel Yanez on 7/21/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import UIKit

class DiscoverCell: UICollectionViewCell {

    /// Image view
    @IBOutlet var imageView: UIImageView!
    
    /// Header view
    @IBOutlet var headerView: UIView!
    
    /// Container view
    @IBOutlet var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = DiscoverCell.cornerRadius
        }
    }
    
    /// Title label
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.font = scaledFont.font(forTextStyle: .headline)
            titleLabel.adjustsFontForContentSizeCategory = true
        }
    }
    
    /// Date label
    @IBOutlet var dateLabel: UILabel! {
        didSet {
            dateLabel.font = scaledFont.font(forTextStyle: .subheadline)
            dateLabel.adjustsFontForContentSizeCategory = true
        }
    }
    
    /// Activity indicator
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    /// Missing thumbnail view
    @IBOutlet var missingThumbnailView: MissingThumbnailView!
    
    /// Identifier
    static let identifier = "com.samuelyanez.DiscoverCell"
    
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
}
// MARK: - Accesibility

extension DiscoverCell {
    
    func applyAccessibilityAttributes(for viewModel: APODViewModel) {
        containerView.accessibilityLabel = "\(viewModel.preferredDate ?? viewModel.date). \(viewModel.title)"
        containerView.accessibilityTraits = UIAccessibilityTraits.button
        containerView.accessibilityHint = "Double tap to show more details about this media."
    }
}

// MARK: - Gesture Recognizer

extension DiscoverCell {
        
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
