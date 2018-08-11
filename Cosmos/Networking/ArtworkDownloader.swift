//
//  ArtworkDownloader.swift
//  Cosmos
//
//  Created by Samuel Yanez on 8/7/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import Foundation
import UIKit

class PendingOperations {
    var downloadsInProgress = [IndexPath: Operation]()
    
    let downloadQueue = OperationQueue()
}

class ArtworkDownloader: Operation {
    let apod: APOD
    
    init(apod: APOD) {
        self.apod = apod
        super.init()
    }
    
    override func main() {
        if self.isCancelled {
            return
        }
        
        guard let url = URL(string: apod.url) else {
            return
        }
        do {
            let imageData = try Data(contentsOf: url)
            
            if self.isCancelled {
                return
            }
            
            if imageData.count > 0 {
                apod.image = UIImage(data: imageData)
                apod.imageState = .downloaded
            } else {
                apod.imageState = .failed
            }
        } catch {
            print("Unexpected error: \(error).")
            self.cancel()
            return
        }
    }
}
