//
//  StopLocation.swift
//  WGApp
//
//  Created by Viviane Rehor on 31.05.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import Foundation

struct StopLocationRMV: Codable {
    var id: String
    var name: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "extId"
        case name
    }
}


extension StopLocationRMV{

    static func stopLocationToRmv(stopLocation: StopLocation ) -> StopLocationRMV {
        let rmv = StopLocationRMV(id: stopLocation.id!, name: stopLocation.name!)
        return rmv
    }
    

}

