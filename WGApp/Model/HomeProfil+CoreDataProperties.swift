//
//  HomeProfil+CoreDataProperties.swift
//  WGApp
//
//  Created by Viviane Rehor on 10.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//
//

import Foundation
import CoreData


extension HomeProfil {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HomeProfil> {
        return NSFetchRequest<HomeProfil>(entityName: "HomeProfil")
    }


}
