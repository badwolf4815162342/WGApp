//
//  Configuration.swift
//  WGApp
//
//  Created by Viviane Rehor on 07.07.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

// Simple Configuration Example

import UIKit

struct CONFIG {
    struct RMVAPI {
        static let API_KEY = "59820666-0a39-4ee9-acd4-76a062d39c13"
    }
    
    struct BUSSETTINGS {
        static let BUS_TRIPS_RELOAD_INTERVAL = 20.0
        //static let MAX_SHOWN_TRIPS_PER_BUSPROFILE = 20 unused
        static let MAX_ROUTES_PER_BUSPROFILE = 4
        static let HIGH_PRIO_TRIP_MINUTES = 5
        static let NORMAL_PRIO_TRIP_MINUTES = 10
    }
    
    struct PUTZSETTINGS {
        static let PRE_CALCULATED_WEEK_ITEMS = 20
        static let ONE_WEEK_REPEAT_LABEL_TEXT = "Jede Woche wiederholen"
        static let X_WEEK_REPEAT_LABEL_TEXT =  "Alle %d Wochen wiederholen"
        static let NEXT_X_WEEKS_PUTZSETTINGS_ARE_CALCULATED_FOR = 26
        //static let START_DAY_OF_WEEK: Date =  Date.monday
        static let WEEKS_BACK_IN_CALENDER = 1
        
        static let ITEM_DAYS_UNTIL_DEADLINE_RED = 1
        static let ITEM_DAYS_UNTIL_DEADLINE_YELLOW = 4
        static let ITEM_DAYS_UNTIL_DEADLINE_GREEN = 7
        
    }
    
    
    struct COLORS {
        static let DARK_GREY = UIColor(red:0.15, green:0.21, blue:0.28, alpha:1.0)
        static let RED = UIColor(red:0.98, green:0.34, blue:0.36, alpha:1.0)
        static let YELLOW = UIColor(red:0.98, green:0.78, blue:0.44, alpha:1.0)
        static let LIGHT_GREEN = UIColor(red:0.52, green:0.85, blue:0.75, alpha:1.0)
        static let GREEN = UIColor(red:0.42, green:0.67, blue:0.61, alpha:1.0)
        static let PETROL = UIColor(red:0.19, green:0.50, blue:0.57, alpha:1.0)
        static let WHITE = UIColor(red:0.99, green:0.98, blue:0.95, alpha:1.0)
        static let LIGHT_PETROL = UIColor(red:0.45, green:0.76, blue:0.81, alpha:1.0)
        static let GREY = UIColor(red:0.22, green:0.27, blue:0.35, alpha:1.0)
        static let LIGHT_GREY = UIColor(red:0.26, green:0.32, blue:0.41, alpha:1.0)
    }
    
}


