//
//  AccessibilityIdentifiers.swift
//  Cosmos
//
//  Created by Samuel Yanez on 10/8/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import Foundation

enum DetailViewAccessibilityIdentifier {
    enum Image {
        static let imageView = "DetailImageViewIdentifier"
    }
    enum WebView {
        static let webView = "DetailWebViewIdentifier"
    }
    enum Label {
        static let dateLabel = "DetailDateLabelIdentifier"
        static let titleLabel = "DetailTitleLabelIdentifier"
        static let explanationLabel = "DetailExplanationLabelIdentifier"
        static let copyrightLabel = "DetailCopyrightLabelIdentifier"
    }
    enum Button {
        static let favoritesButton = "FavoriteButtonIdentifier"
        static let shareButton = "DetailShareButtonIdentifier"
        static let saveToPhotosButton = "SaveToPhotosButtonIdentifier"
    }
}

enum AboutViewAccessibilityIdentifier {
    enum Label {
        static let aboutTitleLabel = "AboutTitleLabelIdentifier"
        static let aboutBodyQuoteLabel = "AboutBodyQuoteLabelIdentifier"
        static let aboutBodyLabel = "AboutBodyLabelIdentifier"
        static let acknowledgementsTitleLabel = "AcknowledgementsTitleLabelIdentifier"
        static let acknowledgementsBodyLabel = "AcknowledgementsBodyLabelIdentifier"
        static let versionLabel = "VersionLabelIdentifier"
    }
    enum Button {
        static let visitButton = "VisitButtonIdentifier"
    }
}
