//
//  DetailViewController.swift
//  Cosmos
//
//  Created by Samuel Yanez on 8/11/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import UIKit
import Lightbox

class DetailViewController: UIViewController {
    
    var viewer = LightboxController()
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var dateView: UILabel!
    @IBOutlet var titleView: UILabel!
    @IBOutlet var explanationView: UILabel!
    @IBOutlet var copyrightView: UILabel!
    
    var apod: APOD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let apod = apod, let image = apod.image {
            configure(with: APODViewModel(apod: apod))
            viewer = LightboxController(images: [LightboxImage(image: image, text: apod.title)])
        }
        LightboxConfig.PageIndicator.enabled = false
        LightboxConfig.InfoLabel.textAttributes = [
            .font: UIFont.systemFont(ofSize: 17),
            .foregroundColor: UIColor.white
        ]
    }
    
    func configure(with viewModel: APODViewModel) {
        imageView.image = viewModel.image
        dateView.text = viewModel.date
        titleView.text = viewModel.title
        explanationView.text = viewModel.explanation
        copyrightView.text = viewModel.copyright ?? ""
    }
    
    @IBAction func didTapOnImage(_ sender: Any) {
        present(viewer, animated: true, completion: nil)
    }
}
