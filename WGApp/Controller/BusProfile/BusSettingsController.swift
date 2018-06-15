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
    class func saveDestinationStopLocationRMVToBusRoute(rmvStopLocation: StopLocationRMV, busRoute: BusRoute) -> BusRoute{
        if let oldStopLocation = busRoute.destination {
            deleteDestinationStopLocationFromBusRoute(stopLocation: oldStopLocation, busRoute: busRoute)
        }
        // check for already existing stopLocation with same values
        let existingStopLocation = findStopLocationByRMVStopLocation(rmvStopLocation: rmvStopLocation)
        var newStopLocation = StopLocation(context: PersistenceService.context)
        if (existingStopLocation != nil ) {
            newStopLocation = existingStopLocation!
        } else {
            newStopLocation.name = rmvStopLocation.name
            newStopLocation.id = rmvStopLocation.id
        }
        newStopLocation.addToDestinationOfBusRoutes(busRoute)
        busRoute.destination = newStopLocation
        PersistenceService.saveContext()
        return busRoute
    }
    
    /**
     * Deletest old origin from busRoute, but old StopLocation stays in db without
     * connection to busRoute and sets rmvStopLocation as a new StopLocation
     * if there isn't one if the same data, then it sets this one as new origin
     **/
    class func saveOriginStopLocationRMVToBusRoute(rmvStopLocation: StopLocationRMV, busRoute: BusRoute) -> BusRoute {
        // eventuell alte löschen
        if let oldStopLocation = busRoute.origin {
            deleteOriginStopLocationFromBusRoute(stopLocation: oldStopLocation, busRoute: busRoute)
        }
        let existingStopLocation = findStopLocationByRMVStopLocation(rmvStopLocation: rmvStopLocation)
        var newStopLocation = StopLocation(context: PersistenceService.context)
        if (existingStopLocation != nil ) {
            newStopLocation = existingStopLocation!
        } else {
            newStopLocation.name = rmvStopLocation.name
            newStopLocation.id = rmvStopLocation.id
        }
        newStopLocation.addToOriginOfBusRoutes(busRoute)
        busRoute.origin = newStopLocation
        PersistenceService.saveContext()
        return busRoute
    }
    
    class func deleteOriginStopLocationFromBusRoute(stopLocation: StopLocation, busRoute: BusRoute) {
        //let context = PersistenceService.context
        // if stoplocation is not in any other route -> Erstmal nicht löschen!!
        //if (stopLocation.originOfBusRoutes?.count == 0 && stopLocation.destinationOfBusRoutes?.count == 0) {
            
        //}
        busRoute.origin = nil
        stopLocation.removeFromOriginOfBusRoutes(busRoute)
        //if (busRoute.destination == nil) {
        //    deleteBusRoute(busRoute)
        //}
        do {
            try PersistenceService.saveContext()
        } catch {
            print("Failed remove stopLocation from busRoute")
        }
    }
    
    class func deleteDestinationStopLocationFromBusRoute(stopLocation: StopLocation, busRoute: BusRoute) {
        //let context = PersistenceService.context
        // if stoplocation is not in any other route -> Erstmal nicht löschen!!
        //if (stopLocation.originOfBusRoutes?.count == 0 && stopLocation.destinationOfBusRoutes?.count == 0) {
        
        //}
        busRoute.destination = nil
        stopLocation.removeFromDestinationOfBusRoutes(busRoute)
        do {
            try PersistenceService.saveContext()
        } catch {
            print("Failed remove stopLocation from busRoute")
        }
    }
    
    class func findStopLocationByRMVStopLocation(rmvStopLocation: StopLocationRMV) -> StopLocation? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "StopLocation")
        request.predicate = NSPredicate(format: "id = %@", rmvStopLocation.id)
        request.predicate = NSPredicate(format: "name = %@", rmvStopLocation.name)
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

   // func equalRoutes(busRoute: BusRoute, otherBusRoute: BusRoute) -> Bool {
    //     return ( (busRoute.origin == otherBusRoute.origin) && (busRoute.destination == otherBusRoute.destination) )
    //}
    
    /**
    * After editing exissting BusRoute the old one gets deleted and both its StopLocations loose
    * connection to it, the the new one is added to the busProfile
    **/
    class func replaceBusRouteOfBusProfile(newBusRoute: BusRoute, oldBusRoute: BusRoute, busProfile: BusSettings) {
        // replace route
        busProfile.addToRoutes(newBusRoute)
        newBusRoute.addToRouteOfBusSettings(busProfile)
        busProfile.removeFromRoutes(oldBusRoute)
        oldBusRoute.removeFromRouteOfBusSettings(busProfile)
        do {
            try PersistenceService.saveContext()
        } catch {
            print("Failed saving replace Route")
        }
        // unconnect stoplocations
        var origin = StopLocation(context: PersistenceService.context)
        origin = oldBusRoute.origin!
        origin.removeFromOriginOfBusRoutes(oldBusRoute)
        var destination = StopLocation(context: PersistenceService.context)
        destination = oldBusRoute.destination!
        destination.removeFromDestinationOfBusRoutes(oldBusRoute)
        do {
            try PersistenceService.saveContext()
        } catch {
            print("Failed saving unconnecting stopLocation from busRoute")
        }
        // delete oldbusRoute
        let context = PersistenceService.context
        context.delete(oldBusRoute)
        do {
            PersistenceService.saveContext()
        } catch {
            print("Failed deleting busRoute")
        }
        
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
    
}
