//
//  ShowBusTipsTableVC.swift
//  WGApp
//
//  Created by Viviane Rehor on 29.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit

class ShowBusTripsTableVC: UIViewController {
    
    @IBOutlet weak var showTripsTableView: UITableView!
    
    @IBOutlet weak var busProfileName: UILabel!
    var selectedBusProfile: BusSettings?
    
    var trips = [TripRMV]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        showTripsTableView.delegate = self
        showTripsTableView.dataSource = self
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 0))
        showTripsTableView.tableFooterView = footerView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear ShowBusTripsTableVC")
        if let busProfile = selectedBusProfile {
            busProfileName.text = busProfile.title
        } else {
            busProfileName.text = "No Bus Setting Found"
            print("ERROR: No Bus Setting Found")
        }
        // load core data into table
        self.refreshTable()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func reloadTrips(_ sender: Any) {
        refreshTable()
    }

  
    func refreshTable(){
        // load core data into table
        BusSettingsController.getTrips(busProfile: selectedBusProfile!, completion:{ rmvTrips in
            DispatchQueue.main.async {
                self.trips = rmvTrips
                self.filterList()
            }
        })
    }
    
    func filterList() { // should probably be called sort and not filter
        trips.sort() { $0.routeParts[0].realDepartureTime > $1.routeParts[0].realDepartureTime } // sort the fruit by name
        trips.reverse()
        showTripsTableView.reloadData(); // notify the table view the data has changed
    }
    
    
    
    
}

extension ShowBusTripsTableVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let trip = trips[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusTripCell")
        
        let btCell = cell  as! BusTripTableViewCell
        
        btCell.setTrip(tripRMV: trip)
        
        return btCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var trip = trips[indexPath.row]
        let alert = UIAlertController(title: "Info zur Fahrt", message: trip.getShowString(), preferredStyle: UIAlertControllerStyle.alert)
        
        let cancleAction = UIAlertAction(title: "ok", style: .default) { (_) in }

        alert.addAction(cancleAction)
        present(alert, animated: true, completion: nil)
    }
    

}
