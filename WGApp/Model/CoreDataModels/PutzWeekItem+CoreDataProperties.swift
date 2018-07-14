//
//  PutzWeekItem+CoreDataProperties.swift
//  WGApp
//
//  Created by Anna Abad on 13.07.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//
//

import Foundation
import CoreData


extension PutzWeekItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PutzWeekItem> {
        return NSFetchRequest<PutzWeekItem>(entityName: "PutzWeekItem")
    }

    @NSManaged public var done: Bool
    @NSManaged public var numberOfWeeks: Int64
    @NSManaged public var weekStartDay: NSDate?
    @NSManaged public var putzSetting: PutzSetting?
    @NSManaged public var user: User?

}
