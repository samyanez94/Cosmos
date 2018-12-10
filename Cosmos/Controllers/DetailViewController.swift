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
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var explanationLabel: UILabel!
    @IBOutlet var copyrightLabel: UILabel!
    
    /// Sets the status bar to be hidden.
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    /// The current Astronomy Picture of the Day.
    var apod: APOD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let apod = apod {
            do {
                try setup(for: apod)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    private func setup(for apod: APOD) throws {
        let viewModel = APODViewModel(for: apod)
        
        // Setup the labels
        dateLabel.text = viewModel.date
        titleLabel.text = viewModel.title
        explanationLabel.text = viewModel.explanation
        copyrightLabel.text = viewModel.copyright ?? ""
        
        // Check for a valid url
        guard let url = URL(string: apod.url) else {
            throw CosmosError.invalidURL
        }
        
        // Switch media type
        switch apod.mediaType {
        case .image:
            imageView.af_setImage(withURL: url)
        default:
            imageView.image = #imageLiteral(resourceName: "invalid_placeholder")
        }
    }
    
    // MARK: User Interaction
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
