//
//  BusProfilEditViewController.swift
//  WGApp
//
//  Created by Viviane Rehor on 02.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit
import CoreData

class BusProfilEditVC: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var routesTableView: UITableView!
    
    public var rmvApiController : RMVApiController = RMVApiController()
    
    private var busSettingsController: BusSettingsController = BusSettingsController()
    
    var busProfile: BusSettings!
    
    var routesForBusProfile = [BusRoute]()
    
    var currentlyEditingRoute: BusRoute?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        routesTableView.delegate = self
        routesTableView.dataSource = self
        if busProfile == nil { setInitialBusProfile() }
        //get Notification if BusProfile changes
        NotificationCenter.default.addObserver(self, selector: #selector(changeBusProfile), name: NSNotification.Name("ShowBusprofileMsg"), object: nil)
        // oberserver to load route edit view user page
        NotificationCenter.default.addObserver(self, selector: #selector(showRouteForEdit), name: NSNotification.Name("ShowRouteMsg"), object: nil)
          
    }
    
    // setNew BusRoute
    @IBAction func unwindToThisView(sender: UIStoryboardSegue) {
        if let busRouteEditVC = sender.source as? BusRouteEditVC {
            let newRoute = busRouteEditVC.busRoute!
            // TODO: When do we want to replace?
            print(newRoute.origin?.name)
            busProfile = BusSettingsController.replaceBusRouteOfBusProfile(newBusRoute: newRoute, oldBusRoute: currentlyEditingRoute!, busProfile: busProfile)
            print(newRoute.origin?.name)
            currentlyEditingRoute = nil
        }
        if let routesSet = busProfile.routes{
            routesForBusProfile = routesSet.allObjects as! [BusRoute]
            print(routesSet)
            self.routesTableView.reloadData()
        }
    }
    
    @IBAction func saveBusProfile(_ sender: Any) {
        print(busProfile.objectID)
        print(busProfile.title ?? "title")
        print(busProfile.routes?.count ?? "routeslength")
        //TODO: saving title and user
    }
    
    @objc func changeBusProfile(notification: NSNotification) {
        busProfile = notification.object as! BusSettings
        titleTextField.text = busProfile.title
        
        if let routesSet = busProfile.routes{
            routesForBusProfile = routesSet.allObjects as! [BusRoute]
            print(routesSet)
            self.routesTableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func showRouteForEdit(notification: NSNotification) {
        let route = notification.object as! BusRoute
        currentlyEditingRoute = route
        performSegue(withIdentifier: "ShowRoute", sender: route)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowRoute" {
            if let destinationVC = segue.destination as? BusRouteEditVC {
                destinationVC.busRoute = sender as? BusRoute
            }
        }
    }
    
    func addNewBusRoute() {
        
    }
    
    func setInitialBusProfile(){
        // load core data into table
        let fetchRequest: NSFetchRequest<BusSettings> = BusSettings.fetchRequest()
        do {
            let profiles = try PersistenceService.context.fetch(fetchRequest)
            busProfile = profiles[0]
            titleTextField.text = busProfile.title
            
            if let routesSet = busProfile.routes{
                routesForBusProfile = routesSet.allObjects as! [BusRoute]
                self.routesTableView.reloadData()
            }
        } catch {}
    }
    
}

extension BusProfilEditVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routesForBusProfile.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let route = routesForBusProfile[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RouteCell")
        
        let rtCell = cell  as! RouteTableViewCell
        
        rtCell.setRoute(route: route)
        
        return rtCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: NSNotification.Name("ShowRouteMsg"), object: routesForBusProfile[indexPath.row])
    }
}
