//
//  Debt+CoreDataProperties.swift
//  WGApp
//
//  Created by Anna Abad on 15.07.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//
//

import Foundation
import CoreData


extension Debt {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Debt> {
        return NSFetchRequest<Debt>(entityName: "Debt")
    }

    @NSManaged public var balance: Double
    @NSManaged public var date: NSDate?
    @NSManaged public var id: Int64
    @NSManaged public var creditor: User?
    @NSManaged public var debtor: User?

}
