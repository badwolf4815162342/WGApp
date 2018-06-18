//
//  StopLocation+CoreDataProperties.swift
//  WGApp
//
//  Created by Viviane Rehor on 10.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//
//

import Foundation
import CoreData


extension StopLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StopLocation> {
        return NSFetchRequest<StopLocation>(entityName: "StopLocation")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var destinationOfBusRoutes: NSSet?
    @NSManaged public var originOfBusRoutes: NSSet?

}

// MARK: Generated accessors for destinationOfBusRoutes
extension StopLocation {

    @objc(addDestinationOfBusRoutesObject:)
    @NSManaged public func addToDestinationOfBusRoutes(_ value: BusRoute)

    @objc(removeDestinationOfBusRoutesObject:)
    @NSManaged public func removeFromDestinationOfBusRoutes(_ value: BusRoute)

    @objc(addDestinationOfBusRoutes:)
    @NSManaged public func addToDestinationOfBusRoutes(_ values: NSSet)

    @objc(removeDestinationOfBusRoutes:)
    @NSManaged public func removeFromDestinationOfBusRoutes(_ values: NSSet)

}

// MARK: Generated accessors for originOfBusRoutes
extension StopLocation {

    @objc(addOriginOfBusRoutesObject:)
    @NSManaged public func addToOriginOfBusRoutes(_ value: BusRoute)

    @objc(removeOriginOfBusRoutesObject:)
    @NSManaged public func removeFromOriginOfBusRoutes(_ value: BusRoute)

    @objc(addOriginOfBusRoutes:)
    @NSManaged public func addToOriginOfBusRoutes(_ values: NSSet)

    @objc(removeOriginOfBusRoutes:)
    @NSManaged public func removeFromOriginOfBusRoutes(_ values: NSSet)

}
