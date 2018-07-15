//
//  BusSetting+CoreDataProperties.swift
//  WGApp
//
//  Created by Anna Abad on 15.07.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//
//

import Foundation
import CoreData


extension BusSetting {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BusSetting> {
        return NSFetchRequest<BusSetting>(entityName: "BusSetting")
    }

    @NSManaged public var title: String?
    @NSManaged public var withDestinations: Bool
    @NSManaged public var favoriteOfProfiles: NSSet?
    @NSManaged public var ofProfil: Profil?
    @NSManaged public var routes: NSSet?

}

// MARK: Generated accessors for favoriteOfProfiles
extension BusSetting {

    @objc(addFavoriteOfProfilesObject:)
    @NSManaged public func addToFavoriteOfProfiles(_ value: Profil)

    @objc(removeFavoriteOfProfilesObject:)
    @NSManaged public func removeFromFavoriteOfProfiles(_ value: Profil)

    @objc(addFavoriteOfProfiles:)
    @NSManaged public func addToFavoriteOfProfiles(_ values: NSSet)

    @objc(removeFavoriteOfProfiles:)
    @NSManaged public func removeFromFavoriteOfProfiles(_ values: NSSet)

}

// MARK: Generated accessors for routes
extension BusSetting {

    @objc(addRoutesObject:)
    @NSManaged public func addToRoutes(_ value: BusRoute)

    @objc(removeRoutesObject:)
    @NSManaged public func removeFromRoutes(_ value: BusRoute)

    @objc(addRoutes:)
    @NSManaged public func addToRoutes(_ values: NSSet)

    @objc(removeRoutes:)
    @NSManaged public func removeFromRoutes(_ values: NSSet)

}
