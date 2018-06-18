//
//  User+CoreDataProperties.swift
//  WGApp
//
//  Created by Anna Abad on 11.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var mail: String?

}
