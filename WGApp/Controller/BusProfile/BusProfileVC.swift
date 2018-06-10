//
//  BusProfilViewController.swift
//  WGApp
//
//  Created by Viviane Rehor on 02.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit
import CoreData

class BusProfileVC: UIViewController {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    var busSettings = [BusSettings]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        //addTestBusSettings()
        
        // load core data into table
        let fetchRequest: NSFetchRequest<BusSettings> = BusSettings.fetchRequest()
        do {
            let profiles = try PersistenceService.context.fetch(fetchRequest)
            self.busSettings = profiles
            self.tableView.reloadData()
        } catch {}
        
        for bs in busSettings {
            print(bs.routes!.count)
        }
    }
    
    func addTestBusSettings(){
        let busProfile = BusSettings(context: PersistenceService.context)
        busProfile.title = "Arbeit"
        let busProfile2 = BusSettings(context: PersistenceService.context)
        busProfile2.title = "NichtArbeit"
        
        let route = BusRoute(context: PersistenceService.context)
        let route2 = BusRoute(context: PersistenceService.context)
        
        let originStopLocation = StopLocation(context: PersistenceService.context)
        originStopLocation.name =  "WI Hbf"
        originStopLocation.id = "wiID"
        let destStopLocation = StopLocation(context: PersistenceService.context)
        destStopLocation.name = "Mz Hbf"
        destStopLocation.id = "mzID"
        let destStopLocation2 = StopLocation(context: PersistenceService.context)
        destStopLocation2.name = "Fr Hbf"
        destStopLocation2.id = "frID"
        
        // wi is origin of route
        originStopLocation.addToOriginOfBusRoutes(route)
        // wi ist origin of route2
        originStopLocation.addToOriginOfBusRoutes(route2)
        // mz ist destination of route
        destStopLocation.addToDestinationOfBusRoutes(route)
        // fr ist destination od route 2
        destStopLocation2.addToDestinationOfBusRoutes(route2)
        

        route.origin = originStopLocation // wi
        route.destination = destStopLocation // mz
        route2.origin = originStopLocation // wi
        route2.destination = destStopLocation2 //fr
        
        route.addToRouteOfBusSettings(busProfile)
        route.addToRouteOfBusSettings(busProfile2)
        route2.addToRouteOfBusSettings(busProfile2)

        busProfile2.addToRoutes(route)
        busProfile2.addToRoutes(route2)
        busProfile.addToRoutes(route)
        
        PersistenceService.saveContext()
        self.tableView.reloadData()
    }
    
}

extension BusProfileVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return busSettings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let busProfile = busSettings[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusProfileCell")
        
        let bpCell = cell  as! BusprofileTableViewCell
        
        bpCell.setBusprofile(busSettings: busProfile)
        
        return bpCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: NSNotification.Name("ShowBusprofileMsg"), object: busSettings[indexPath.row])
    }
    
    
    
    
}
