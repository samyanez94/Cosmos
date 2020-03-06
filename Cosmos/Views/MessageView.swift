//
//  MessageView.swift
//  Cosmos
//
//  Created by Samuel Yanez on 3/5/20.
//  Copyright © 2020 Samuel Yanez. All rights reserved.
//

import UIKit

protocol MessageViewDelegate: AnyObject {
    func messageView(_ messageView: MessageView, didTapOnRefreshButton refreshButton: UIButton)
}

@IBDesignable
class MessageView: UIView {
    
    // Content view
    @IBOutlet var contentView: UIView!
    
    // Image view
    @IBOutlet private var imageView: UIImageView!
    
    // Label view
    @IBOutlet private var label: UILabel! {
        didSet {
            label.font = DynamicFont.shared.font(forTextStyle: .body)
            label.adjustsFontForContentSizeCategory = false
        }
    }
    
    // Refresh button
    @IBOutlet var refreshButton: UIButton! {
        didSet {
            refreshButton.isHidden = true
            refreshButton.titleLabel?.font = DynamicFont.shared.font(forTextStyle: .subheadline)
            refreshButton.titleLabel?.adjustsFontForContentSizeCategory = false
        }
    }
    
    weak var delegate: MessageViewDelegate?
    
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
        refreshButton.roundCorners(radius: 5.0)
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
    
    func setImage(to image: UIImage?) {
        imageView.image = image
    }
    
    func setMessage(to message: String?) {
        label.text = message
    }
    
    @IBAction func didTapOnRefreshButton(_ sender: UIButton) {
        delegate?.messageView(self, didTapOnRefreshButton: sender)
    }
    
}
