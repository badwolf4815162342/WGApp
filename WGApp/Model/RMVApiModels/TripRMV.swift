//
//  TripRMV.swift
//  WGApp
//
//  Created by Viviane Rehor on 28.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import Foundation

struct TripRMV {
    var id: String
    var durationMinutes: String
    var routeParts:[TripPartRMV]
    var originStopLocation: StopLocation
    var destinationStopLocation: StopLocation
    
    
}

struct TripPartRMV {
    var originStopLocationRMV: StopLocationRMV
    var destibationStopLocationRMV: StopLocationRMV
    var plannedDepartureTime: Date
    var realDepartureTime: Date
    var plannedArivalTime: Date
    var realArivalTime: Date
    var transportationType: String?
    var specificTransportationType: String?
    var transportationName: String?
    var transportationNumber: String?
    var direction: String?
    var feet: Bool
    
}

extension TripPartRMV {
    
    static func toTripPartRMV (leg: Leg) -> TripPartRMV {
        let originStopLocationRMV = StopLocationRMV(id:leg.origin.extID , name:leg.origin.name)
        let destibationStopLocationRMV = StopLocationRMV(id:leg.destination.extID , name:leg.destination.name)
        var finalPDepartureDate: Date? = nil
        var finalRDepartureDate: Date? = nil
        var finalPArivalDate: Date? = nil
        var finalRArivalDate: Date? = nil
        // Departuretimes
        if let pTime: String = leg.origin.time {
            finalPDepartureDate = BusSettingsController.calculateDate(ofTime: pTime, ofDate: leg.origin.date)
        }
        if let rTime: String = leg.origin.rtTime {
            finalRDepartureDate = BusSettingsController.calculateDate(ofTime: rTime, ofDate: leg.origin.rtDate!)
            
        } else {
            finalRDepartureDate = finalPDepartureDate
        }
        // Arivaltimes
        if let pTime: String = leg.destination.time {
            finalPArivalDate = BusSettingsController.calculateDate(ofTime: pTime,  ofDate: leg.destination.date)
        }
        if let rTime: String = leg.destination.rtTime {
            finalRArivalDate = BusSettingsController.calculateDate(ofTime: rTime,  ofDate: leg.destination.rtDate!)
        } else {
            finalRArivalDate = finalPArivalDate
        }
        var feet = false
        if (leg.product != nil){
            var feet = true
        }
        let transportationType = leg.product?["catOut"]!
        let specificTransportationType = leg.product?["catOutL"]!
        let transportationName = leg.name
        let transportationNumber = leg.product?["line"]!
        let direction = leg.direction
        return TripPartRMV(originStopLocationRMV: originStopLocationRMV, destibationStopLocationRMV: destibationStopLocationRMV, plannedDepartureTime: finalPDepartureDate!, realDepartureTime: finalRDepartureDate!, plannedArivalTime: finalPArivalDate!, realArivalTime: finalRArivalDate!, transportationType: transportationType, specificTransportationType: specificTransportationType, transportationName: transportationName, transportationNumber: transportationNumber, direction: direction, feet: feet)
    }
    

}


extension TripRMV {
    
    static func toTripRMV(trip: Trip, stopLocationOrigin: StopLocation, stopLocationDestination: StopLocation) -> TripRMV {
        var routeParts = [TripPartRMV]()
        for tripPart in trip.legList.leg {
            routeParts.append(TripPartRMV.toTripPartRMV(leg: tripPart))
        }

        let duration = trip.duration
        let id = trip.checksum
        
        return TripRMV(id: id, durationMinutes: duration, routeParts: routeParts, originStopLocation: stopLocationOrigin, destinationStopLocation: stopLocationDestination)
    }
    
    func getShowString() -> String {
        let outFormatter = DateFormatter()
        outFormatter.locale = NSLocale(localeIdentifier: "de") as Locale!
        outFormatter.dateFormat = "hh:mm"
        var ret = ""
        var count = 1
        for route in self.routeParts {
            ret += "Abschnitt " + String(count) + ":\n"
            if (!route.feet) {
                ret += " Mit " + (route.transportationName ?? "no name") + " Richtung " + (route.direction ?? "no dir") + "\n"
                ret += " " + outFormatter.string(from: route.realDepartureTime) + "/" + outFormatter.string(from: route.plannedDepartureTime) + " Von: " + route.originStopLocationRMV.name + "\n"
                ret += " " + outFormatter.string(from: route.realArivalTime) + "/" + outFormatter.string(from: route.plannedArivalTime) + " Nach: " + route.destibationStopLocationRMV.name + "\n"
            } else {
                ret += "feet" + "\n"
            }
            count += 1
        }
        ret += "Dauer: " + self.durationMinutes
        return ret
    }
}

