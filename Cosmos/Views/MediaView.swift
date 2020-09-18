//
//  MediaView.swift
//  Cosmos
//
//  Created by Samuel Yanez on 3/30/20.
//  Copyright © 2020 Samuel Yanez. All rights reserved.
//

import Nuke
import UIKit
import WebKit

protocol MediaViewDelegate: AnyObject {
    func mediaView(_ mediaView: MediaView, didTapImage image: UIImage)
}

@IBDesignable
class MediaView: UIView {
    
    enum MediaType {
        case image(url: URL, label: String)
        case video(url: URL, label: String)
    }
    
    /// Content view
    @IBOutlet var contentView: UIView!
    
    /// Image view
    var image: UIImage?
    
    /// Delegate
    weak var delegate: MediaViewDelegate?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadViewFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        loadViewFromNib()
    }
    
    private func loadViewFromNib() {
        Bundle(for: MediaView.self).loadNibNamed(String(describing: MediaView.self), owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func setup(for mediaType: MediaType) {
        switch mediaType {
        case .image(let url, let label):
            setupImageView(with: url, andLabel: label)
        case .video(let url, let label):
            setupWebView(with: url, andLabel: label)
        }
    }
    
    private func setupImageView(with url: URL, andLabel label: String) {
        let imageView = UIImageView()
        addSubview(imageView)
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.frame = frame
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let imageLoadingOptions = ImageLoadingOptions(
            transition: .fadeIn(duration: 0.25)
        )
        Nuke.loadImage(with: url, options: imageLoadingOptions, into: imageView, completion: { [weak self] result in
            if case .success(let imageResponse) = result {
                self?.image = imageResponse.image
            }
        })
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnImage(_:))))
        applyAccessibilityAttributesforImageView(imageView, andLabel: label)
    }
    
    private func setupWebView(with url: URL, andLabel label: String) {
        let webView = WKWebView()
        addSubview(webView)
        webView.frame = frame
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let request = URLRequest(url: url)
        webView.load(request)
        applyAccesibilityAttributesforWebView(webView, andLabel: label)
    }
    
    @objc private func didTapOnImage(_ sender: UITapGestureRecognizer? = nil) {
        guard let image = image else { return }
        delegate?.mediaView(self, didTapImage: image)
    }
}

extension MediaView {
    private func applyAccessibilityAttributesforImageView(_ imageView: UIImageView, andLabel label: String) {
        imageView.isAccessibilityElement = true
        imageView.accessibilityLabel = label
        imageView.accessibilityTraits = .image
        imageView.accessibilityIdentifier = DetailViewAccessibilityIdentifier.Image.imageView
    }

    private func applyAccesibilityAttributesforWebView(_ webView: WKWebView, andLabel label: String) {
        webView.isAccessibilityElement = true
        webView.accessibilityLabel = label
        webView.accessibilityTraits = .startsMediaSession
        webView.accessibilityHint = "Double tap to play media."
        webView.accessibilityIdentifier = DetailViewAccessibilityIdentifier.WebView.webView
    }
}
