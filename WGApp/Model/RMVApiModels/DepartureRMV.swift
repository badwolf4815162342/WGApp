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
    var id:String
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

        let id = departure.journeyDetailRef.ref
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
        return DepartureRMV(id: id, transportationType: transportationType, specificTransportationType: specificTransportationType, transportationName: transportationName, transportationNumber: transportationNumber, plannedDepartureTime: finalPDate!, realDepartureTime: finalRDate!, direction: direction, stopLocation: stopLocation)
    }
    
    func getShowString() -> String {
        let outFormatter = DateFormatter()
        outFormatter.locale = NSLocale(localeIdentifier: "de") as Locale!
        outFormatter.dateFormat = "hh:mm"
        var ret = ""
        ret += " Mit " + (transportationName ?? "no name") + " Richtung " + (direction ?? "no dir") + "\n"
        ret += " " + outFormatter.string(from: realDepartureTime) + "/" + outFormatter.string(from: plannedDepartureTime)
        ret += " Von: " + stopLocation.name! + "\n"
        return ret
    }
    
}
