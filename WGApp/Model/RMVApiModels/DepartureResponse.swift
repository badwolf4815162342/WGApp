//
//  DepartureResponse.swift
//  WGApp
//
//  Created by Viviane Rehor on 02.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import Foundation

import Foundation

struct DepartureResponse: Codable {
    let departure: [Departure]
    let serverVersion, dialectVersion, requestID: String
    
    enum CodingKeys: String, CodingKey {
        case departure = "Departure"
        case serverVersion, dialectVersion
        case requestID = "requestId"
    }
}

/**
 struct Departure: Codable {
 let journeyDetailRef: JourneyDetailRef
 let journeyStatus: JourneyStatus
 let product: [String: String]
 let notes: Notes
 let name: String
 let type: DepartureType
 let stop: Stop
 let stopid, stopEXTID: String
 let prognosisType: PrognosisType?
 let time, date: String
 let rtTime, rtDate: String?
 let reachable: Bool
 let direction, trainNumber: String
 let trainCategory: TrainCategory
 
 enum CodingKeys: String, CodingKey {
 case journeyDetailRef = "JourneyDetailRef"
 case journeyStatus = "JourneyStatus"
 case product = "Product"
 case notes = "Notes"
 case name, type, stop, stopid
 case stopEXTID = "stopExtId"
 case prognosisType, time, date, rtTime, rtDate, reachable, direction, trainNumber, trainCategory
 }
 }
 **/

struct JourneyDetailRef: Codable {
    let ref: String
}

enum JourneyStatus: String, Codable {
    case p = "P"
}

struct Notes: Codable {
    let note: [Note]?
    
    enum CodingKeys: String, CodingKey {
        case note = "Note"
    }
}

struct Note: Codable {
    let value: String
    let key: String?
    let type: String?
    let routeIdxFrom, routeIdxTo: Int?
}


enum TrainCategory: String, Codable {
    case bb1 = "BB1"
}

enum DepartureType: String, Codable {
    case s = "S"
}
