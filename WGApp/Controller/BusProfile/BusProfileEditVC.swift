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
    
    var actBusProfile: BusSettings!
    
    var routesForActBusProfile = [BusRoute]()
    
    var currentlyEditingRoute: BusRoute?
    
    var footerView = UIView()
    
    @IBOutlet weak var maxRoutesInfolabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        routesTableView.delegate = self
        routesTableView.dataSource = self
        // not showing empty cells
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        footerView.backgroundColor = UIColor.gray
        routesTableView.tableFooterView = footerView
        // add new row by '+'
        var addButton = UIButton()
        addButton.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        addButton.setTitle("+", for: [])
        footerView.addSubview(addButton)
        addButton.addTarget(self, action: #selector(addNewBusRoute), for: .touchUpInside)
        if actBusProfile == nil { setInitialBusProfile() }
        
        //get Notification if BusProfile changes
        NotificationCenter.default.addObserver(self, selector: #selector(changeBusProfile), name: NSNotification.Name("ShowBusprofileMsg"), object: nil)
        // oberserver to load route edit view user page
        NotificationCenter.default.addObserver(self, selector: #selector(showRouteForEdit), name: NSNotification.Name("ShowRouteMsg"), object: nil)
          
    }
    
    // setNew BusRoute
    @IBAction func unwindToThisView(sender: UIStoryboardSegue) {
        if let busRouteEditVC = sender.source as? BusRouteEditVC {
            print("Unwind from BusRouteEditVC")
            for stop in BusSettingsController.getAllStopLocations() {
                print(stop.name)
            }
            // not edited route but created new one
            if (currentlyEditingRoute == nil) {
                let newRoute = busRouteEditVC.busRoute!
                newRoute.busSetting = actBusProfile
            }
            currentlyEditingRoute = nil
        }
        //BusSettingsController.printSettings(busProfile: actBusProfile)
        if let routesSet = actBusProfile.routes{
            routesForActBusProfile = routesSet.allObjects as! [BusRoute]
            print(routesSet)
            self.routesTableView.reloadData()
        }
    }
    
    @IBAction func saveBusProfile(_ sender: Any) {
        print(actBusProfile.objectID)
        print(actBusProfile.title ?? "title")
        print(actBusProfile.routes?.count ?? "routeslength")
        //TODO: saving title and user
    }
    
    @objc func changeBusProfile(notification: NSNotification) {
        actBusProfile = notification.object as! BusSettings
        titleTextField.text = actBusProfile.title
        
        if let routesSet = actBusProfile.routes{
            routesForActBusProfile = routesSet.allObjects as! [BusRoute]
            print(routesSet)
            self.routesTableView.reloadData()
            // if more than 4 routes -> hide button +
            if (routesForActBusProfile.count >= 4) {
                footerView.isHidden = true
            } else {
                maxRoutesInfolabel.isHidden = true
            }
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
    
    @objc func addNewBusRoute() {
        // load core data into table
        currentlyEditingRoute = nil
        performSegue(withIdentifier: "ShowRoute", sender: nil)
        
    }
    
    func setInitialBusProfile(){
        print("Set initialBusProfile")
        // load core data into table
        let fetchRequest: NSFetchRequest<BusSettings> = BusSettings.fetchRequest()
        do {
            let profiles = try PersistenceService.context.fetch(fetchRequest)
            actBusProfile = profiles[0]
            titleTextField.text = actBusProfile.title
            
            if let routesSet = actBusProfile.routes{
                routesForActBusProfile = routesSet.allObjects as! [BusRoute]
                self.routesTableView.reloadData()
                // if more than 4 routes -> hide button +
                if (routesForActBusProfile.count >= 4) {
                    footerView.isHidden = true
                } else {
                    maxRoutesInfolabel.isHidden = true
                }
            }
        } catch {}
    }
    
}

extension BusProfilEditVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routesForActBusProfile.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let route = routesForActBusProfile[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RouteCell")
        
        let rtCell = cell  as! RouteTableViewCell
        
        rtCell.setRoute(route: route)
        
        return rtCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: NSNotification.Name("ShowRouteMsg"), object: routesForActBusProfile[indexPath.row])
    }
}
