//
//  BusRoute+CoreDataProperties.swift
//  WGApp
//
//  Created by Viviane Rehor on 10.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//
//

import Foundation
import CoreData


extension BusRoute {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BusRoute> {
        return NSFetchRequest<BusRoute>(entityName: "BusRoute")
    }

    @NSManaged public var destination: StopLocation?
    @NSManaged public var origin: StopLocation?
    @NSManaged public var routeOfBusSettings: NSSet?

}

// MARK: Generated accessors for routeOfBusSettings
extension BusRoute {

    @objc(addRouteOfBusSettingsObject:)
    @NSManaged public func addToRouteOfBusSettings(_ value: BusSettings)

    @objc(removeRouteOfBusSettingsObject:)
    @NSManaged public func removeFromRouteOfBusSettings(_ value: BusSettings)

    @objc(addRouteOfBusSettings:)
    @NSManaged public func addToRouteOfBusSettings(_ values: NSSet)

    @objc(removeRouteOfBusSettings:)
    @NSManaged public func removeFromRouteOfBusSettings(_ values: NSSet)

}
