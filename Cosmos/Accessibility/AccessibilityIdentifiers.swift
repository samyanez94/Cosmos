//
//  AccessibilityIdentifiers.swift
//  Cosmos
//
//  Created by Samuel Yanez on 10/8/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import Foundation

// MARK: - About View Accessibility Identifiers

enum AboutViewAccessibilityIdentifier {
    enum Image {
        static let imageView = "AboutImageViewIdentifier"
    }
    enum Label {
        static let aboutTitleLabel = "AboutTitleLabelIdentifier"
        static let aboutQuoteLabel = "AboutBodyQuoteLabelIdentifier"
        static let aboutBodyLabel = "AboutBodyLabelIdentifier"
        static let acknowledgementsTitleLabel = "AcknowledgementsTitleLabelIdentifier"
        static let versionLabel = "VersionLabelIdentifier"
    }
    enum TextView {
        static let acknowledgementsBodyLabel = "AcknowledgementsBodyTextViewIdentifier"
    }
}

// MARK: - Detail View Accessibility Identifiers

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

// MARK: - Discover View Accessibility Identifiers

enum DiscoverCellAccessibilityIdentifier {
    enum Image {
        static let imageView = "DiscoverImageViewIdentifier"
    }
    enum Label {
        static let dateLabel = "DiscoverDateLabelIdentifier"
        static let titleLabel = "DiscoverTitleLabelIdentifier"
    }
}

// MARK: - Favorites View Accessibility Identifiers

enum FavoritesCellAccessibilityIdentifier {
    enum Image {
        static let thumbnailImageView = "FavoritesThumbnailImageViewIdentifier"
    }
    enum Label {
        static let dateLabel = "FavoritesDateLabelIdentifier"
        static let titleLabel = "FavoritesTitleLabelIdentifier"
        static let explanationLabel = "FavoritesExplanationLabelIdentifier"
    }
}

// MARK: - Message View Accessibility Identifiers

enum MessageViewAccessibilityIdentifier {
    enum Image {
        static let imageView = "MessageImageViewIdentifier"
    }
    enum Label {
        static let label = "MessageLabelIdentifier"
    }
    enum Button {
        static let refreshButton = "MessageRefreshButtonIdentifier"
    }
}

// MARK: - More View Accessibility Identifiers

enum MoreViewAccessibilityIdentifier {
    enum Cell {
        static let cell = "MoreTableViewCellIdentifier"
    }
}
