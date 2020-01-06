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
    case saveToPhotosMessage
    
    var key: String {
        switch self {
        case .title: return "Title"
        case .missingExplanation: return "Missing Explanation"
        case .today: return "Today"
        case .yesterday: return "Yesterday"
        case .copyright: return "Copyright"
        case .saveToPhotosMessage: return "Save to Photos"
        }
    }
}

enum DiscoverViewStrings: Localizable {
    case title
    case errorMessage
    
    var key: String {
        switch self {
        case .title: return "Title"
        case .errorMessage: return "Error Message"
        }
    }
}

enum FavoritesViewStrings: Localizable {
    case title
    case remove
    case errorMessage
    
    var key: String {
        switch self {
        case .title: return "Title"
        case .remove: return "Remove"
        case .errorMessage: return "Error Message"
        }
    }
}
