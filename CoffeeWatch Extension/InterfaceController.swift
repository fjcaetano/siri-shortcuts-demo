//
//  InterfaceController.swift
//  CoffeeWatch Extension
//
//  Created by Developer on 5/20/18.
//  Copyright © 2018 Work&Co. All rights reserved.
//

import WatchKit
import Foundation
import OrderDataWatch

class InterfaceController: WKInterfaceController {
    @IBOutlet weak var status: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func orderButtonPressed() {
        status.setText("Processing...")
        Menu.mintMojito.updateRelevantShortcut { [weak self] error in
            if let error = error {
                self?.status.setText(error.localizedDescription)
            } else {
                self?.status.setText("It worked!")
            }
        }
        Menu.mintMojito.donate()        
    }
}
