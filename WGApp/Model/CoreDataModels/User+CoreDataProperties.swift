//
//  User+CoreDataProperties.swift
//  WGApp
//
//  Created by Anna Abad on 13.07.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var mail: String?
    @NSManaged public var participatesOnPutzSetting: NSSet?
    @NSManaged public var putzWeekItems: NSSet?
    @NSManaged public var purchase: NSSet?
    @NSManaged public var participantOfPurchase: NSSet?
    @NSManaged public var debts: NSSet?
    @NSManaged public var credits: NSSet?

}

// MARK: Generated accessors for participatesOnPutzSetting
extension User {

    @objc(addParticipatesOnPutzSettingObject:)
    @NSManaged public func addToParticipatesOnPutzSetting(_ value: PutzSetting)

    @objc(removeParticipatesOnPutzSettingObject:)
    @NSManaged public func removeFromParticipatesOnPutzSetting(_ value: PutzSetting)

    @objc(addParticipatesOnPutzSetting:)
    @NSManaged public func addToParticipatesOnPutzSetting(_ values: NSSet)

    @objc(removeParticipatesOnPutzSetting:)
    @NSManaged public func removeFromParticipatesOnPutzSetting(_ values: NSSet)

}

// MARK: Generated accessors for putzWeekItems
extension User {

    @objc(addPutzWeekItemsObject:)
    @NSManaged public func addToPutzWeekItems(_ value: PutzWeekItem)

    @objc(removePutzWeekItemsObject:)
    @NSManaged public func removeFromPutzWeekItems(_ value: PutzWeekItem)

    @objc(addPutzWeekItems:)
    @NSManaged public func addToPutzWeekItems(_ values: NSSet)

    @objc(removePutzWeekItems:)
    @NSManaged public func removeFromPutzWeekItems(_ values: NSSet)

}

// MARK: Generated accessors for purchase
extension User {

    @objc(addPurchaseObject:)
    @NSManaged public func addToPurchase(_ value: Purchase)

    @objc(removePurchaseObject:)
    @NSManaged public func removeFromPurchase(_ value: Purchase)

    @objc(addPurchase:)
    @NSManaged public func addToPurchase(_ values: NSSet)

    @objc(removePurchase:)
    @NSManaged public func removeFromPurchase(_ values: NSSet)

}

// MARK: Generated accessors for participantOfPurchase
extension User {

    @objc(addParticipantOfPurchaseObject:)
    @NSManaged public func addToParticipantOfPurchase(_ value: Purchase)

    @objc(removeParticipantOfPurchaseObject:)
    @NSManaged public func removeFromParticipantOfPurchase(_ value: Purchase)

    @objc(addParticipantOfPurchase:)
    @NSManaged public func addToParticipantOfPurchase(_ values: NSSet)

    @objc(removeParticipantOfPurchase:)
    @NSManaged public func removeFromParticipantOfPurchase(_ values: NSSet)

}

// MARK: Generated accessors for debts
extension User {

    @objc(addDebtsObject:)
    @NSManaged public func addToDebts(_ value: Debt)

    @objc(removeDebtsObject:)
    @NSManaged public func removeFromDebts(_ value: Debt)

    @objc(addDebts:)
    @NSManaged public func addToDebts(_ values: NSSet)

    @objc(removeDebts:)
    @NSManaged public func removeFromDebts(_ values: NSSet)

}

// MARK: Generated accessors for credits
extension User {

    @objc(addCreditsObject:)
    @NSManaged public func addToCredits(_ value: Debt)

    @objc(removeCreditsObject:)
    @NSManaged public func removeFromCredits(_ value: Debt)

    @objc(addCredits:)
    @NSManaged public func addToCredits(_ values: NSSet)

    @objc(removeCredits:)
    @NSManaged public func removeFromCredits(_ values: NSSet)

}
