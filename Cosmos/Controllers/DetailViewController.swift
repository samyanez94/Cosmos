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
    
    var apod: APOD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let apod = apod {
            configure(with: APODViewModel(apod: apod))
        }
    }
    
    func configure(with viewModel: APODViewModel) {
        imageView.image = viewModel.image
        dateView.text = viewModel.date
        titleView.text = viewModel.title
        explanationView.text = viewModel.explanation
        copyrightView.text = viewModel.copyright ?? ""
    }
}
