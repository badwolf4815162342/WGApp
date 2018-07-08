//
//  ShowBusTipsTableVC.swift
//  WGApp
//
//  Created by Viviane Rehor on 29.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit

class ShowBusTripsTableVC: UIViewController {
    
    @IBOutlet weak var ofProfileImage: UIImageView!
    @IBOutlet weak var showTripsTableView: UITableView!
    
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    var myTimer = Timer()
    
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    @IBOutlet weak var busProfileName: UILabel!
    var selectedBusProfile: BusSetting?
    
    var trips = [TripRMV]()
    
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
        
        effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2, y: view.frame.midY - strLabel.frame.height/2 , width: 160, height: 46)
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator.startAnimating()
        
        effectView.contentView.addSubview(activityIndicator)
        effectView.contentView.addSubview(strLabel)
        view.addSubview(effectView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear ShowBusTripsTableVC")
        if let busProfile = selectedBusProfile {
            busProfileName.text = busProfile.title
            var userIconString = busProfile.ofProfil?.profilIcon
            if userIconString != nil, let image = UIImage(named: userIconString!) {
                ofProfileImage.image = image
            } else {
                ofProfileImage.image = UIImage(named: "Bear-icon")
                print("Picture of user could not be loaded !!! ")
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
        self.activityIndicator("Aktualisieren")
        // load core data into table
        BusSettingsController.getTrips(busProfile: selectedBusProfile!, completion:{ rmvTrips in
            DispatchQueue.main.async {
                self.effectView.removeFromSuperview()
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
    
    
    @objc func longPressed(sender: UILongPressGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.began {
            
            let touchPoint = sender.location(in: self.view)
            if let indexPath = showTripsTableView.indexPathForRow(at: touchPoint) {
                var trip = trips[indexPath.row]
                for s in self.selectedTrips {
                    //print("LONG: \(s)")
                }
                //print("LONG PRESS row: \(indexPath.row) \(trip.id)")
                let index = selectedTrips.index(of: trip.id)
                if let index = index {
                    //print("LONG remove: \(trip.id)")
                    selectedTrips.remove(at: index)
                } else {
                    //print("LONG add: \(trip.id)")
                    selectedTrips.append(trip.id)
                }
                refreshTable()
            }
        }
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
        
        btCell.setTrip(tripRMV: trip, selectedTrips: selectedTrips)
        
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
