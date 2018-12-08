//
//  DetailViewController.swift
//  Cosmos
//
//  Created by Samuel Yanez on 8/11/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
        
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var dateView: UILabel!
    @IBOutlet var titleView: UILabel!
    @IBOutlet var explanationView: UILabel!
    @IBOutlet var copyrightView: UILabel!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var apod: APOD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let apod = apod else { return }
        
        configure(with: APODViewModel(apod: apod))
        
        if apod.mediaType == .image {
            if let url = URL(string: apod.url) {
                imageView.af_setImage(withURL: url)
            }
        } else {
            imageView.image = #imageLiteral(resourceName: "invalid_placeholder")
        }
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func configure(with viewModel: APODViewModel) {
        dateView.text = viewModel.date
        titleView.text = viewModel.title
        explanationView.text = viewModel.explanation
        copyrightView.text = viewModel.copyright ?? ""
    }
}
