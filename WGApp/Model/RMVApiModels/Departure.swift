//
//  Departure.swift
//  WGApp
//
//  Created by Viviane Rehor on 02.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import Foundation

struct Departure: Codable {
    let journeyDetailRef: JourneyDetailRef
    let journeyStatus: JourneyStatus
    let product: [String: String]
    //let notes: Notes
    let productName: String // Nummer des Busses/Zugs
    let type: DepartureType
    let stop: String
    let stopid, stopEXTID: String
    let prognosisType: String?
    let time, date: String
    let rtTime, rtDate: String?
    let reachable: Bool
    let direction, trainNumber: String
    let trainCategory: TrainCategory
    
    enum CodingKeys: String, CodingKey {
        case journeyDetailRef = "JourneyDetailRef"
        case journeyStatus = "JourneyStatus"
        case product = "Product"
        //case notes = "Notes"
        case productName = "name"
        case type, stop, stopid
        case stopEXTID = "stopExtId"
        case prognosisType, time, date, rtTime, rtDate, reachable, direction, trainNumber, trainCategory
    }
}
