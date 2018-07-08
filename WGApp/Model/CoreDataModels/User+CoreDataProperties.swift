//
//  User+CoreDataProperties.swift
//  WGApp
//
//  Created by Viviane Rehor on 08.07.18.
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
