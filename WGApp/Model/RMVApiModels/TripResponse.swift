//
//  TripResponse.swift
//  WGApp
//
//  Created by Viviane Rehor on 02.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

// To parse the JSON, add this file to your project and do:
//
//   let tripResponse = try? JSONDecoder().decode(TripResponse.self, from: jsonData)

import Foundation

struct TripResponse: Codable {
    let trip: [Trip]
    let serverVersion, dialectVersion, requestID, scrB: String
    let scrF: String
    
    enum CodingKeys: String, CodingKey {
        case trip = "Trip"
        case serverVersion, dialectVersion
        case requestID = "requestId"
        case scrB, scrF
    }
}

struct Trip: Codable {
    let serviceDays: [ServiceDay]
    let legList: LegList
    let tariffResult: TariffResult?
    let idx: Int
    let tripID, ctxRecon, duration, checksum: String
    
    enum CodingKeys: String, CodingKey {
        case serviceDays = "ServiceDays"
        case legList = "LegList"
        case tariffResult = "TariffResult"
        case idx
        case tripID = "tripId"
        case ctxRecon, duration, checksum
    }
}

struct LegList: Codable {
    let leg: [Leg]
    
    enum CodingKeys: String, CodingKey {
        case leg = "Leg"
    }
}

struct Leg: Codable {
    let origin, destination: Location
    let notes: Notes?
    let journeyDetailRef: JourneyDetailRef
    let messages: Messages?
    let journeyStatus: String
    let product: [String: String]
    let idx, name, number, category: String
    let type: String
    let reachable: Bool
    let direction: String
    
    enum CodingKeys: String, CodingKey {
        case origin = "Origin"
        case destination = "Destination"
        case notes = "Notes"
        case journeyDetailRef = "JourneyDetailRef"
        case messages = "Messages"
        case journeyStatus = "JourneyStatus"
        case product = "Product"
        case idx, name, number, category, type, reachable, direction
    }
}

struct Location: Codable {
    let name: String
    let type: TypeEnum
    let id, extID: String
    let lon, lat: Double
    let routeIdx: Int?
    let prognosisType: PrognosisTypeEnum
    let time, date: String
    let rtTime, rtDate: String?
    let rtAlighting: Bool?
    let track: String?
    let rtBoarding: Bool?
    
    enum CodingKeys: String, CodingKey {
        case name, type, id
        case extID = "extId"
        case lon, lat, routeIdx, prognosisType, time, date, rtTime, rtDate, rtAlighting, track, rtBoarding
    }
}

enum PrognosisTypeEnum: String, Codable {
    case calculated = "CALCULATED"
    case prognosed = "PROGNOSED"
}

enum TypeEnum: String, Codable {
    case st = "ST"
}

struct Messages: Codable {
    let message: [Message]
    
    enum CodingKeys: String, CodingKey {
        case message = "Message"
    }
}

struct Message: Codable {
    let id: String
    let act: Bool
    let head, lead, text, company: String
    let category: String
    let priority, products: Int
    let sTime, sDate, eTime, eDate: String
    let altStart, altEnd: String
}

struct ServiceDay: Codable {
    let planningPeriodBegin, planningPeriodEnd, sDaysR, sDaysB: String
    let sDaysI: String?
}

struct TariffResult: Codable {
    let fareSetItem: [FareSetItem]
}

struct FareSetItem: Codable {
    let fareItem: [FareItem]
    let name: String
}

struct FareItem: Codable {
    let ticket: [FareItem]?
    let name: String
    let desc: Desc
    let price: Int
    let shpCtx: String
    let cur: Cur?
}

enum Cur: String, Codable {
    case eur = "EUR"
}

enum Desc: String, Codable {
    case auszubildende = "Auszubildende"
    case erwUndKinder = "Erw. und Kinder"
    case erwachsene = "Erwachsene"
    case kinder = "Kinder"
    case ohneUmweg = "ohne Umweg"
    case senioren = "Senioren"
}
