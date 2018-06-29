//
//  TripRMV.swift
//  WGApp
//
//  Created by Viviane Rehor on 28.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import Foundation

struct TripRMV {
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
    var realDArivalTime: Date
    var transportationType: String
    var specificTransportationType: String
    var transportationName: String
    var transportationNumber: String
    var direction: String
    
}

extension TripPartRMV {
    
    static func toTripPartRMV (leg: Leg) -> TripPartRMV {
        let originStopLocationRMV = StopLocationRMV(id:leg.origin.extID , name:leg.origin.name)
        let destibationStopLocationRMV = StopLocationRMV(id:leg.destination.extID , name:leg.destination.name)
        var finalPDepartureDate: Date? = nil
        var finalRDepartureDate: Date? = nil
        var finalPArivalDate: Date? = nil
        var finalRArivalDate: Date? = nil
        let inFormatter = DateFormatter()
        inFormatter.locale = NSLocale(localeIdentifier: "de") as Locale?
        inFormatter.dateFormat = "HH:mm:ss"
        // Departuretimes
        if let pTime: String = leg.origin.time {
            finalPDepartureDate = inFormatter.date(from: pTime)!
        }
        if let rTime: String = leg.origin.rtTime {
            finalRDepartureDate = inFormatter.date(from: rTime)!
        } else {
            finalRDepartureDate = finalPDepartureDate
        }
        // Arivaltimes
        if let pTime: String = leg.origin.time {
            finalPArivalDate = inFormatter.date(from: pTime)!
        }
        if let rTime: String = leg.origin.rtTime {
            finalRArivalDate = inFormatter.date(from: rTime)!
        } else {
            finalRArivalDate = finalPArivalDate
        }
        let transportationType = leg.product["catOut"]!
        let specificTransportationType = leg.product["catOutL"]!
        let transportationName = leg.name
        let transportationNumber = leg.product["line"]!
        var direction: String = leg.direction
        return TripPartRMV(originStopLocationRMV: originStopLocationRMV, destibationStopLocationRMV: destibationStopLocationRMV, plannedDepartureTime: finalPDepartureDate!, realDepartureTime: finalRDepartureDate!, plannedArivalTime: finalPArivalDate!, realDArivalTime: finalRArivalDate!, transportationType: transportationType, specificTransportationType: specificTransportationType, transportationName: transportationName, transportationNumber: transportationNumber, direction: direction)
    }
}


extension TripRMV {
    
    static func toTripRMV(trip: Trip, stopLocationOrigin: StopLocation, stopLocationDestination: StopLocation) -> TripRMV {
        var routeParts = [TripPartRMV]()
        for tripPart in trip.legList.leg {
            routeParts.append(TripPartRMV.toTripPartRMV(leg: tripPart))
        }

        let duration = trip.duration
        
        return TripRMV(durationMinutes: duration, routeParts: routeParts, originStopLocation: stopLocationOrigin, destinationStopLocation: stopLocationDestination)
    }
}

