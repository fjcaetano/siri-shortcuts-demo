//
//  IntentHandler.swift
//  CoffeeOrderIntents
//
//  Created by Developer on 5/19/18.
//  Copyright © 2018 Work&Co. All rights reserved.
//

import Intents
import OrderData

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        return OrderIntentHandler()
    }
    
}
