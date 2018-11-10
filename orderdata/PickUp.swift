//
//  PickUpTime.swift
//  Work&Co
//
//  Created by Andre Carvalho on 5/19/18.
//  Copyright © 2018 Work&Co. All rights reserved.
//

import Foundation

class TimeFormatter {
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.setLocalizedDateFormatFromTemplate("h:mma")
        return formatter
    }()

    static func string(from date: Date) -> String {
        return formatter.string(from: date)
            .replacingOccurrences(of: " ", with: "")
            .localizedLowercase
    }

}

public class PickUpTimeString {
    public static func getNextAvailabilityMinutes(for date: Date) -> Int {
        let components = Calendar.current.dateComponents([.minute], from: date)
        return 6 - ((components.minute! + 1) % 5) + 5
    }
    
    public static func getNextAvailable() -> String {
        let date = Date()
        let advanceSeconds = getNextAvailabilityMinutes(for: date) * 60
        let pickupInterval = TimeInterval(exactly: advanceSeconds)!
        let pickupDate = Date(timeInterval: pickupInterval, since: date)
        return TimeFormatter.string(from: pickupDate)
    }

    public static var selected = PickUpTimeString.getNextAvailable()
}

public class PickupString {
    private static let location = "Cupertino"

    static func attributed(prefix: String, separator: String, pickUpTime: String, base: [NSAttributedString.Key: Any], values: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let result = NSMutableAttributedString(string: prefix, attributes: base)
        result.append(NSAttributedString(string: PickupString.location, attributes: values))
        result.append(NSAttributedString(string: separator, attributes: base))
        result.append(NSAttributedString(string: pickUpTime, attributes: values))
        return NSAttributedString(attributedString: result)
    }

    public static func selectableFrom(pickUpTime: String) -> NSAttributedString {
        let underlined: [NSAttributedString.Key: Any] = [
            .font : UIFont.boldSystemFont(ofSize: 13),
            .foregroundColor : #colorLiteral(red: 0.2705882353, green: 0.1411764706, blue: 0.02352941176, alpha: 1),
            .underlineStyle : NSUnderlineStyle.single.rawValue,
        ]
        let base = underlined.filter { (key, _) -> Bool in
            key != .underlineStyle
        }
        return attributed(prefix: "Pick-up at ", separator: " - ", pickUpTime: pickUpTime, base: base, values: underlined)
    }

    public static func seeYouConfirmation(pickUpTime: String) -> NSAttributedString {
        let bold: [NSAttributedString.Key: Any] = [
            .font : UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor : UIColor.white
            ]
        let base: [NSAttributedString.Key: Any] = [
            .font : UIFont.systemFont(ofSize: 12),
            .foregroundColor : UIColor.white,
        ]
        return attributed(prefix: "See you at ", separator: " at ",pickUpTime: pickUpTime, base: base, values: bold)
    }
    
    public static func seeYouRelativeConfirmation(pickUpMinutes: Int) -> NSAttributedString {
        let bold: [NSAttributedString.Key: Any] = [
            .font : UIFont.boldSystemFont(ofSize: 13),
            .foregroundColor : UIColor.white
        ]
        let base: [NSAttributedString.Key: Any] = [
            .font : UIFont.systemFont(ofSize: 13),
            .foregroundColor : UIColor.white,
            ]
        return attributed(prefix: "See you at ", separator: " in ",pickUpTime: "\(pickUpMinutes) mins", base: base, values: bold)
    }
}
