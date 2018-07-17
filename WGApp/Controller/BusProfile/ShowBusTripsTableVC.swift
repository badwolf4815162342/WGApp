//
//  ShowBusTipsTableVC.swift
//  WGApp
//
//  Created by Viviane Rehor on 29.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit

class ShowBusTripsTableVC: UIViewController {
    
    enum TripsTableType {
        case trip
        case departure
    }

    var tripsTableType: TripsTableType?
    
    @IBOutlet weak var noRoutesLabel: UILabel!
    @IBOutlet weak var ofProfileImage: UIImageView!
    @IBOutlet weak var showTripsTableView: UITableView!
    
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    var myTimer = Timer()
    
    var currentlyReloading = false
    
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    @IBOutlet weak var tableWithDestinationHeaderView: UIView!
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var busProfileName: UILabel!
    var selectedBusProfile: BusSetting?
    
    var trips = [TripRMV]()
    var departures = [DepartureRMV]()
    
    var selectedTrips = [String]()


    override func viewDidLoad() {
        super.viewDidLoad()
        showTripsTableView.delegate = self
        showTripsTableView.dataSource = self
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 0))
        showTripsTableView.tableFooterView = footerView
        
        
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.activityIndicator.frame = CGRect(x: 50, y: 50, width: 45, height: 45)
        self.activityIndicator.hidesWhenStopped = true
        view.addSubview(self.activityIndicator)
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(sender:)))
        self.view.addGestureRecognizer(longPressRecognizer)
    }
    
    func activityIndicator(_ title: String) {
        
        strLabel.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()
        
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 160, height: 46))
        strLabel.text = title
        strLabel.font = .systemFont(ofSize: 14, weight: .medium)
        strLabel.textColor = UIColor(white: 0.9, alpha: 0.7)
        
        //effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2, y: view.frame.midY - strLabel.frame.height/2 , width: 160, height: 46)
        effectView.frame = CGRect(x: 50, y: 50, width: 160, height: 46)
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator.startAnimating()
        
        effectView.contentView.addSubview(activityIndicator)
        effectView.contentView.addSubview(strLabel)
        view.addSubview(effectView)
        UIApplication.shared.keyWindow!.bringSubview(toFront: effectView)
    }
    
    @IBAction func onReloadTapped(_ sender: Any) {
        refreshTable()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear ShowBusTripsTableVC")
        if let busProfile = selectedBusProfile {
            busProfileName.text = busProfile.title
            var userIconString = busProfile.ofProfil?.profilIcon
            if userIconString != nil, let image = UIImage(named: userIconString!) {
                ofProfileImage.image = image
            } else {
                ofProfileImage.image = UIImage(named: "info")
                print("Picture of user could not be loaded !!! ")
            }
            if let type = tripsTableType {
                switch type {
                case .trip:
                    tableHeaderView.isHidden = true
                    tableWithDestinationHeaderView.isHidden = false
                case .departure:
                    tableHeaderView.isHidden = false
                    tableWithDestinationHeaderView.isHidden = true
                }
            }
            if (busProfile.routes?.count == 0) {
                noRoutesLabel.isHidden = false
            } else {
                noRoutesLabel.isHidden = true
            }
        } else {
            busProfileName.text = "No Bus Setting Found"
            print("ERROR: No Bus Setting Found")
        }
        
        
        refreshTable()
        // load core data into table
        self.myTimer = Timer(timeInterval: CONFIG.BUSSETTINGS.BUS_TRIPS_RELOAD_INTERVAL, target: self, selector: #selector(refreshTable), userInfo: nil, repeats: true)
        RunLoop.main.add(self.myTimer, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.myTimer.invalidate()
    }
    
  
    @objc func refreshTable(){
        print("trips \(tripsTableType)")
        if (currentlyReloading) {
            return
        }
        self.activityIndicator("Aktualisieren")
        print("ADD")
        for s in self.selectedTrips {
            print("LONG: \(s)")
        }
        // load core data into table
        if let type = tripsTableType {
            switch type {
            case .trip:
                print("trip")
                BusSettingsController.getTrips(busProfile: selectedBusProfile!, completion:{ rmvTrips in
                    DispatchQueue.main.async {
                        print("trips \(rmvTrips.count)")
                        self.currentlyReloading = true
                        self.trips = rmvTrips
                        self.filterTripList()
                        if (self.trips.count == 0) {
                            print("HERE")
                            self.effectView.removeFromSuperview()
                            self.currentlyReloading = false
                        } else {
                            self.currentlyReloading = false
                            self.effectView.removeFromSuperview()
                        }
                       
                    }
                })
            case .departure:
                tableHeaderView.isHidden = false
                tableWithDestinationHeaderView.isHidden = true
                BusSettingsController.getDepartures(busProfile: selectedBusProfile!, completion:{ rmvDepartues in
                    DispatchQueue.main.async {
                        self.currentlyReloading = true
                        self.departures = rmvDepartues
                        self.filterDepList()
                        if (self.departures.count == 0) {
                            print("HERE")
                            self.effectView.removeFromSuperview()
                            self.currentlyReloading = false
                        } else {
                            self.currentlyReloading = false
                            self.effectView.removeFromSuperview()
                        }

                    }
                })
            }
        }
       
    }
    
    func filterTripList() { // should probably be called sort and not filter
        trips.sort() { $0.routeParts[0].realDepartureTime > $1.routeParts[0].realDepartureTime } // sort the fruit by name
        trips.reverse()
        showTripsTableView.reloadData(); // notify the table view the data has changed
    }
    
    func filterDepList() { // should probably be called sort and not filter
        departures.sort() { $0.realDepartureTime > $1.realDepartureTime } // sort the fruit by name
        departures.reverse()
        showTripsTableView.reloadData(); // notify the table view the data has changed
    }
    
    
    @objc func longPressed(sender: UILongPressGestureRecognizer) {
        if (currentlyReloading) {
            return
        }
        if sender.state == UIGestureRecognizerState.began {
            
            let touchPoint = sender.location(in: self.showTripsTableView)
            if let indexPath = showTripsTableView.indexPathForRow(at: touchPoint) {
                var index: Int?
                var id: String?
                var infoString: String?
                if let type = tripsTableType {
                    switch type {
                    case .trip:
                        var trip = trips[indexPath.row]
                        id = trip.id
                        infoString = trip.getShowString()
                        index = self.selectedTrips.index(of: id!)
                    case .departure:
                        var trip = departures[indexPath.row]
                        id = trip.id
                        infoString = trip.getShowString()
                        index = self.selectedTrips.index(of: id!)
                    }
                }
                var buttonTitle = ""
                var mainTitle = ""
                if let index = index {
                    buttonTitle = "demarkieren"
                    mainTitle = "Bus Trip demarkieren:"
                } else {
                    buttonTitle = "markieren"
                    mainTitle = "Bus Trip markieren:"
                }

                // alert
                let alert = UIAlertController(title: mainTitle, message: infoString!, preferredStyle: UIAlertControllerStyle.alert)
                
                // alert button hinzufügen
                let saveAction = UIAlertAction(title: buttonTitle, style: .default, handler: { (action) -> Void in
                    //print("LONG PRESS row: \(indexPath.row) \(trip.id)")
                    if let index = index {
                        //print("LONG remove: \(trip.id)")
                        self.selectedTrips.remove(at: index)
                    } else {
                        //print("LONG add: \(trip.id)")
                        self.selectedTrips.append(id!)
                    }
                    self.refreshTable()
                })
                
                
                let cancleAction = UIAlertAction(title: "abbrechen", style: .default) { (_) in }
                
                alert.addAction(saveAction)
                alert.addAction(cancleAction)
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
}

extension ShowBusTripsTableVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let type = tripsTableType {
            switch type {
            case .trip:
                return trips.count
            case .departure:
                return departures.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let type = tripsTableType {
            switch type {
            case .trip:
                let trip = trips[indexPath.row]
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "BusTripCell")
                
                let btCell = cell  as! BusTripTableViewCell
                
                btCell.setTrip(tripRMV: trip, selectedTrips: selectedTrips)
                
                return btCell
            case .departure:
                let departure = departures[indexPath.row]
                print("DEPS setDepCell \(departure)")
                let cell = tableView.dequeueReusableCell(withIdentifier: "BusDepartureCell")
                
                let dCell = cell  as! BusDepartureTableViewCell
                
                dCell.setDeparture(departureRMV: departure, selectedDepartures: selectedTrips)
                
                return dCell
            }
        }
        return tableView.dequeueReusableCell(withIdentifier: "BusDepartureCell")!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let type = tripsTableType {
            switch type {
            case .trip:
                var trip = trips[indexPath.row]
                let alert = UIAlertController(title: "Info zur Fahrt", message: trip.getShowString(), preferredStyle: UIAlertControllerStyle.alert)
                
                let cancleAction = UIAlertAction(title: "ok", style: .default) { (_) in }
                
                alert.addAction(cancleAction)
                present(alert, animated: true, completion: nil)
            case .departure:
                var dep = departures[indexPath.row]
                let alert = UIAlertController(title: "Info zur Fahrt", message: dep.getShowString(), preferredStyle: UIAlertControllerStyle.alert)
                
                let cancleAction = UIAlertAction(title: "ok", style: .default) { (_) in }
                
                alert.addAction(cancleAction)
                present(alert, animated: true, completion: nil)
            }
        }
        
    }
    

}
