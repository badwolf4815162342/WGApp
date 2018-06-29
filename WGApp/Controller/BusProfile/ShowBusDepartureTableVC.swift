//
//  ShowBusDepartureTableVC.swift
//  WGApp
//
//  Created by Viviane Rehor on 29.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit

class ShowBusDepartureTableVC: UIViewController {

    @IBOutlet weak var busProfileName: UILabel!

    @IBOutlet weak var showDeparturesTableView: UITableView!
    
    var departures = [DepartureRMV]()
    
    var selectedBusProfile: BusSettings?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showDeparturesTableView.delegate = self
        showDeparturesTableView.dataSource = self
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 0))
        showDeparturesTableView.tableFooterView = footerView
        print("init ShowBusDepartureTableVC")
        
        if let busProfile = selectedBusProfile {
            busProfileName.text = busProfile.title
            // load core data into table
            self.refreshTable()
            
        } else {
            busProfileName.text = "No Bus Setting Found"
            print("ERROR: No Bus Setting Found")
        }
        
        
        
    }
    
    func refreshTable(){
        // load core data into table
        BusSettingsController.getDepartures(busProfile: selectedBusProfile!, completion:{ rmvDepartues in
            DispatchQueue.main.async {
                self.departures = rmvDepartues
                self.showDeparturesTableView.reloadData()
            }
        })
    }



}

extension ShowBusDepartureTableVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return departures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let departure = departures[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusDepartureCell")
        
        let dCell = cell  as! BusDepartureTableViewCell
        
        dCell.setDeparture(departureRMV: departure)
        
        return dCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //NotificationCenter.default.post(name: NSNotification.Name("ShowBusprofileMsg"), object: busSettings[indexPath.row])
        //selectedBusProfile = busSettings[indexPath.row]
    }
}
