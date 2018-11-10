//
//  OrderIntentHandler.swift
//  OrderData
//
//  Created by Developer on 5/19/18.
//  Copyright © 2018 Work&Co. All rights reserved.
//

import Foundation
import os.log

//#if os(iOS)

public class OrderIntentHandler: NSObject, CoffeeOrderIntentHandling {
    public func handle(intent: CoffeeOrderIntent, completion: @escaping (CoffeeOrderIntentResponse) -> Void) {
        os_log("Handle intent %@", log: .default, type: .default, intent.myDebugDesc)
        let minutes = NSNumber(value: PickUpTimeString.getNextAvailabilityMinutes(for: Date()))
        let response = CoffeeOrderIntentResponse
            .success(firstName: GlobalConfiguration.userName,
                     storeLocation: "Cupertino",
                     time: minutes)
        completion(response)
    }
    
    public func confirm(intent: CoffeeOrderIntent, completion: @escaping (CoffeeOrderIntentResponse) -> Void) {
        os_log("Confirm intent %@", log: .default, type: .default, intent.myDebugDesc)
        let response = CoffeeOrderIntentResponse(code: .ready, userActivity: nil)
        completion(response)
    }
}

extension CoffeeOrderIntent {
    var myDebugDesc: String {
        return "Coffee: \(String(describing: beverage?.displayString)), options: \(String(describing: beverageOptions?.displayString)), location: \(String(describing: storeLocation))"
    }
}
