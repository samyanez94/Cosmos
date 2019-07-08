//
//  DetailViewController.swift
//  Cosmos
//
//  Created by Samuel Yanez on 8/11/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import UIKit
import WebKit
import AlamofireImage
import Lightbox

class DetailViewController: UIViewController {
        
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var mediaView: UIView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var explanationLabel: UILabel!
    @IBOutlet var copyrightLabel: UILabel!
    
    let activityIndicator = UIActivityIndicatorView()
    
    /// The current astronomical picture of the day.
    var apod: APOD?
    
    /// Sets the status bar to be hidden.
    override var prefersStatusBarHidden: Bool {
        true
    }
    
    override func viewDidLoad() {
        if let apod = apod {
            configure(for: apod)
        }
        scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    private func configure(for apod: APOD) {
        let viewModel = APODViewModel(with: apod)

        dateLabel.text = viewModel.date
        titleLabel.text = viewModel.title
        explanationLabel.text = viewModel.explanation
        copyrightLabel.text = viewModel.copyright ?? ""
        
        loadResource(for: apod)
    }
    
    private func loadResource(for apod: APOD) {
        if let url = URL(string: apod.url) {
            switch apod.mediaType {
            case .image:
                setupImageView(with: url)
            case .video:
                setupWebView(with: url)
                setupActivityIndicator()
            }
        }
    }
    
    // MARK: Media View Helpers
    
    private func setupImageView(with url: URL) {
        let imageView = UIImageView(frame: mediaView.frame)
        imageView.contentMode = .scaleAspectFill
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.af_setImage(withURL: url, imageTransition: .crossDissolve(0.2))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnImage(_:))))
        
        mediaView.addSubview(imageView)
    }
    
    private func setupWebView(with url: URL) {
        let webView = WKWebView(frame: mediaView.frame)
        webView.navigationDelegate = self
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.load(URLRequest(url: url))
        
        mediaView.addSubview(webView)
    }
    
    private func setupActivityIndicator() {
        activityIndicator.center = mediaView.center
        activityIndicator.style = .gray
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        activityIndicator.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        
        mediaView.addSubview(activityIndicator)
    }
    
    // MARK: User Interaction
    
    @objc func didTapOnImage(_ sender: UITapGestureRecognizer? = nil) {
        if let sender = sender, let imageView = sender.view as? UIImageView, let image = imageView.image {
            let lighboxImage = LightboxImage(image: image)
            let lightboxController = LightboxController(images: [lighboxImage])
            lightboxController.dynamicBackground = true
            present(lightboxController, animated: true)
        }
    }
}

// MARK: Web View Navigation Delegate

extension DetailViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }
}
