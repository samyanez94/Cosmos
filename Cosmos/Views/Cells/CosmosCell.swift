//
//  CosmosCell.swift
//  Cosmos
//
//  Created by Samuel Yanez on 7/21/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import UIKit

class CosmosCell: UICollectionViewCell {
    
    /// Image View
    @IBOutlet var imageView: UIImageView!
    
    /// Header View
    @IBOutlet var headerView: UIView!
    
    /// Container View
    @IBOutlet var containerView: UIView!
    
    /// Title Label
    @IBOutlet var titleLabel: UILabel!
    
    /// Date Label
    @IBOutlet var dateLabel: UILabel!
    
    /// Identifier
    static let identifier = "com.samuelyanez.CosmosCell"
    
    /// Height
    static let height: CGFloat = 450
    
    /// Corner radius
    static let cornerRadius: CGFloat = 20
    
    /// Feedback generator
    var feedbackGenerator: UISelectionFeedbackGenerator?
    
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
