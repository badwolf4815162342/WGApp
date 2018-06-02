//
//  RMVApiController.swift
//  NetworkTest
//
//  Created by Viviane Rehor on 01.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import Foundation

protocol RMVApiControllerProtocol {
    
    var host: String { get }
    
    var locationsPath: String { get }
    
    var departuresPath: String { get }
    
    var baseQueryDict: [String: String] { get set }
    
    func getStoplocations(withEntryString: String, completion: @escaping (Array<StopLocation>) ->  ())
    
    func getRoutes(fromOriginId: String, toDestinationId: String, completion: @escaping (Array<StopLocation>) ->  ())
    
    func getDepartures(fromOriginId: String, completion: @escaping (Array<Departure>) ->  ())
    
}

class RMVApiController: RMVApiControllerProtocol {
    
    var host = "https://www.rmv.de/hapi"
    
    var locationsPath = "/location.name"
    
    var departuresPath = "/departureBoard"
    
    var baseQueryDict = ["accessId": "59820666-0a39-4ee9-acd4-76a062d39c13", "format": "json"]
    
    // Function that calls sopLocations from Network and returns completion(Array<StopLocations>
    func getStoplocations(withEntryString: String, completion: @escaping (Array<StopLocation>) ->  ()){
        
        // add additional query params and replace spaces
        let additionalQueryDict = ["input": withEntryString.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)]
        
        var stopLocations = [StopLocation]()
        
        // generate Url
        let urlString = getUrl(withQueryDict: additionalQueryDict, ofPath: locationsPath)
        print("Ready to execute network call of: '\(urlString)'")
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            
            //Implement JSON decoding and parsing
            do {
                //Decode retrived data with JSONDecoder and assing type of Article object
                let stopLocationResponse = try JSONDecoder().decode(StopLocationResponse.self, from: data)
                
                for sLOCL in stopLocationResponse.stopLocationOrCoordLocation {
                    if let location = sLOCL.stopLocation {
                        stopLocations.append(location)
                    }
                }
                print("Network call done for path: '\(urlString)' with \(stopLocations.count) StopLocationsFound")
                // return completion
                completion(stopLocations)
            } catch DecodingError.keyNotFound(let key, let context) {
                print("coundn't find key \(key) in JSON: \(context.debugDescription)")
            } catch let jsonError {
                print(jsonError)
            }
            }.resume()
    }
    
    func getRoutes(fromOriginId: String, toDestinationId: String, completion: @escaping (Array<StopLocation>) -> ()) {
        return
    }
    
    func getDepartures(fromOriginId: String, completion: @escaping (Array<Departure>) -> ()) {
        // add additional query params and replace spaces
        let additionalQueryDict = ["id": fromOriginId]
        
        var departures = [Departure]()
        
        // generate Url
        let urlString = getUrl(withQueryDict: additionalQueryDict, ofPath: departuresPath)
        print("Ready to execute network call of: '\(urlString)'")
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            
            //Implement JSON decoding and parsing
            do {
                //Decode retrived data with JSONDecoder and assing type of Article object
                let departureResponse = try JSONDecoder().decode(DepartureResponse.self, from: data)
                
                departures = departureResponse.departure
                
                print("Network call done for path: '\(urlString)' with \(departures.count) StopLocationsFound")
                // return completion
                completion(departures)
            } catch DecodingError.keyNotFound(let key, let context) {
                print("coundn't find key \(key) in JSON: \(context.debugDescription)")
            } catch let jsonError {
                print(jsonError)
            }
            }.resume()
    }
    
    func getUrl(withQueryDict: [String: String], ofPath: String) -> String {
        var url = self.host + ofPath + "?"
        var tempDict = [String: String]()
        tempDict.merge(baseQueryDict, uniquingKeysWith: +)
        tempDict.merge(withQueryDict, uniquingKeysWith: +)
        for (key, value) in tempDict {
            url.append(key + "=" + value + "&")
        }
        //Delete Last Character '&'
        return String(url.dropLast())
    }
    
}

