//
//  Configuration.swift
//  WGApp
//
//  Created by Viviane Rehor on 07.07.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

// Simple Configuration Example

struct CONFIG {
    struct RMVAPI {
        static let API_KEY = "59820666-0a39-4ee9-acd4-76a062d39c13"
    }
    
    struct BUSSETTINGS {
        static let BUS_TRIPS_RELOAD_INTERVAL = 10.0
        //static let MAX_SHOWN_TRIPS_PER_BUSPROFILE = 20 unused
        static let MAX_ROUTES_PER_BUSPROFILE = 4
        static let HIGH_PRIO_TRIP_MINUTES = 5
        static let NORMAL_PRIO_TRIP_MINUTES = 10
    }
    
    struct PUTZSETTINGS {
        static let PRE_CALCULATED_WEEK_ITEMS = 20
    }
    
}


