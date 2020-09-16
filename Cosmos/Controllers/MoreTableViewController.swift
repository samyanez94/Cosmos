//
//  MoreTableViewController.swift
//  Cosmos
//
//  Created by Samuel Yanez on 3/28/20.
//  Copyright © 2020 Samuel Yanez. All rights reserved.
//

import MessageUI
import UIKit

final class MoreTableViewController: UITableViewController {
    
    /// Table view items
    private lazy var items = [
        MoreItem(
            text: MoreViewStrings.aboutCell.localized,
            imageSystemName: "info.circle",
            accessoryType: .disclosureIndicator,
            tapHandler: { [unowned self] in
                self.aboutTapHandler()
            }
        ),
        MoreItem(
            text: MoreViewStrings.recommendCell.localized,
            imageSystemName: "square.and.arrow.up",
            tapHandler: { [unowned self] in
                self.recommendTapHandler()
            }
        ),
        MoreItem(
            text: MoreViewStrings.reviewCell.localized,
            imageSystemName: "text.bubble",
            tapHandler: { [unowned self] in
                self.reviewTapHandler()
            }
        ),
        MoreItem(
            text: MoreViewStrings.feedbackCell.localized,
            imageSystemName: "envelope",
            tapHandler: { [unowned self] in
                self.sendFeedbackTapHandler()
            }
        )
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set title
        title = MoreViewStrings.title.localized
        
        // Register table view cell
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "DefaultCell"
        )
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell") else {
            fatalError("Unable to deque cell with identifier")
        }
        updateCell(cell, with: items[indexPath.row])
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        items[indexPath.row].tapHandler?()
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    // MARK: - Helpers
    
    private func updateCell(_ cell: UITableViewCell, with item: MoreItem) {
        cell.textLabel?.text = item.text
        cell.textLabel?.font = DynamicFont.shared.font(forTextStyle: .body)
        cell.textLabel?.adjustsFontForContentSizeCategory = true
        cell.imageView?.image = UIImage(systemName: item.imageSystemName)
        cell.imageView?.tintColor = UIColor(named: "Accent Color")
        cell.accessoryType = item.accessoryType
        cell.accessibilityIdentifier = item.accessibilityIdentifier
    }
    
    // MARK: - Tap Handlers
    
    private func aboutTapHandler() {
        if let aboutViewController = storyboard?.instantiateViewController(identifier: AboutViewController.identifier, creator: { coder in
            AboutViewController(coder: coder)
        }) {
            show(aboutViewController, sender: nil)
        }
    }
    
    private func recommendTapHandler() {
        let message = String(
            format: ShareStrings.appShareMessage.localized,
            AppStoreEndpoint.share.url.absoluteString
        )
        let activityViewController = UIActivityViewController(
            activityItems: [message],
            applicationActivities: nil
        )
        present(
            activityViewController,
            animated: true
        )
    }
    
    private func reviewTapHandler() {
        if UIApplication.shared.canOpenURL(AppStoreEndpoint.review.url) {
            UIApplication.shared.open(
                AppStoreEndpoint.review.url,
                options: [:],
                completionHandler: nil
            )
        }
    }
    
    private func sendFeedbackTapHandler() {
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

extension MoreTableViewController {
    
    /// Helper struct to model the table view items
    private struct MoreItem {
        let text: String
        let imageSystemName: String
        let accessoryType: UITableViewCell.AccessoryType
        let tapHandler: (() -> Void)?
        let accessibilityIdentifier: String = MoreViewAccessibilityIdentifier.Cell.cell
        
        fileprivate init(text: String,
                         imageSystemName: String,
                         accessoryType: UITableViewCell.AccessoryType = .none,
                         tapHandler: (() -> Void)?) {
            self.text = text
            self.imageSystemName = imageSystemName
            self.accessoryType = accessoryType
            self.tapHandler = tapHandler
        }
    }
}

// MARK: MFMailComposeViewControllerDelegate

extension MoreTableViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        controller.dismiss(animated: true)
    }
}
