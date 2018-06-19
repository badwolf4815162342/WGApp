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
        BusSettingsController.addTestBusSettings()
        
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
