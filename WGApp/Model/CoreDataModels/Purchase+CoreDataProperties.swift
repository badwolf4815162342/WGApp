//
//  Purchase+CoreDataProperties.swift
//  WGApp
//
//  Created by Anna Abad on 13.07.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//
//

import Foundation
import CoreData


extension Purchase {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Purchase> {
        return NSFetchRequest<Purchase>(entityName: "Purchase")
    }

    @NSManaged public var sum: Int64
    @NSManaged public var date: NSDate?
    @NSManaged public var id: Int64
    @NSManaged public var items: NSSet?
    @NSManaged public var buyer: User?
    @NSManaged public var participants: NSSet?

}

// MARK: Generated accessors for items
extension Purchase {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: ListItem)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: ListItem)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

// MARK: Generated accessors for participants
extension Purchase {

    @objc(addParticipantsObject:)
    @NSManaged public func addToParticipants(_ value: User)

    @objc(removeParticipantsObject:)
    @NSManaged public func removeFromParticipants(_ value: User)

    @objc(addParticipants:)
    @NSManaged public func addToParticipants(_ values: NSSet)

    @objc(removeParticipants:)
    @NSManaged public func removeFromParticipants(_ values: NSSet)

}
