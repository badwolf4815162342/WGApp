//
//  ShowBusDepartureTableVC.swift
//  WGApp
//
//  Created by Viviane Rehor on 29.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit

class ShowBusDepartureTableVC: UIViewController {

    @IBOutlet weak var ofProfileImageView: UIImageView!
    @IBOutlet weak var busProfileName: UILabel!

    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    var myTimer = Timer()
    
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    @IBOutlet weak var showDeparturesTableView: UITableView!
    
    var departures = [DepartureRMV]()
    
    var selectedBusProfile: BusSetting?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showDeparturesTableView.delegate = self
        showDeparturesTableView.dataSource = self
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 0))
        showDeparturesTableView.tableFooterView = footerView
        print("init ShowBusDepartureTableVC")
        
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.activityIndicator.frame = CGRect(x: 300, y: 200, width: 45, height: 45)
        self.activityIndicator.hidesWhenStopped = true
        
        view.addSubview(self.activityIndicator)
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
        if let busProfile = selectedBusProfile {
            busProfileName.text = busProfile.title
            var userIconString = busProfile.ofProfil?.profilIcon
            if userIconString != nil, let image = UIImage(named: userIconString!) {
                ofProfileImageView.image = image
            } else {
                ofProfileImageView.image = UIImage(named: "Bear-icon")
                print("Picture of user could not be loaded !!! ")
            }
            // load core data into table
            self.refreshTable()
            
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
        BusSettingsController.getDepartures(busProfile: selectedBusProfile!, completion:{ rmvDepartues in
            DispatchQueue.main.async {
                self.effectView.removeFromSuperview()
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
        
        //dCell.setDeparture(departureRMV: departure, selectedDepartures: sele)
        
        return dCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //NotificationCenter.default.post(name: NSNotification.Name("ShowBusprofileMsg"), object: busSettings[indexPath.row])
        //selectedBusProfile = busSettings[indexPath.row]
    }
}
