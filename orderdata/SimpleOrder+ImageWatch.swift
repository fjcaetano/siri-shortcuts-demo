//
//  SimpleOrder+ImageWatch.swift
//  OrderDataWatch
//
//  Created by Developer on 5/20/18.
//  Copyright © 2018 Work&Co. All rights reserved.
//

import Foundation
import Intents

extension SimpleOrder {
    var intentImage: INImage {
//        let uiImage = UIImage(named: "Mint42mm")
        let uiImage = is42mm ? UIImage(named: "Mint62p") : UIImage(named: "Mint54p")
        let data = uiImage?.pngData()
        let image = data.map(INImage.init(imageData:))
        if image == nil {
            print("Image MintNotification not found...")
        }
        return image!
    }
    
    var is42mm: Bool {
        let device = WKInterfaceDevice.current()
        let bounds = device.screenBounds
        return bounds.size == CGSize(width: 156, height: 195)
    }
}
