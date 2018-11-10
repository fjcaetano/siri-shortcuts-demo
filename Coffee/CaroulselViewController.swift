//
//  ViewController.swift
//  Work&Co
//
//  Created by Andre Carvalho on 5/19/18.
//  Copyright © 2018 Work&Co. All rights reserved.
//

import UIKit
import OrderData

class CaroulselViewController: UIViewController {
    @IBOutlet weak var pickUpTime: UILabel!
    @IBOutlet weak var orderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickUpTime.attributedText = PickupString.selectableFrom(pickUpTime: PickUpTimeString.selected)
        orderLabel.attributedText = NSAttributedString(string: "I'LL TAKE IT!", attributes: GlobalConstants.ctaAttributes)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    @IBAction func configureDemo(_ sender: Any) {
        let alert = UIAlertController(
            title: "Configure",
            message: """
                     Configurations for demo:
                     - First name
                     - Suggested shortcut phrase
                     - Siri suggestion title
                     """,
            preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = GlobalConfiguration.userName
        }
        alert.addTextField { textField in
            textField.text = GlobalConfiguration.suggestedPhrase
        }
        alert.addTextField { textField in
            textField.text = GlobalConfiguration.shortcutTitle
        }
        
        let confirm = UIAlertAction(title: "OK", style: .default) { _ in
            var textFields = alert.textFields.map(ArraySlice.init)
            guard let username = textFields?.first?.text,
                !username.isEmpty else {
                    assertionFailure("Sorry, username not set")
                    return
            }
            GlobalConfiguration.userName = username
            
            textFields = textFields?.dropFirst()
            guard let suggestedPhrase = textFields?.first?.text,
                !suggestedPhrase.isEmpty else {
                    assertionFailure("Sorry, suggestedPhrase not set")
                    return
            }
            GlobalConfiguration.suggestedPhrase = suggestedPhrase

            textFields = textFields?.dropFirst()
            guard let shortcutTitle = textFields?.first?.text,
                !suggestedPhrase.isEmpty else {
                    assertionFailure("Sorry, shortcut title not set")
                    return
            }
            GlobalConfiguration.shortcutTitle = shortcutTitle
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(confirm)
        alert.addAction(cancel)
        show(alert, sender: sender)
    }
    
}
