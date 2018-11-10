//
//  SiriData.swift
//  Coffee
//
//  Created by Developer on 5/19/18.
//  Copyright © 2018 Work&Co. All rights reserved.
//

import Foundation
import Intents

public struct SimpleOrder: Codable {
    public let identifier: UUID
    public let date: Date
    public let beverage: Beverage
    public let options: BeverageOptions
    public let price: String = "$5.50"
    
    public init(date: Date = Date(), identifier: UUID = UUID(), beverage: Beverage, options: BeverageOptions) {
        self.identifier = identifier
        self.date = date
        self.beverage = beverage
        self.options = options
    }
}

public struct Beverage: Codable {
    public let name: String
    public let shortcutTitle: String
    public let pronunciationHint: String?
}

public struct BeverageOptions: Codable {
    public enum Size: String, Codable {
        case large, small
    }
    
    public let identifier = UUID()
    public let size: Size
    public let cream: CreamOption
    public let sugar: SweetOption
    
    var description: String {
        return "\(size), \(cream.description), \(sugar.description)"
    }
}

protocol BeverageOption {
    var quantity: String { get }
    var option: String? { get }
}

extension BeverageOption {
    var description: String {
        if let option = option {
            return "\(quantity) \(option)"
        } else {
            return quantity
        }
    }
}

public struct CreamOption: BeverageOption, Codable {
    public let quantity: String
    public let option: String?
}

public struct SweetOption: BeverageOption, Codable {
    public let quantity: String
    public let option: String?
}

public struct Menu {
    public static let mintMojito = SimpleOrder(
        beverage: Beverage(
            name: "Mint Mojito",
            shortcutTitle: GlobalConfiguration.shortcutTitle,
            pronunciationHint: nil),
        options: BeverageOptions(
            size: .large,
            cream: CreamOption(quantity: "medium", option: "cream"),
            sugar: SweetOption(quantity: "medium", option: "sugar")))
}

// MARK: - Intent extersions

extension SimpleOrder {
    public var intent: CoffeeOrderIntent {
        let orderIntent = CoffeeOrderIntent()
        orderIntent.beverage = beverage.intentObject
        orderIntent.storeLocation = "Cupertino"
        orderIntent.setImage(intentImage, forParameterNamed: \CoffeeOrderIntent.beverage)
        orderIntent.beverageOptions = options.intentObject
        orderIntent.suggestedInvocationPhrase = GlobalConfiguration.suggestedPhrase
        return orderIntent
    }
    
    public func donate(completion: ((Error?) -> Void)? = nil) {
        let interaction = INInteraction(intent: intent, response: nil)
        interaction.donate { (error) in
            if let error = error {
                completion?(error)
                print("Did Fail: \(error.localizedDescription)")
            } else {
                completion?(nil)
                print("Did Succeed")
            }
        }
    }
    
    public func updateRelevantShortcut(completion: ((Error?) -> Void)? = nil) {
        let shortcut = INShortcut(intent: intent)!
        let suggestedShortcut = INRelevantShortcut(shortcut: shortcut)
        
        let template = INDefaultCardTemplate(title: beverage.shortcutTitle)

        template.image = intentImage
        suggestedShortcut.watchTemplate = template
        
        INRelevantShortcutStore.default.setRelevantShortcuts([suggestedShortcut]) { (error) in
            if let error = error {
                completion?(error)
                print("Relevant Did Fail: \(error.localizedDescription)")
            } else {
                completion?(nil)
                print("Relevant Did Succeed")
            }
        }
    }
}

extension Beverage {
    public var intentObject: INObject {
        return INObject(identifier: name, display: shortcutTitle, pronunciationHint: pronunciationHint)
    }
}

extension BeverageOptions {
    public var intentObject: INObject {
        return INObject(identifier: identifier.description, display: description)
    }
}

public class GlobalConfiguration {
    private static let userDefaults = UserDefaults(suiteName: "group.com.demo.app")
    private static let userNameKey = "--my-user-name"
    private static let suggestedPhraseKey = "--my-suggested-phrase"
    private static let shortcutTitleKey = "--my-shortcut-title"
    public static var userName: String {
        get {
            assert(userDefaults != nil)
            return userDefaults?.string(forKey: userNameKey) ?? "Flávio"
        }
        set {
            assert(userDefaults != nil)
            userDefaults?.set(newValue, forKey: userNameKey)
        }
    }
    
    public static var shortcutTitle: String {
        get {
            assert(userDefaults != nil)
            return userDefaults?.string(forKey: shortcutTitleKey) ?? "Pedir o de sempre"
        }
        set {
            assert(userDefaults != nil)
            userDefaults?.set(newValue, forKey: shortcutTitleKey)
        }
    }

    public static var suggestedPhrase: String {
        get {
            assert(userDefaults != nil)
            return userDefaults?.string(forKey: suggestedPhraseKey) ?? "Coffee time!"
        }
        set {
            assert(userDefaults != nil)
            userDefaults?.set(newValue, forKey: suggestedPhraseKey)
        }
    }
}

public struct GlobalConstants {
    public static let ctaAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont(name: "GothamRounded-Bold", size: 14)!,
        .foregroundColor: UIColor.white,
        .kern: 1.7
    ]
    
    public static let thanksAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont(name: "GothamRounded-Bold", size: 36)!,
        .foregroundColor: UIColor.white,
        .kern: -2.1
    ]

    public static let thanksLongLookAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont(name: "GothamRounded-Bold", size: 37)!,
        .foregroundColor: UIColor.white,
        .kern: -2.1
    ]
}

class BundleDummyClass {}
