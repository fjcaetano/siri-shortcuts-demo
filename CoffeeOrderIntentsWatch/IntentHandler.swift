//
//  IntentHandler.swift
//  CoffeeOrderIntentsWatch
//
//  Created by Developer on 5/20/18.
//  Copyright © 2018 Work&Co. All rights reserved.
//

import Intents
import OrderDataWatch

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return OrderIntentHandler()
    }
    
}
