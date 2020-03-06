//
//  Localizable.swift
//  Cosmos
//
//  Created by Samuel Yanez on 12/2/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import Foundation

protocol Localizable {
    var key: String { get }
    var localized: String { get }
}

extension Localizable {
    var resource: String {
        String(describing: type(of: self))
    }
    
    var localizableDictionary: NSDictionary! {
        if let path = Bundle.main.path(forResource: resource, ofType: "plist") {
            return NSDictionary(contentsOfFile: path)
        }
        fatalError("Localizable file missing.")
    }
    
    var localized: String {
        guard let localizedValue = localizableDictionary[key] as? NSDictionary else {
            return ""
        }
        guard let localizedString = localizedValue["value"] as? String else {
            return ""
        }
        return localizedString
    }
}

enum AboutViewStrings: Localizable {
    case title
    case aboutBodyQuote
    case aboutBody
    case acknowledgementsTitle
    case acknowledgementsBody
    case visitButton
    case version
    
    var key: String {
        switch self {
        case .title: return "Title"
        case .aboutBodyQuote: return "About Body Quote"
        case .aboutBody: return "About Body"
        case .acknowledgementsTitle: return "Acknowledgements Title"
        case .acknowledgementsBody: return "Acknowledgements Body"
        case .visitButton: return "Visit Button"
        case .version: return "Version"
        }
    }
}

enum DetailViewStrings: Localizable {
    case title
    case missingExplanation
    case today
    case yesterday
    case copyright
    case saveToPhotosSucceededMessage
    case saveToPhotosFailedMessage
    
    var key: String {
        switch self {
        case .title: return "Title"
        case .missingExplanation: return "Missing Explanation"
        case .today: return "Today"
        case .yesterday: return "Yesterday"
        case .copyright: return "Copyright"
        case .saveToPhotosSucceededMessage: return "Save to Photos Succeeded"
        case .saveToPhotosFailedMessage: return "Save to Photos Failed"
        }
    }
}

enum DiscoverViewStrings: Localizable {
    case title
    
    var key: String {
        switch self {
        case .title: return "Title"
        }
    }
}

enum FavoritesViewStrings: Localizable {
    case title
    case removeButton
    
    var key: String {
        switch self {
        case .title: return "Title"
        case .removeButton: return "Remove Button"
        }
    }
}

enum MessageViewStrings: Localizable {
    case errorMessage
    case emptyFavoritesMessage
    case refreshButton
    
    var key: String {
        switch self {
        case .errorMessage: return "Error Message"
        case .emptyFavoritesMessage: return "Empty Favorites Message"
        case .refreshButton: return "Refresh Button"
        }
    }
}

enum ShareStrings: Localizable {
    case imageShareMessage
    case videoShareMessage
    
    var key: String {
        switch self {
        case .imageShareMessage: return "Image Share Message"
        case .videoShareMessage: return "Video Share Message"
        }
    }
}
