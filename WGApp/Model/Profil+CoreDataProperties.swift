//
//  Profil+CoreDataProperties.swift
//  WGApp
//
//  Created by Anna Abad on 11.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//
//

import Foundation
import CoreData


extension Profil {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Profil> {
        return NSFetchRequest<Profil>(entityName: "Profil")
    }

    @NSManaged public var profilIcon: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var busSettings: NSSet?

}

// MARK: Generated accessors for busSettings
extension Profil {

    @objc(addBusSettingsObject:)
    @NSManaged public func addToBusSettings(_ value: BusSettings)

    @objc(removeBusSettingsObject:)
    @NSManaged public func removeFromBusSettings(_ value: BusSettings)

    @objc(addBusSettings:)
    @NSManaged public func addToBusSettings(_ values: NSSet)

    @objc(removeBusSettings:)
    @NSManaged public func removeFromBusSettings(_ values: NSSet)

}
