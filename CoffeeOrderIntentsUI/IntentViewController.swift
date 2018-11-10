//
//  IntentViewController.swift
//  CoffeeOrderIntentsUI
//
//  Created by Developer on 5/19/18.
//  Copyright © 2018 Work&Co. All rights reserved.
//

import IntentsUI
import OrderData
import os.log

class IntentViewController: UIViewController, INUIHostedViewControlling {
    @IBOutlet weak var pickUp: UILabel!
    @IBOutlet weak var confirmationPickUp: UILabel!
    @IBOutlet weak var thanks: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var receiptBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var thanksContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pickUp.attributedText = PickupString.selectableFrom(pickUpTime: PickUpTimeString.selected)
        let minutes = PickUpTimeString.getNextAvailabilityMinutes(for: Date())
        confirmationPickUp.attributedText = PickupString.seeYouRelativeConfirmation(pickUpMinutes: minutes)
        thanks.attributedText = NSAttributedString(
            string: "Thanks \(GlobalConfiguration.userName)!",
            attributes: GlobalConstants.thanksLongLookAttributes)
    }

    // MARK: - INUIHostedViewControlling
    
    // Prepare your view controller for the interaction to handle.
    func configureView(for parameters: Set<INParameter>,
                       of interaction: INInteraction,
                       interactiveBehavior: INUIInteractiveBehavior,
                       context: INUIHostedViewContext,
                       completion: @escaping (Bool, Set<INParameter>, CGSize) -> Void) {

        os_log("Aqui 2", interactiveBehavior.rawValue);

        switch interaction.intentHandlingStatus {
        case .success:
            animateSuccess()
        default:
            os_log("IntentsUI configureView called with unknown status")
        }

        let width = extensionContext?.hostedViewMaximumAllowedSize.width ?? 359
        completion(true, parameters, CGSize(width: width, height: 414))
    }
    
    struct Constants {
        static let animationDuration: TimeInterval = 0.25
        static let thanksDelay: TimeInterval = 0.10
    }
    
    private func animateSuccess() {
        topConstraint.constant = -304
        receiptBottomConstraint.constant = 0
        UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
            self?.view.layoutIfNeeded()
            self?.view.backgroundColor = #colorLiteral(red: 0.4235294118, green: 0.2980392157, blue: 0.2980392157, alpha: 1)
        }
        UIView.animate(
            withDuration: Constants.animationDuration,
            delay: Constants.thanksDelay,
            options: [],
            animations: { [weak self] in
                self?.thanksContainer.alpha = 1
        }, completion: nil)
    }
}
