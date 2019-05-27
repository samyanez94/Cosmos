//
//  DetailViewController.swift
//  Cosmos
//
//  Created by Samuel Yanez on 8/11/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import UIKit
import AVKit
import QuickLook
import AlamofireImage

class DetailViewController: UIViewController {
        
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var explanationLabel: UILabel!
    @IBOutlet var copyrightLabel: UILabel!
    
    // Quick look controller
    let previewController = QLPreviewController()
    
    /// Sets the status bar to be hidden.
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    /// The current APOD.
    var apod: APOD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let apod = apod {
            configure(with: APODViewModel(with: apod))
            setResource(for: apod)
        }
        scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    private func configure(with viewModel: APODViewModel) {
        dateLabel.text = viewModel.date
        titleLabel.text = viewModel.title
        explanationLabel.text = viewModel.explanation
        copyrightLabel.text = viewModel.copyright ?? ""
    }
    
    private func setResource(for apod: APOD) {
        switch apod.mediaType {
        case .image:
            if let url = URL(string: apod.url) {
                imageView.af_setImage(withURL: url, imageTransition: .crossDissolve(0.2))
            }
        case .video:
            imageView.image = UIImage(named: "invalid-placeholder")
        }
    }
    
    // MARK: User Interaction
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapOnImage(_ sender: Any) {
        present(previewController, animated: true)
    }
}
