//
//  PutzSetting+CoreDataProperties.swift
//  WGApp
//
//  Created by Viviane Rehor on 08.07.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//
//

import Foundation
import CoreData


extension PutzSetting {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PutzSetting> {
        return NSFetchRequest<PutzSetting>(entityName: "PutzSetting")
    }

    @NSManaged public var aktiv: Bool
    @NSManaged public var profilIcon: String?
    @NSManaged public var repeatEveryXWeeks: Int64
    @NSManaged public var title: String?
    @NSManaged public var participatingUsers: NSSet?
    @NSManaged public var weekItems: NSSet?

}

// MARK: Generated accessors for participatingUsers
extension PutzSetting {

    @objc(addParticipatingUsersObject:)
    @NSManaged public func addToParticipatingUsers(_ value: User)

    @objc(removeParticipatingUsersObject:)
    @NSManaged public func removeFromParticipatingUsers(_ value: User)

    @objc(addParticipatingUsers:)
    @NSManaged public func addToParticipatingUsers(_ values: NSSet)

    @objc(removeParticipatingUsers:)
    @NSManaged public func removeFromParticipatingUsers(_ values: NSSet)

}

// MARK: Generated accessors for weekItems
extension PutzSetting {

    @objc(addWeekItemsObject:)
    @NSManaged public func addToWeekItems(_ value: PutzWeekItem)

    @objc(removeWeekItemsObject:)
    @NSManaged public func removeFromWeekItems(_ value: PutzWeekItem)

    @objc(addWeekItems:)
    @NSManaged public func addToWeekItems(_ values: NSSet)

    @objc(removeWeekItems:)
    @NSManaged public func removeFromWeekItems(_ values: NSSet)

}
