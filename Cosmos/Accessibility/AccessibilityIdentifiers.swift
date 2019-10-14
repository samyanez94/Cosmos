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
        static let shareButton = "DetailShareButtonIdentifier"
    }
}

enum AboutViewAccessibilityIdentifier {
    enum Label {
        static let aboutTitleLabel = "AboutTitleLabelIdentifier"
        static let aboutBodyLabel = "AboutBodyLabelIdentifier"
        static let acknowledgementsTitleLabel = "AcknowledgementsTitleLabelIdentifier"
        static let acknowledgementsBodyLabel = "AcknowledgementsBodyLabelIdentifier"
    }
    enum Button {
        static let visitButton = "VisitButtonIdentifier"
    }
}
