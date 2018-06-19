//
//  BusSettings+CoreDataProperties.swift
//  WGApp
//
//  Created by Viviane Rehor on 19.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//
//

import Foundation
import CoreData


extension BusSettings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BusSettings> {
        return NSFetchRequest<BusSettings>(entityName: "BusSettings")
    }

    @NSManaged public var title: String?
    @NSManaged public var ofProfil: Profil?
    @NSManaged public var routes: NSSet?

}

// MARK: Generated accessors for routes
extension BusSettings {

    @objc(addRoutesObject:)
    @NSManaged public func addToRoutes(_ value: BusRoute)

    @objc(removeRoutesObject:)
    @NSManaged public func removeFromRoutes(_ value: BusRoute)

    @objc(addRoutes:)
    @NSManaged public func addToRoutes(_ values: NSSet)

    @objc(removeRoutes:)
    @NSManaged public func removeFromRoutes(_ values: NSSet)

}
