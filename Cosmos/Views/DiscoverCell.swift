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
    @IBOutlet private var imageView: UIImageView!
    
    /// Header view
    @IBOutlet private var headerView: UIView!
    
    /// Container view
    @IBOutlet private var containerView: UIView!
    
    /// Title label
    @IBOutlet private var titleLabel: UILabel! {
        didSet {
            titleLabel.font = DynamicFont.shared.font(forTextStyle: .headline)
            titleLabel.adjustsFontForContentSizeCategory = false
        }
    }
    
    /// Date label
    @IBOutlet private var dateLabel: UILabel! {
        didSet {
            dateLabel.font = DynamicFont.shared.font(forTextStyle: .subheadline)
            dateLabel.adjustsFontForContentSizeCategory = false
        }
    }
    
    /// Activity indicator
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    /// Placeholder image
    static let placeholderImage = UIImage(named: "Missing Image Placeholder")
        
    /// Feedback generator
    private var feedbackGenerator: UISelectionFeedbackGenerator?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureGestureRecognizer()
        applyAccessibilityAttributes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureGestureRecognizer()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setShadow(opacity: 0.2, radius: 20)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.roundCorners(radius: 20)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        imageView.af_cancelImageRequest()
    }
    
    func update(with viewModel: ApodViewModel) {
        titleLabel.text = viewModel.title
        dateLabel.text = viewModel.preferredDate ?? viewModel.date
        setImageView(with: viewModel.thumbnailUrl)
        updateAccessibilityAttributes(for: viewModel)
    }
}

extension DiscoverCell {
    private func setImageView(with url: URL?) {
        guard let url = url else {
            imageView.image = DiscoverCell.placeholderImage
            return
        }
        activityIndicator.startAnimating()
        imageView.af_setImage(withURL: url, imageTransition: .crossDissolve(0.2)) { [weak self] data in
            guard data.response?.statusCode != 404 else {
                self?.imageView.image = DiscoverCell.placeholderImage
                self?.activityIndicator.stopAnimating()
                return
            }
            self?.activityIndicator.stopAnimating()
        }
    }
}

// MARK: - Accesibility

extension DiscoverCell {
    private func applyAccessibilityAttributes() {
        containerView.isAccessibilityElement = true
        containerView.accessibilityTraits = .button
        containerView.accessibilityHint = "Double tap to show more details."
    }
    
    private func updateAccessibilityAttributes(for viewModel: ApodViewModel) {
        containerView.accessibilityLabel = "\(viewModel.preferredDate ?? viewModel.date). \(viewModel.title)"
    }
}

// MARK: - Gesture Recognizer

extension DiscoverCell {
    private func configureGestureRecognizer() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(gestureRecognizer:)))
        longPressGestureRecognizer.minimumPressDuration = 0.25
        addGestureRecognizer(longPressGestureRecognizer)
    }
    
    @objc private func handleLongPressGesture(gestureRecognizer: UILongPressGestureRecognizer) {
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
