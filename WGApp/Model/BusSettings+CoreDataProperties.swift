//
//  BusSettings+CoreDataProperties.swift
//  WGApp
//
//  Created by Anna Abad on 04.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//
//

import Foundation
import CoreData


extension BusSettings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BusSettings> {
        return NSFetchRequest<BusSettings>(entityName: "BusSettings")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var ofProfil: Profil?

}
