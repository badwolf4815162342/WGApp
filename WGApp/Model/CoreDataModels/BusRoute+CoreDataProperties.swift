//
//  BusRoute+CoreDataProperties.swift
//  WGApp
//
//  Created by Anna Abad on 15.07.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//
//

import Foundation
import CoreData


extension BusRoute {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BusRoute> {
        return NSFetchRequest<BusRoute>(entityName: "BusRoute")
    }

    @NSManaged public var withDestination: Bool
    @NSManaged public var busSetting: BusSetting?
    @NSManaged public var destination: StopLocation?
    @NSManaged public var origin: StopLocation?

}
