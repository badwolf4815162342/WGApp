//
//  BusSettingsController.swift
//  WGApp
//
//  Created by Viviane Rehor on 15.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import Foundation
import CoreData

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
        } else {
            busRoute.destination = nil
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
    class func replaceBusRouteOfBusProfile(newBusRoute: BusRoute, oldBusRoute: BusRoute, busProfile: BusSettings) -> BusSettings{
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
    
    class func printSettings(busProfile: BusSettings) {
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
    
    class func deleteRouteFromBusProfile(busRoute: BusRoute, busProfile: BusSettings) {
        PersistenceService.context.delete(busRoute)
    }
    
    class func deleteBusProfile(busProfile: BusSettings) {
        if let routes = busProfile.routes as? NSMutableSet {
            for busRoute in routes {
                if let route = busRoute as? BusRoute {
                    deleteRouteFromBusProfile(busRoute: route, busProfile: busProfile)
                }
            }
        }
        PersistenceService.context.delete(busProfile)
        
    }
    
    class func addTestBusSettings(){
        let busProfile = BusSettings(context: PersistenceService.context)
        busProfile.title = "Arbeit"
        let busProfile2 = BusSettings(context: PersistenceService.context)
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
    
}
