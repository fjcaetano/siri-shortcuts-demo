//
//  OrderCheckoutViewController.swift
//  Demo
//
//  Created by Andre Carvalho on 5/19/18.
//  Copyright © 2018 Work&Co. All rights reserved.
//

import UIKit
import OrderData

class CartViewController: UIViewController {
    @IBOutlet weak var pickUp: UILabel!
    @IBOutlet weak var orderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickUp.attributedText = PickupString.selectableFrom(pickUpTime: PickUpTimeString.selected)
        orderLabel.attributedText = NSAttributedString(string: "ORDER & PAY", attributes: GlobalConstants.ctaAttributes)
    }

    @IBAction func favoritesSelected(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
}
