//
//  SimpleOrder+Image.swift
//  OrderData
//
//  Created by Developer on 5/20/18.
//  Copyright © 2018 Work&Co. All rights reserved.
//

import Foundation
import Intents

extension SimpleOrder {
    var intentImage: INImage {
        let data = UIImage(named: "MintNotification", in: Bundle(for: BundleDummyClass.self), compatibleWith: nil)?.pngData()
        let image = INImage(imageData: data!)
        return image
    }
}
