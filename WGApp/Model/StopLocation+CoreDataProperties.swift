//
//  StopLocation+CoreDataProperties.swift
//  WGApp
//
//  Created by Viviane Rehor on 05.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//
//

import Foundation
import CoreData


extension StopLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StopLocation> {
        return NSFetchRequest<StopLocation>(entityName: "StopLocation")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var destinationOfBusRoute: BusRoute?
    @NSManaged public var originOfBusRoute: BusRoute?

}
