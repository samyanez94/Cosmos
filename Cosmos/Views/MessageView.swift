//
//  MessageView.swift
//  Cosmos
//
//  Created by Samuel Yanez on 3/5/20.
//  Copyright © 2020 Samuel Yanez. All rights reserved.
//

import UIKit

@IBDesignable
class MessageView: UIView {
    
    /// Content view
    @IBOutlet var contentView: UIView!
    
    /// Image view
    @IBOutlet var imageView: UIImageView! {
        didSet {
            imageView.accessibilityIdentifier = MessageViewAccessibilityIdentifier.Image.imageView
        }
    }
    
    /// Label view
    @IBOutlet var label: UILabel! {
        didSet {
            label.accessibilityIdentifier = MessageViewAccessibilityIdentifier.Label.label
            label.font = DynamicFont.shared.font(forTextStyle: .body)
            label.adjustsFontForContentSizeCategory = false
        }
    }
    
    /// Refresh button
    @IBOutlet var refreshButton: UIButton! {
        didSet {
            refreshButton.accessibilityIdentifier = MessageViewAccessibilityIdentifier.Button.refreshButton
            refreshButton.isHidden = true
            refreshButton.titleLabel?.font = DynamicFont.shared.font(forTextStyle: .subheadline)
            refreshButton.titleLabel?.adjustsFontForContentSizeCategory = false
            refreshButton.accessibilityHint = "Double tap to try again."
        }
    }
    
    /// Refresh button completion handler
    var refreshButtonHandler: (() -> Void)?
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadViewFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        refreshButton.roundCorners(radius: 20.0)
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        loadViewFromNib()
    }
    
    private func loadViewFromNib() {
        Bundle(for: MessageView.self).loadNibNamed(String(describing: MessageView.self), owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    @IBAction func didTapOnRefreshButton(_ sender: UIButton) {
        refreshButtonHandler?()
    }
    
}
