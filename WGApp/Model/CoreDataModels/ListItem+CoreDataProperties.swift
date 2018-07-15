//
//  ListItem+CoreDataProperties.swift
//  WGApp
//
//  Created by Anna Abad on 15.07.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//
//

import Foundation
import CoreData


extension ListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ListItem> {
        return NSFetchRequest<ListItem>(entityName: "ListItem")
    }

    @NSManaged public var bought: Bool
    @NSManaged public var id: Int64
    @NSManaged public var value: String?
    @NSManaged public var purchase: Purchase?

}
