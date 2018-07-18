//
//  Welcome.swift
//  NetworkTest
//
//  Created by Viviane Rehor on 31.05.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

struct StopLocationResponse: Codable {
    let stopLocationOrCoordLocation: [StopLocationOrCoordLocation]
    let serverVersion, dialectVersion, requestID: String
    
    enum CodingKeys: String, CodingKey {
        case stopLocationOrCoordLocation, serverVersion, dialectVersion
        case requestID = "requestId"
    }
}

struct StopLocationOrCoordLocation: Codable {
    let stopLocation: StopLocationRMV?
    let coordLocation: CoordLocation?
    
    enum CodingKeys: String, CodingKey {
        case stopLocation = "StopLocation"
        case coordLocation = "CoordLocation"
    }
}

struct CoordLocation: Codable {
    let links: [LinkElement]?
    let title, description, type: String
    let lon, lat: Double
    let refinable: Bool?
    
    enum CodingKeys: String, CodingKey {
        case title = "id"
        case description = "name"
        case type, lon, lat, refinable, links
    }
    
}

struct LinkElement: Codable {
    let link: LinkLink
}

struct LinkLink: Codable {
    let rel, href: String
}

