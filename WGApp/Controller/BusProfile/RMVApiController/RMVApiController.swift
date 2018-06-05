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
    
    // Function that calls sopLocations from Network and returns completion(Array<StopLocations>
    func getTestStoplocations(withEntryString: String, completion: @escaping (Array<StopLocation>) ->  ()){
        var stopLocations = [StopLocation]()
        
        let stopLocationString = """
        {
            "stopLocationOrCoordLocation": [
                {
                    "StopLocation": {
                        "id": "A=1@O=WI Loreleiring@X=8220662@Y=50077377@U=80@L=003025906@B=1@V=6.9,@p=1527687845@",
                        "extId": "003025906",
                        "name": "WI Loreleiring",
                        "lon": 8.220662,
                        "lat": 50.077377,
                        "weight": 185,
                        "products": 64
                    }
                },
                {
                    "StopLocation": {
                        "id": "A=1@O=WI Loreleiring@X=8220662@Y=50077377@U=80@L=003025906@B=1@V=6.9,@p=1527687845@",
                        "extId": "003025906",
                        "name": "WI Loreleiring",
                        "lon": 8.220662,
                        "lat": 50.077377,
                        "weight": 185,
                        "products": 64
                    }
                },
                {
                    "StopLocation": {
                        "id": "A=1@O=WI Loreleiring@X=8220662@Y=50077377@U=80@L=003025906@B=1@V=6.9,@p=1527687845@",
                        "extId": "003025906",
                        "name": "WI Loreleiring",
                        "lon": 8.220662,
                        "lat": 50.077377,
                        "weight": 185,
                        "products": 64
                    }
                },
                {
                    "StopLocation": {
                        "id": "A=1@O=WI Loreleiring@X=8220662@Y=50077377@U=80@L=003025906@B=1@V=6.9,@p=1527687845@",
                        "extId": "003025906",
                        "name": "WI Loreleiring",
                        "lon": 8.220662,
                        "lat": 50.077377,
                        "weight": 185,
                        "products": 64
                    }
                },
                {
                    "StopLocation": {
                        "id": "A=1@O=WI Loreleiring@X=8220662@Y=50077377@U=80@L=003025906@B=1@V=6.9,@p=1527687845@",
                        "extId": "003025906",
                        "name": "WI Loreleiring",
                        "lon": 8.220662,
                        "lat": 50.077377,
                        "weight": 185,
                        "products": 64
                    }
                },
                {
                    "StopLocation": {
                        "id": "A=1@O=WI Loreleiring@X=8220662@Y=50077377@U=80@L=003025906@B=1@V=6.9,@p=1527687845@",
                        "extId": "003025906",
                        "name": "WI Loreleiring",
                        "lon": 8.220662,
                        "lat": 50.077377,
                        "weight": 185,
                        "products": 64
                    }
                },
                {
                    "StopLocation": {
                        "id": "A=1@O=WI Loreleiring@X=8220662@Y=50077377@U=80@L=003025906@B=1@V=6.9,@p=1527687845@",
                        "extId": "003025906",
                        "name": "WI Loreleiring",
                        "lon": 8.220662,
                        "lat": 50.077377,
                        "weight": 185,
                        "products": 64
                    }
                },
                {
                    "StopLocation": {
                        "id": "A=1@O=WI-Mainz-Kastel Lorenz-Schott-Straße@X=8276521@Y=50025833@U=80@L=003025422@B=1@V=6.9,@p=1527687845@",
                        "extId": "003025422",
                        "name": "WI-Mainz-Kastel Lorenz-Schott-Straße",
                        "lon": 8.276521,
                        "lat": 50.025833,
                        "weight": 56,
                        "products": 64
                    }
                },
                {
                    "StopLocation": {
                        "id": "A=1@O=WI-Dotzheim Lorenz-Werthmann-Haus@X=8192337@Y=50082726@U=80@L=003025414@B=1@V=6.9,@p=1527687845@",
                        "extId": "003025414",
                        "name": "WI-Dotzheim Lorenz-Werthmann-Haus",
                        "lon": 8.192337,
                        "lat": 50.082726,
                        "weight": 14,
                        "products": 64
                    }
                },
                {
                    "CoordLocation": {
                        "links": [
                            {
                                "link": {
                                    "rel": "refine",
                                    "href": "//www.rmv.de/hapi/location.name?input=Lierschied%2C+Loreleystra%C3%9Fe&refineId=A%3D2%40O%3DLierschied%2C+Loreleystra%C3%9Fe%40X%3D7744593%40Y%3D50167988%40U%3D103%40b%3D990113419%40B%3D1%40V%3D6.9%2C%40p%3D1495608155%40&type=A"
                                }
                            }
                        ],
                        "id": "A%3D2%40O%3DLierschied%2C+Loreleystra%C3%9Fe%40X%3D7744593%40Y%3D50167988%40U%3D103%40b%3D990113419%40B%3D1%40V%3D6.9%2C%40p%3D1495608155%40",
                        "name": "Lierschied, Loreleystraße",
                        "type": "ADR",
                        "lon": 7.744593,
                        "lat": 50.167988,
                        "refinable": true
                    }
                },
                {
                    "CoordLocation": {
                        "links": [
                            {
                                "link": {
                                    "rel": "refine",
                                    "href": "//www.rmv.de/hapi/location.name?input=Bornich%2C+Loreleyring&refineId=A%3D2%40O%3DBornich%2C+Loreleyring%40X%3D7761259%40Y%3D50127258%40U%3D103%40b%3D990026399%40B%3D1%40V%3D6.9%2C%40p%3D1495608155%40&type=A"
                                }
                            }
                        ],
                        "id": "A%3D2%40O%3DBornich%2C+Loreleyring%40X%3D7761259%40Y%3D50127258%40U%3D103%40b%3D990026399%40B%3D1%40V%3D6.9%2C%40p%3D1495608155%40",
                        "name": "Bornich, Loreleyring",
                        "type": "ADR",
                        "lon": 7.761259,
                        "lat": 50.127258,
                        "refinable": true
                    }
                },
                {
                    "CoordLocation": {
                        "links": [
                            {
                                "link": {
                                    "rel": "refine",
                                    "href": "//www.rmv.de/hapi/location.name?input=Urbar%2C+Loreleystra%C3%9Fe&refineId=A%3D2%40O%3DUrbar%2C+Loreleystra%C3%9Fe%40X%3D7720332%40Y%3D50132679%40U%3D103%40b%3D990182111%40B%3D1%40V%3D6.9%2C%40p%3D1495608155%40&type=A"
                                }
                            }
                        ],
                        "id": "A%3D2%40O%3DUrbar%2C+Loreleystra%C3%9Fe%40X%3D7720332%40Y%3D50132679%40U%3D103%40b%3D990182111%40B%3D1%40V%3D6.9%2C%40p%3D1495608155%40",
                        "name": "Urbar, Loreleystraße",
                        "type": "ADR",
                        "lon": 7.720332,
                        "lat": 50.132679,
                        "refinable": true
                    }
                },
                {
                    "StopLocation": {
                        "id": "A=1@O=Lorch(Württ)@X=9695747@Y=48797898@U=80@L=008003752@B=1@V=6.9,@p=1527687845@",
                        "extId": "008003752",
                        "name": "Lorch(Württ)",
                        "lon": 9.695747,
                        "lat": 48.797898,
                        "weight": 3739,
                        "products": 4
                    }
                },
                {
                    "StopLocation": {
                        "id": "A=1@O=Lorch(Württ)@X=9695747@Y=48797898@U=80@L=008003752@B=1@V=6.9,@p=1527687845@",
                        "extId": "008003752",
                        "name": "Lorch(Württ)",
                        "lon": 9.695747,
                        "lat": 48.797898,
                        "weight": 3739,
                        "products": 4
                    }
                },
                {
                    "StopLocation": {
                        "id": "A=1@O=Lorch(Württ)@X=9695747@Y=48797898@U=80@L=008003752@B=1@V=6.9,@p=1527687845@",
                        "extId": "008003752",
                        "name": "Lorch(Württ)",
                        "lon": 9.695747,
                        "lat": 48.797898,
                        "weight": 3739,
                        "products": 4
                    }
                },
                {
                    "CoordLocation": {
                        "links": [
                            {
                                "link": {
                                    "rel": "refine",
                                    "href": "//www.rmv.de/hapi/location.name?input=Weisel%2C+Loreleystra%C3%9Fe&refineId=A%3D2%40O%3DWeisel%2C+Loreleystra%C3%9Fe%40X%3D7794834%40Y%3D50114754%40U%3D103%40b%3D990191499%40B%3D1%40V%3D6.9%2C%40p%3D1495608155%40&type=A"
                                }
                            }
                        ],
                        "id": "A%3D2%40O%3DWeisel%2C+Loreleystra%C3%9Fe%40X%3D7794834%40Y%3D50114754%40U%3D103%40b%3D990191499%40B%3D1%40V%3D6.9%2C%40p%3D1495608155%40",
                        "name": "Weisel, Loreleystraße",
                        "type": "ADR",
                        "lon": 7.794834,
                        "lat": 50.114754,
                        "refinable": true
                    }
                },
                {
                    "CoordLocation": {
                        "links": [
                            {
                                "link": {
                                    "rel": "refine",
                                    "href": "//www.rmv.de/hapi/location.name?input=Wiesbaden%2C+Loreleiring&refineId=A%3D2%40O%3DWiesbaden%2C+Loreleiring%40X%3D8221957%40Y%3D50076182%40U%3D103%40b%3D990196346%40B%3D1%40V%3D6.9%2C%40p%3D1495608155%40&type=A"
                                }
                            }
                        ],
                        "id": "A%3D2%40O%3DWiesbaden%2C+Loreleiring%40X%3D8221957%40Y%3D50076182%40U%3D103%40b%3D990196346%40B%3D1%40V%3D6.9%2C%40p%3D1495608155%40",
                        "name": "Wiesbaden, Loreleiring",
                        "type": "ADR",
                        "lon": 8.221957,
                        "lat": 50.076182,
                        "refinable": true
                    }
                },
                {
                    "CoordLocation": {
                        "links": [
                            {
                                "link": {
                                    "rel": "refine",
                                    "href": "//www.rmv.de/hapi/location.name?input=D%C3%B6rscheid%2C+Loreleyblick&refineId=A%3D2%40O%3DD%C3%B6rscheid%2C+Loreleyblick%40X%3D7749511%40Y%3D50108471%40U%3D103%40b%3D990042681%40B%3D1%40V%3D6.9%2C%40p%3D1495608155%40&type=A"
                                }
                            }
                        ],
                        "id": "A%3D2%40O%3DD%C3%B6rscheid%2C+Loreleyblick%40X%3D7749511%40Y%3D50108471%40U%3D103%40b%3D990042681%40B%3D1%40V%3D6.9%2C%40p%3D1495608155%40",
                        "name": "Dörscheid, Loreleyblick",
                        "type": "ADR",
                        "lon": 7.749511,
                        "lat": 50.108471,
                        "refinable": true
                    }
                }
            ],
            "serverVersion": "1.9",
            "dialectVersion": "1.23",
            "requestId": "1527776907488"
        }
        """
    
        let data = stopLocationString.data(using: .utf8)!
        
        //Implement JSON decoding and parsing
        do {
            //Decode retrived data with JSONDecoder and assing type of Article object
            let stopLocationResponse = try JSONDecoder().decode(StopLocationResponse.self, from: data)
            
            for sLOCL in stopLocationResponse.stopLocationOrCoordLocation {
                if let location = sLOCL.stopLocation {
                    stopLocations.append(location)
                }
            }
            print("TestJson encoded with \(stopLocations.count) StopLocations found")
            // return completion
            completion(stopLocations)
        } catch DecodingError.keyNotFound(let key, let context) {
            print("coundn't find key \(key) in JSON: \(context.debugDescription)")
        } catch let jsonError {
            print(jsonError)
        }
 
    }
    
    
    
}

