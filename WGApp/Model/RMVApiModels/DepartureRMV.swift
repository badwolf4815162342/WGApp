//
//  DepartureRMV.swift
//  WGApp
//
//  Created by Viviane Rehor on 24.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import Foundation
import Foundation

struct DepartureRMV {
    var transportationType: String
    var specificTransportationType: String
    var transportationName: String
    var transportationNumber: String
    var plannedDepartureTime: Date
    var realDepartureTime: Date
    var direction: String
    var stopLocation: StopLocation

    
}


extension DepartureRMV {
    
    static func toDepartureRMV(departure: Departure, stopLocation: StopLocation) -> DepartureRMV {


        let transportationType = departure.product["catOut"]!
        let specificTransportationType = departure.product["catOutL"]!
        let transportationName = departure.productName
        let transportationNumber = departure.product["line"]!
        //departureRMV.realDepartureTime = departure.rtTime
        let direction = departure.direction
        var finalPDate: Date? = nil
        var finalRDate: Date? = nil
        print(transportationName)
        print(departure)
        if let pTime: String = departure.time {
            finalPDate = BusSettingsController.calculateDate(ofTime: pTime,  ofDate: departure.date)
            print(finalPDate)
        }
        if let rTime: String = departure.rtTime {
            finalRDate = BusSettingsController.calculateDate(ofTime: rTime,  ofDate: departure.rtDate!)
            print(finalRDate)
        } else {
            finalRDate = finalPDate
        }
        return DepartureRMV(transportationType: transportationType, specificTransportationType: specificTransportationType, transportationName: transportationName, transportationNumber: transportationNumber, plannedDepartureTime: finalPDate!, realDepartureTime: finalRDate!, direction: direction, stopLocation: stopLocation)
    }
    
}
