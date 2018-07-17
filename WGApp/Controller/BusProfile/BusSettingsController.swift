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
    
    /**
     * Origin of Route deletion
     **/
    class func deleteOriginStopLocationFromBusRoute(stopLocation: StopLocation, busRoute: BusRoute) {
        busRoute.origin = nil
        PersistenceService.saveContext()
    }
    
    /**
     * Destination of Route deletion
     **/
    class func deleteDestinationStopLocationFromBusRoute(stopLocation: StopLocation, busRoute: BusRoute) {
        busRoute.destination = nil
        PersistenceService.saveContext()
    }
    
    /**
     * find stopLocation to not create two stop location with same values
     **/
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
                    return results[0] as? StopLocation
                } else if (results.count > 1) {
                    print("ERROR: More than one StopLocation in DB with same values")
                } else {
                    return nil
                }
            }
        } catch {
            print("ERROR: Failed fetch for specific stoplocation")
        }
        return nil
    }
    
    /**
     * get StopLocation in DB fitting RMVStopLocation from API
     **/
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
        return busProfile
        
    }
    
    /**
     * Delete AllData of One Entity by String
     **/
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
            print("ERROR: Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    

    /**
     * Get all saved stoplocations for Textfieldproposals
     **/
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
    
    /**
     * Delete single route of busprofile
     **/
    class func deleteRouteFromBusProfile(busRoute: BusRoute, busProfile: BusSetting) {
        PersistenceService.context.delete(busRoute)
    }
    
    /**
     * delete busprofile and all routes but not stoplocations
     **/
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
    
    /**
     * add bussetting to favorites of userProfile
     **/
    class func changeProfilFavorite(busSetting: BusSetting, profil: Profil) {
        if (profil.favoriteBusSettings?.contains(busSetting))! {
            profil.removeFromFavoriteBusSettings(busSetting)
        } else {
            profil.addToFavoriteBusSettings(busSetting)
        }
        PersistenceService.saveContext()
    }
    
    /**
     * Get all trips of all routes per busprofile
     **/
    class func getTrips(busProfile: BusSetting, completion: @escaping (Array<TripRMV>) -> ())  {
        if (busProfile.withDestinations) {
            var tripsRMV:[TripRMV] = [TripRMV]()
            if let routes = busProfile.routes as? NSMutableSet {
                for busRoute in routes {
                    if let route = busRoute as? BusRoute {
                        RMVApiController.getTrips(fromOriginId: (route.origin?.id)!, toDestinationId: (route.destination?.id)!, completion:{ trips in
                            DispatchQueue.main.async {
                                for _ in trips.map({TripRMV.toTripRMV(trip: $0, stopLocationOrigin: route.origin!, stopLocationDestination: route.destination!)}) {
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
    
    /**
     * Get all departures of all routes per busprofile
     **/
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
                                for _ in deps.map({DepartureRMV.toDepartureRMV(departure: $0, stopLocation: route.origin!)}) {
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
    
    /**
     * Get information how many minutes until bus departs as string
     **/
    class func getMinutesLabel(minutes: Int, futureDeparture: Bool) -> String {
        if !(futureDeparture){
            return "-"+String(minutes)+" min"
        } else {
            return "\(minutes) min"
        }
    }
    
    /**
     * Get information how many minutes until bus departs as int
     * and information if its in future or past
     **/
    class func getMinutes(time: Date) -> (minutes :Int, futureDeparture: Bool) {
        let currentDateTime = Date()
        if (currentDateTime<time) {
            let minutes = time.minutes(from: currentDateTime)
            return (minutes, true)
        } else if (time>currentDateTime){
            let minutes = currentDateTime.minutes(from: time)
            return (minutes, false)
        } else {
            return (0, true)}
       
    }
    
    /**
     * Select colour of marked trip/departure
     **/
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
    
    /**
     * calculate dte from time and date string
     **/
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
        
        let finalDate: Date? = calendar.date(from: component)
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
