//
//  MoreTableViewController.swift
//  Cosmos
//
//  Created by Samuel Yanez on 3/28/20.
//  Copyright © 2020 Samuel Yanez. All rights reserved.
//

import MessageUI
import UIKit

class MoreTableViewController: UITableViewController {
    
    @IBOutlet var aboutTableViewCell: UITableViewCell! {
        didSet {
            aboutTableViewCell.accessibilityIdentifier = MoreViewAccessibilityIdentifier.Cell.cell
            aboutTableViewCell.textLabel?.text = MoreViewStrings.aboutCell.localized
        }
    }
    
    @IBOutlet var recommendTableViewCell: UITableViewCell! {
        didSet {
            recommendTableViewCell.accessibilityIdentifier = MoreViewAccessibilityIdentifier.Cell.cell
            
            recommendTableViewCell.textLabel?.text = MoreViewStrings.recommendCell.localized
        }
    }
    
    @IBOutlet var reviewTableViewCell: UITableViewCell! {
        didSet {
            reviewTableViewCell.accessibilityIdentifier = MoreViewAccessibilityIdentifier.Cell.cell
            reviewTableViewCell.textLabel?.text = MoreViewStrings.reviewCell.localized
        }
    }
    
    @IBOutlet var feedbackTableViewCell: UITableViewCell! {
        didSet {
            feedbackTableViewCell.accessibilityIdentifier = MoreViewAccessibilityIdentifier.Cell.cell
            feedbackTableViewCell.textLabel?.text = MoreViewStrings.feedbackCell.localized
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = MoreViewStrings.title.localized
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1: didTapOnRecommend()
        case 2: didTapOnWriteReview()
        case 3: didTapOnSendFeedback()
        default: break
        }
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
    
    func didTapOnRecommend() {
        let message = String(format: ShareStrings.appShareMessage.localized, AppStoreEndpoint.share.url.absoluteString)
        let activityViewController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        present(activityViewController, animated: true)
    }
    
    func didTapOnWriteReview() {
        if UIApplication.shared.canOpenURL(AppStoreEndpoint.review.url) {
            UIApplication.shared.open(AppStoreEndpoint.review.url, options: [:], completionHandler: nil)
        }
    }
    
    func didTapOnSendFeedback() {
        if MFMailComposeViewController.canSendMail() {
            let versionNumber = Bundle.main.releaseVersionNumber ?? ""
            let buildNumber = Bundle.main.buildVersionNumber ?? ""
            let recipient = "samuelyanez94@gmail.com"
            let subject = "Cosmos: Discover Our Universe for iOS version \(versionNumber) (\(buildNumber)) feedback"
            let mail = MFMailComposeViewController()
            mail.setSubject(subject)
            mail.setToRecipients([recipient])
            mail.mailComposeDelegate = self
            present(mail, animated: true)
        }
    }
}

// MARK: MFMailComposeViewControllerDelegate

extension MoreTableViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
