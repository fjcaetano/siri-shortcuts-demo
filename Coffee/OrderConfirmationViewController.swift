//
//  OrderConfirmationViewController.swift
//  Demo
//
//  Created by Andre Carvalho on 5/19/18.
//  Copyright © 2018 Work&Co. All rights reserved.
//

import UIKit
import OrderData
import IntentsUI

class OrderConfirmationViewController: UIViewController {
    @IBOutlet weak var pickUpConfirmation: UILabel!
    @IBOutlet weak var addShortcut: UIButton!
    @IBOutlet weak var pickUp: UILabel!
    @IBOutlet weak var thanks: UILabel!
    
    private struct Constants {
        private static let baseFont = UIFont.systemFont(ofSize: 13, weight: .semibold)
        private static let paragraphStyle: NSParagraphStyle = {
            let style = NSMutableParagraphStyle()
            style.alignment = .center
            return style
        }()
        
        static let hotTipAttr: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .font: baseFont,
            .foregroundColor: #colorLiteral(red: 1, green: 0.7138298154, blue: 0.2057937682, alpha: 1),
            ]
        
        static let textAttr: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .font: baseFont,
            .foregroundColor: UIColor.white
        ]
        
        static let linkAttr: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .font: baseFont,
            .foregroundColor: UIColor.white,
            .underlineStyle: NSUnderlineStyle.styleSingle.rawValue
        ]
    }
    
    private var currentShortcut: INVoiceShortcut? {
        didSet {
            addShortcut.setAttributedTitle(shourtcutText, for: .normal)
        }
    }
    
    private var hotTip: String {
        return currentShortcut == nil ? "HOT TIP: " : "SAY: "
    }
    
    private var linkText: String {
        guard let shortcut = currentShortcut else {
            return "Add to Siri for easy re-ordering"
        }
        return "\"Hey Siri, \(shortcut.invocationPhrase.lowercased())\""
    }
    
    private var shourtcutText: NSAttributedString {
        let res = NSMutableAttributedString(string: hotTip, attributes: Constants.hotTipAttr)
        res.append(NSAttributedString(string: linkText, attributes: Constants.linkAttr))
        return res
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickUpConfirmation.attributedText = PickupString
            .seeYouConfirmation(pickUpTime: PickUpTimeString.selected)
        pickUp.text = PickupString
            .selectableFrom(pickUpTime: PickUpTimeString.selected)
            .string
        thanks.attributedText = NSAttributedString(
            string: "Thanks \(GlobalConfiguration.userName)!",
            attributes: GlobalConstants.thanksAttributes)
        
        addShortcut.titleLabel?.numberOfLines = 0
        addShortcut.setAttributedTitle(shourtcutText, for: .normal)
        donateOrder()
    }

    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func createSomething(_ sender: Any) {
        if let shortcut = currentShortcut {
            let shortcutVC = INUIEditVoiceShortcutViewController(voiceShortcut: shortcut)
            shortcutVC.delegate = self
            present(shortcutVC, animated: true)
        } else {
            let intent = Menu.mintMojito.intent
            let shortcut = INShortcut(intent: intent)!
            let shortcutVC = INUIAddVoiceShortcutViewController(shortcut: shortcut)
            shortcutVC.delegate = self
            present(shortcutVC, animated: true)
        }
    }
    
    private func donateOrder() {
        let order = Menu.mintMojito
        order.donate()
    }
}

extension OrderConfirmationViewController: INUIAddVoiceShortcutViewControllerDelegate  {
    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        if let shortcut = voiceShortcut {
            currentShortcut = shortcut
        }
    }
    
    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension OrderConfirmationViewController: INUIEditVoiceShortcutViewControllerDelegate {
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didUpdate voiceShortcut: INVoiceShortcut?, error: Error?) {
        if let shortcut = voiceShortcut {
            currentShortcut = shortcut
        }
        controller.dismiss(animated: true)
    }
    
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didDeleteVoiceShortcutWithIdentifier deletedVoiceShortcutIdentifier: UUID) {
        currentShortcut = nil
        controller.dismiss(animated: true)
    }
    
    func editVoiceShortcutViewControllerDidCancel(_ controller: INUIEditVoiceShortcutViewController) {
        controller.dismiss(animated: true)
    }
}
