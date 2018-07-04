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
 
    @IBOutlet weak var withDestinations: UISwitch!
    @IBOutlet weak var titleTextField: UITextField!
    
    
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var routesTableView: UITableView!
    
    public var rmvApiController : RMVApiController = RMVApiController()
    
    private var busSettingsController: BusSettingsController = BusSettingsController()
    
    var routesForActBusProfile = [BusRoute]()
    
    var currentlyEditingRoute: BusRoute?
    
    
    var profilForBusSetting: Profil?
    
    var footerView = UIView()
    
    @IBOutlet weak var noRoutesLabel: UILabel!
    @IBOutlet weak var maxRoutesInfolabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // erstmal gehen wir von routes aus
        noRoutesLabel.isHidden  = true
        routesTableView.delegate = self
        routesTableView.dataSource = self
        // not showing empty cells
        footerView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        footerView.backgroundColor = UIColor.gray
        routesTableView.tableFooterView = footerView
        // add new row by '+'
        var addButton = UIButton()
        addButton.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        addButton.setTitle("+", for: [])
        footerView.addSubview(addButton)
        addButton.addTarget(self, action: #selector(addNewBusRoute), for: .touchUpInside)
        setInitialBusProfile()
        //get Notification if BusProfile changes
        NotificationCenter.default.addObserver(self, selector: #selector(changeBusProfile), name: NSNotification.Name("ShowBusprofileMsg"), object: nil)
        // oberserver to load route edit view user page
        NotificationCenter.default.addObserver(self, selector: #selector(showRouteForEdit), name: NSNotification.Name("ShowRouteMsg"), object: nil)
        // show first busprofile when deleting one which is selcted
        NotificationCenter.default.addObserver(self, selector: #selector(setInitialBusProfile), name: NSNotification.Name("ShowInitialBusProfileMsg"), object: nil)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(profilForBusSetting)
        if let profile = profilForBusSetting {
            BusProfileVC.selectedBusProfile?.ofProfil = profile
        }
    }

    
    @IBAction func withDestinationsChanged(_ sender: Any) {
        if (withDestinations.isOn) {
            BusProfileVC.selectedBusProfile?.withDestinations = true
            //destinationLocationTextField.isHidden = false
            //destinationLabel.text = "Ziel"
            if let routes = BusProfileVC.selectedBusProfile?.routes as? NSMutableSet {
                for busRoute in routes {
                    if let route = busRoute as? BusRoute {
                        route.withDestination = true
                    }
                }
            }
        } else {
            BusProfileVC.selectedBusProfile?.withDestinations = false
            if let routes = BusProfileVC.selectedBusProfile?.routes as? NSMutableSet {
                for busRoute in routes {
                    if let route = busRoute as? BusRoute {
                        route.withDestination = false
                    }
                }
            }
            //destinationLocationTextField.selectedStopLocation = nil
            //destinationLocationTextField.isHidden = true
            //destinationLabel.text = "Route ohne Ziel"
        }
        PersistenceService.saveContext()
        self.routesTableView.reloadData()
        
    }
    // setNew BusRoute
    @IBAction func unwindToThisView(sender: UIStoryboardSegue) {
        if let busRouteEditVC = sender.source as? BusRouteEditVC {
            print("Unwind from BusRouteEditVC")
            // not edited route but created new one
            if (currentlyEditingRoute == nil) {
                let newRoute = busRouteEditVC.busRoute!
                newRoute.busSetting = BusProfileVC.selectedBusProfile
            }
            currentlyEditingRoute = nil
        }
        if let chooseUserVC = sender.source as? ChooseUserVC {
            print("Unwind from ChooseUserVC")
            print(BusProfileVC.selectedBusProfile?.ofProfil?.name)
        }
        //BusSettingsController.printSettings(busProfile: actBusProfile)
        if let routesSet = BusProfileVC.selectedBusProfile?.routes {
            routesForActBusProfile = routesSet.allObjects as! [BusRoute]
            print(routesSet)
            self.routesTableView.reloadData()
            checkReachedMaxRoutes()
        }
        
    }
    

    
    @IBAction func saveBusProfile(_ sender: Any) {
        print(BusProfileVC.selectedBusProfile?.objectID)
        print(BusProfileVC.selectedBusProfile?.title ?? "title")
        print(BusProfileVC.selectedBusProfile?.routes?.count ?? "routeslength")
        //TODO: saving title and user
    }
    
    @objc func changeBusProfile(notification: NSNotification) {
        BusProfileVC.selectedBusProfile = notification.object as! BusSettings
        titleTextField.text = BusProfileVC.selectedBusProfile?.title
        var userIconString = BusProfileVC.selectedBusProfile?.ofProfil?.profilIcon
        if userIconString != nil, let image = UIImage(named: userIconString!) {
            userIcon.image = image
        } else {
            userIcon.image = UIImage(named: "Bear-icon")
            print("Picture of user could not be loaded !!! ")
        }
        var subViews = self.view.subviews
        for v in subViews {
            v.isHidden = false
        }
        noRoutesLabel.isHidden = true
        withDestinations.isOn = (BusProfileVC.selectedBusProfile?.withDestinations)!
        if let routesSet = BusProfileVC.selectedBusProfile?.routes{
            routesForActBusProfile = routesSet.allObjects as! [BusRoute]
            print(routesSet)
            self.routesTableView.reloadData()
            checkReachedMaxRoutes()
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
                destinationVC.withDestinations = BusProfileVC.selectedBusProfile?.withDestinations
            }
        }
        if segue.identifier == "ChooseProfile" {
            if let destinationVC = segue.destination as? ChooseUserVC {
                print("Choose User")
                destinationVC.dataType = ChooseUserVC.ChooseUserVCType.chooseUser
            }
        }
    }
    
    @objc func addNewBusRoute() {
        // load core data into table
        currentlyEditingRoute = nil
        performSegue(withIdentifier: "ShowRoute", sender: nil)
        
    }
    
    @objc func setInitialBusProfile(){
        print("Set initialBusProfile")
        // load core data into table
        if let profile = BusProfileVC.selectedBusProfile {
            print(profile.title! + "found")
            titleTextField.text = profile.title
            withDestinations.isOn = profile.withDestinations
            var userIconString = profile.ofProfil?.profilIcon
            if userIconString != nil, let image = UIImage(named: userIconString!) {
                userIcon.image = image
            } else {
                userIcon.image = UIImage(named: "Bear-icon")
                print("Picture of user could not be loaded !!! ")
            }
            if let routesSet = profile.routes{
                routesForActBusProfile = routesSet.allObjects as! [BusRoute]
                self.routesTableView.reloadData()
                checkReachedMaxRoutes()
            }
        } else {
            let fetchRequest: NSFetchRequest<BusSettings> = BusSettings.fetchRequest()
            do {
                let profiles = try PersistenceService.context.fetch(fetchRequest)
                if (profiles.count <= 0) {
                    var subViews = self.view.subviews
                    for v in subViews {
                        v.isHidden = true
                    }
                    noRoutesLabel.isHidden = false
                } else {
                    BusProfileVC.selectedBusProfile = profiles[0]
                    var userIconString = BusProfileVC.selectedBusProfile?.ofProfil?.profilIcon
                    if userIconString != nil, let image = UIImage(named: userIconString!) {
                        userIcon.image = image
                    } else {
                        userIcon.image = UIImage(named: "Bear-icon")
                        print("Picture of user could not be loaded !!! ")
                    }
                    titleTextField.text = BusProfileVC.selectedBusProfile?.title
                    withDestinations.isOn = (BusProfileVC.selectedBusProfile?.withDestinations)!
                    if let routesSet = BusProfileVC.selectedBusProfile?.routes{
                        routesForActBusProfile = routesSet.allObjects as! [BusRoute]
                        self.routesTableView.reloadData()
                        checkReachedMaxRoutes()
                    }
                }
            } catch {}
        }
        
    }
       
    
    func checkReachedMaxRoutes () {
        // if more than 4 routes -> hide button +
        if (routesForActBusProfile.count >= 4) {
            footerView.isHidden = true
            maxRoutesInfolabel.isHidden = false
        } else {
            footerView.isHidden = false
            maxRoutesInfolabel.isHidden = true
        }
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let deletedRoute = routesForActBusProfile.remove(at: indexPath.row)
        BusSettingsController.deleteRouteFromBusProfile(busRoute: deletedRoute, busProfile: BusProfileVC.selectedBusProfile!)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        checkReachedMaxRoutes()
    }
}
