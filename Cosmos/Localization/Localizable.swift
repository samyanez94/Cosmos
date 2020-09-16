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
    private var resource: String {
        String(describing: type(of: self))
    }
    
    private var localizableDictionary: NSDictionary! {
        if let path = Bundle.main.path(forResource: resource, ofType: "plist") {
            return NSDictionary(contentsOfFile: path)
        }
        fatalError("Localizable file missing")
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

// MARK: About View

enum AboutViewStrings: Localizable {
    case title
    case aboutQuote
    case aboutBody
    case acknowledgementsTitle
    case acknowledgementsBody
    case acknowledgementsBodyAttributedText1
    case acknowledgementsBodyAttributedText2
    case version
    
    var key: String {
        switch self {
        case .title: return "Title"
        case .aboutQuote: return "About Quote"
        case .aboutBody: return "About Body"
        case .acknowledgementsTitle: return "Acknowledgements Title"
        case .acknowledgementsBody: return "Acknowledgements Body"
        case .acknowledgementsBodyAttributedText1: return "Acknowledgements Body Attributed Text 1"
        case .acknowledgementsBodyAttributedText2: return "Acknowledgements Body Attributed Text 2"
        case .version: return "Version"
        }
    }
}

// MARK: Detail View

enum DetailViewStrings: Localizable {
    case title
    case missingExplanation
    case today
    case yesterday
    case copyright
    case saveToPhotosSucceededMessage
    case saveToPhotosFailedMessage
    case deniedAccessToPhotosTitle
    case deniedAccessToPhotosMessage
    case settingsAction
    case cancelAction
    
    var key: String {
        switch self {
        case .title: return "Title"
        case .missingExplanation: return "Missing Explanation"
        case .today: return "Today"
        case .yesterday: return "Yesterday"
        case .copyright: return "Copyright"
        case .saveToPhotosSucceededMessage: return "Save to Photos Succeeded"
        case .saveToPhotosFailedMessage: return "Save to Photos Failed"
        case .deniedAccessToPhotosTitle: return "Denied Access to Photos Title"
        case .deniedAccessToPhotosMessage: return "Denied Access to Photos Message"
        case .settingsAction: return "Settings Action"
        case .cancelAction: return "Cancel Action"
        }
    }
}

// MARK: Discover View

enum DiscoverViewStrings: Localizable {
    case title
    
    var key: String {
        switch self {
        case .title: return "Title"
        }
    }
}

// MARK: Favorites View

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

// MARK: Message View

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

// MARK: More View

enum MoreViewStrings: Localizable {
    case title
    case aboutCell
    case recommendCell
    case reviewCell
    case feedbackCell
    
    var key: String {
        switch self {
        case .title: return "Title"
        case .aboutCell: return "About Cell"
        case .recommendCell: return "Recommend Cell"
        case .reviewCell: return "Review Cell"
        case .feedbackCell: return "Feedback Cell"
        }
    }
}

// MARK: Share

enum ShareStrings: Localizable {
    case imageShareMessage
    case videoShareMessage
    case appShareMessage
    
    var key: String {
        switch self {
        case .imageShareMessage: return "Image Share Message"
        case .videoShareMessage: return "Video Share Message"
        case .appShareMessage: return "App Share Message"
        }
    }
}
