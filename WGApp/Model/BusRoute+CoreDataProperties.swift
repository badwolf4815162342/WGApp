//
//  BusRoute+CoreDataProperties.swift
//  WGApp
//
//  Created by Viviane Rehor on 05.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//
//

import Foundation
import CoreData


extension BusRoute {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BusRoute> {
        return NSFetchRequest<BusRoute>(entityName: "BusRoute")
    }

    @NSManaged public var origin: StopLocation?
    @NSManaged public var destination: StopLocation?

}
