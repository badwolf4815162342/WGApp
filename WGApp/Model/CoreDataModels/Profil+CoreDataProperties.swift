//
//  Profil+CoreDataProperties.swift
//  WGApp
//
//  Created by Anna Abad on 13.07.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//
//

import Foundation
import CoreData


extension Profil {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Profil> {
        return NSFetchRequest<Profil>(entityName: "Profil")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var profilIcon: String?
    @NSManaged public var busSettings: NSSet?
    @NSManaged public var favoriteBusSettings: NSSet?

}

// MARK: Generated accessors for busSettings
extension Profil {

    @objc(addBusSettingsObject:)
    @NSManaged public func addToBusSettings(_ value: BusSetting)

    @objc(removeBusSettingsObject:)
    @NSManaged public func removeFromBusSettings(_ value: BusSetting)

    @objc(addBusSettings:)
    @NSManaged public func addToBusSettings(_ values: NSSet)

    @objc(removeBusSettings:)
    @NSManaged public func removeFromBusSettings(_ values: NSSet)

}

// MARK: Generated accessors for favoriteBusSettings
extension Profil {

    @objc(addFavoriteBusSettingsObject:)
    @NSManaged public func addToFavoriteBusSettings(_ value: BusSetting)

    @objc(removeFavoriteBusSettingsObject:)
    @NSManaged public func removeFromFavoriteBusSettings(_ value: BusSetting)

    @objc(addFavoriteBusSettings:)
    @NSManaged public func addToFavoriteBusSettings(_ values: NSSet)

    @objc(removeFavoriteBusSettings:)
    @NSManaged public func removeFromFavoriteBusSettings(_ values: NSSet)

}
