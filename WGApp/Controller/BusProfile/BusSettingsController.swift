//
//  BusSettingsController.swift
//  WGApp
//
//  Created by Viviane Rehor on 15.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class BusSettingsController: NSObject {
    
    /**
     * Deletest old destination from busRoute, but old StopLocation stays in db without
     * connection to busRoute and sets rmvStopLocation as a new StopLocation
     * if there isn't one if the same data, then it sets this one as new destination
     **/
    class func saveDestinationStopLocationRMVToBusRoute(rmvStopLocation: StopLocationRMV?, busRoute: BusRoute) {
        if let stopLocationRMV = rmvStopLocation {
            if let oldStopLocation = busRoute.destination {
                deleteDestinationStopLocationFromBusRoute(stopLocation: oldStopLocation, busRoute: busRoute)
            }
            // check for already existing stopLocation with same values
            let existingStopLocation = findStopLocationByRMVStopLocation(rmvStopLocation: stopLocationRMV)
            if (existingStopLocation != nil ) {
                busRoute.destination = existingStopLocation
            } else {
                let newStopLocation = StopLocation(context: PersistenceService.context)
                newStopLocation.name = stopLocationRMV.name
                newStopLocation.id = stopLocationRMV.id
                busRoute.destination = newStopLocation
            }
            busRoute.withDestination = true
        } else {
            busRoute.destination = nil
            busRoute.withDestination = false
        }
        PersistenceService.saveContext()
        
    }
    
    /**
     * Deletest old origin from busRoute, but old StopLocation stays in db without
     * connection to busRoute and sets rmvStopLocation as a new StopLocation
     * if there isn't one if the same data, then it sets this one as new origin
     **/
    class func saveOriginStopLocationRMVToBusRoute(rmvStopLocation: StopLocationRMV, busRoute: BusRoute) {
        // eventuell alte löschen
        if let oldStopLocation = busRoute.origin {
            deleteOriginStopLocationFromBusRoute(stopLocation: oldStopLocation, busRoute: busRoute)
        }
        let existingStopLocation = findStopLocationByRMVStopLocation(rmvStopLocation: rmvStopLocation)
        
        if (existingStopLocation != nil ) {
            busRoute.origin = existingStopLocation
        } else {
            let newStopLocation = StopLocation(context: PersistenceService.context)
            newStopLocation.name = rmvStopLocation.name
            newStopLocation.id = rmvStopLocation.id
            busRoute.origin = newStopLocation
        }

        PersistenceService.saveContext()
    }
    
    class func deleteOriginStopLocationFromBusRoute(stopLocation: StopLocation, busRoute: BusRoute) {
        //let context = PersistenceService.context
        // if stoplocation is not in any other route -> Erstmal nicht löschen!!
        //if (stopLocation.originOfBusRoutes?.count == 0 && stopLocation.destinationOfBusRoutes?.count == 0) {
            
        //}
        busRoute.origin = nil
        //if (busRoute.destination == nil) {
        //    deleteBusRoute(busRoute)
        //}
        try PersistenceService.saveContext()
    }
    
    class func deleteDestinationStopLocationFromBusRoute(stopLocation: StopLocation, busRoute: BusRoute) {
        //let context = PersistenceService.context
        // if stoplocation is not in any other route -> Erstmal nicht löschen!!
        //if (stopLocation.originOfBusRoutes?.count == 0 && stopLocation.destinationOfBusRoutes?.count == 0) {
        
        //}
        busRoute.destination = nil
        PersistenceService.saveContext()

    }
    
    class func findStopLocationByNameAndId(name: String, id: String) -> StopLocation? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "StopLocation")
        request.predicate = NSPredicate(format: "id = %@", id)
        request.predicate = NSPredicate(format: "name = %@", name)
        request.returnsObjectsAsFaults = false
        
        let context = PersistenceService.context
        do {
            let result = try context.fetch(request)
            
            if let results = result as? [NSManagedObject] {
                if (results.count == 1) {
                    return results[0] as! StopLocation
                } else if (results.count > 1) {
                    print("ERROR: More than one StopLocation in DB with same values")
                } else {
                    return nil
                }
            }
        } catch {
            print("Failed fetch for specific stoplocation")
        }
        return nil
    }
    
    class func findStopLocationByRMVStopLocation(rmvStopLocation: StopLocationRMV) -> StopLocation? {
       return findStopLocationByNameAndId(name: rmvStopLocation.name, id: rmvStopLocation.id)
    }

   // func equalRoutes(busRoute: BusRoute, otherBusRoute: BusRoute) -> Bool {
    //     return ( (busRoute.origin == otherBusRoute.origin) && (busRoute.destination == otherBusRoute.destination) )
    //}
    
    /**
    * After editing exissting BusRoute the old one gets deleted and both its StopLocations loose
    * connection to it, the the new one is added to the busProfile
    **/
    @warn_unqualified_access
    class func replaceBusRouteOfBusProfile(newBusRoute: BusRoute, oldBusRoute: BusRoute, busProfile: BusSetting) -> BusSetting{
        // replace route
        newBusRoute.busSetting = busProfile
        PersistenceService.saveContext()
        
        // delete oldbusRoute
        PersistenceService.context.delete(oldBusRoute)

        // unconnect stoplocations
        /** var origin = StopLocation(context: PersistenceService.context)
        print(origin.originOfBusRoutes?.count)
        origin = oldBusRoute.origin!
        print(origin.originOfBusRoutes?.count)
        var destination = StopLocation(context: PersistenceService.context)
        print(origin.destinationOfBusRoutes?.count)
        destination = oldBusRoute.destination!
        print(origin.destinationOfBusRoutes?.count) **/       
        return busProfile
        
    }
    
    class func deleteAllData(entity: String)
    {
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = PersistenceService.context
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
    class func printSettings(busProfile: BusSetting) {
        print("------ BusSetiing: ",busProfile.title,":")
        
        for r in busProfile.routes! {
            if let route = r as? BusRoute {
                print("----- Route:s")
                print("----- Origin: ",route.origin)
                print("----- Destin: ",route.destination)
            }
        }
    }
    
    class func getAllStopLocations() ->  [StopLocation] {
        var stops = [StopLocation]()
        let fetchRequest: NSFetchRequest<StopLocation> = StopLocation.fetchRequest()
        do {
            let sls = try PersistenceService.context.fetch(fetchRequest)
            stops = sls
        } catch {
            print("ERROR while fetching all StopLocations")
        }
        return stops
    }
    
    class func deleteRouteFromBusProfile(busRoute: BusRoute, busProfile: BusSetting) {
        PersistenceService.context.delete(busRoute)
    }
    
    class func deleteBusProfile(busProfile: BusSetting) {
        if let routes = busProfile.routes as? NSMutableSet {
            for busRoute in routes {
                if let route = busRoute as? BusRoute {
                    deleteRouteFromBusProfile(busRoute: route, busProfile: busProfile)
                }
            }
        }
        PersistenceService.context.delete(busProfile)
        
    }
    
    class func changeProfilFavorite(busSetting: BusSetting, profil: Profil) {
        if (profil.favoriteBusSettings?.contains(busSetting))! {
            profil.removeFromFavoriteBusSettings(busSetting)
        } else {
            profil.addToFavoriteBusSettings(busSetting)
        }
        PersistenceService.saveContext()
    }
    
    class func getTrips(busProfile: BusSetting, completion: @escaping (Array<TripRMV>) -> ())  {
        if (busProfile.withDestinations) {
            var tripsRMV:[TripRMV] = [TripRMV]()
            if let routes = busProfile.routes as? NSMutableSet {
                for busRoute in routes {
                    if let route = busRoute as? BusRoute {
                        RMVApiController.getTrips(fromOriginId: (route.origin?.id)!, toDestinationId: (route.destination?.id)!, completion:{ trips in
                            DispatchQueue.main.async {
                                print("---------------Trips without Dest from:",route.origin?.id)
                                for trip in trips.map({TripRMV.toTripRMV(trip: $0, stopLocationOrigin: route.origin!, stopLocationDestination: route.destination!)}) {
                                    //print("Trip: ",trip)
                                }
                                tripsRMV.append(contentsOf: trips.map({TripRMV.toTripRMV(trip: $0, stopLocationOrigin: route.origin!, stopLocationDestination: route.destination!)}))
                                completion(tripsRMV)
                            }
                        })
                    }
                }
            }
            completion(tripsRMV)
        } else {
          print("ERROR")
        }
        
    }
    
    class func getDepartures(busProfile: BusSetting, completion: @escaping (Array<DepartureRMV>) -> ()) {
        if (busProfile.withDestinations) {
            print("ERROR")
        } else {
            var departures:[DepartureRMV] = [DepartureRMV]()
            if let routes = busProfile.routes as? NSMutableSet {
                for busRoute in routes {
                    if let route = busRoute as? BusRoute {
                        RMVApiController.getDepartures(fromOriginId: (route.origin?.id!)!, completion:{ deps in
                            DispatchQueue.main.async {
                                print("---------------Departures without Dest from:",route.origin?.id)
                                for dep in deps.map({DepartureRMV.toDepartureRMV(departure: $0, stopLocation: route.origin!)}) {
                                    //print("Trip: ",dep)
                                }
                                departures.append(contentsOf: deps.map({DepartureRMV.toDepartureRMV(departure: $0, stopLocation: route.origin!)}))
                                completion(departures)
                            }})
                    }
                }
            }
            completion(departures)
        }
    }
    
    class func getMinutesLabel(minutes: Int, futureDeparture: Bool) -> String {
        if !(futureDeparture){
            return "-"+String(minutes)+" min"
        } else {
            return "\(minutes) min"
        }
    }
    
    class func getMinutes(time: Date) -> (minutes :Int, futureDeparture: Bool) {
        let currentDateTime = Date()
        if (currentDateTime<time) {
            let minutes = time.minutes(from: currentDateTime)
            //print("Time current: \(currentDateTime) time bus \(time) minutes \(minutes) future? \(true)")
            return (minutes, true)
        } else if (time>currentDateTime){
            //print(currentDateTime)
            //print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!>")
            //print(time)
            let minutes = currentDateTime.minutes(from: time)
            //print("Time current: \(currentDateTime) time bus \(time) minutes \(minutes) future? \(false)")
            return (minutes, false)
        } else {
            //print("Time current: \(currentDateTime) time bus \(time) minutes \(0) future? \(true)")
            return (0, true)}
       
    }
    
    class func setSelectedColor(minutes: Int, futureDeparture: Bool) -> UIColor {
        if (futureDeparture) {
            if (minutes <= CONFIG.BUSSETTINGS.HIGH_PRIO_TRIP_MINUTES) {
                return UIColor(named: "RED")!
            } else if (minutes > CONFIG.BUSSETTINGS.HIGH_PRIO_TRIP_MINUTES && minutes <= CONFIG.BUSSETTINGS.NORMAL_PRIO_TRIP_MINUTES) {
                return UIColor(named: "YELLOW")!
            }
        }
        return UIColor(named: "GREEN")!
    }
    
    class func addTestBusSettings(){
        let busProfile = BusSetting(context: PersistenceService.context)
        busProfile.title = "Arbeit"
        let busProfile2 = BusSetting(context: PersistenceService.context)
        busProfile2.title = "NichtArbeit"
        
        let route = BusRoute(context: PersistenceService.context)
        let route2 = BusRoute(context: PersistenceService.context)
        let route3 = BusRoute(context: PersistenceService.context)
        
        let originStopLocation = StopLocation(context: PersistenceService.context)
        originStopLocation.name =  "WI Hbf"
        originStopLocation.id = "wiID"
        let destStopLocation = StopLocation(context: PersistenceService.context)
        destStopLocation.name = "Mz Hbf"
        destStopLocation.id = "mzID"
        let destStopLocation2 = StopLocation(context: PersistenceService.context)
        destStopLocation2.name = "Fr Hbf"
        destStopLocation2.id = "frID"
        
        
        route.origin = originStopLocation // wi
        route.destination = destStopLocation // mz
        route2.origin = originStopLocation // wi
        route2.destination = destStopLocation2 //fr
        route3.origin = originStopLocation // wi
        route3.destination = destStopLocation //mz
        
        busProfile2.addToRoutes(route)
        busProfile2.addToRoutes(route2)
        busProfile.addToRoutes(route3)
        
        PersistenceService.saveContext()
    }
    
    
    class func calculateDate(ofTime: String, ofDate: String ) -> Date {
        let inDateFormatter = DateFormatter()
        inDateFormatter.dateFormat = "yyyy-MM-dd"
        let inFormatter = DateFormatter()
        inFormatter.dateFormat = "HH:mm:ss"
        
        
        let date = inDateFormatter.date(from: ofDate)
        let timeDate = inFormatter.date(from: ofTime)
        let calendar = Calendar.current
        
        var dateComponents: DateComponents? = calendar.dateComponents([.year, .month, .day], from: date!)
        
        var component = calendar.dateComponents([.hour, .minute, .second], from: timeDate!)
        component.year = dateComponents?.year
        component.month = dateComponents?.month
        component.day = dateComponents?.day
        Calendar.current.date(from: component)

      
        let finalDate: Date? = calendar.date(from: component)
        //print(finalDate)
        return finalDate!
    }
    
}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the amount of nanoseconds from another date
    func nanoseconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.nanosecond], from: date, to: self).nanosecond ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        if nanoseconds(from: date) > 0 { return "\(nanoseconds(from: date))ns" }
        return ""
    }
    

}
