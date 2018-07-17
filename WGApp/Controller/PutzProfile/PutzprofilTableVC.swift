//
//  PutzprofilTableVC.swift
//  WGApp
//
//  Created by Viviane Rehor on 11.07.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit
import CoreData

class PutzprofilTableVC: UIViewController {

    
    static var selectedPutzProfile: PutzSetting?
    
    @IBOutlet weak var tableView: UITableView!
    var putzSettings = [PutzSetting]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 0))
        tableView.tableFooterView = footerView
        
        // load core data into table
        self.refreshTable()

        NotificationCenter.default.addObserver(self, selector: #selector(refreshTable), name: NSNotification.Name("ReloadPutzProfileTable"), object: nil)
    }
    
    
    @IBAction func addPutzProfile(_ sender: Any) {
        
        
        // alert
        let alert = UIAlertController(title: "Titel des neuen PutzProfils angeben:", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
        // titel
        alert.addTextField { (textField) in
            textField.placeholder = "Titel"
        }
        
        // alert button hinzufügen
        let saveAction = UIAlertAction(title: "hinzufügen", style: .default, handler: { (action) -> Void in
            let title = alert.textFields!.first!.text!
            var newPutzSetting = PutzSettingsController.createEmptyPutzSetting(title: title)
            PutzprofilTableVC.selectedPutzProfile = newPutzSetting
            //set User = WG
            PersistenceService.saveContext()
            self.refreshTable()
            NotificationCenter.default.post(name: NSNotification.Name("ShowPutzprofileMsg"), object: newPutzSetting)
        })
        
        let cancleAction = UIAlertAction(title: "abbrechen", style: .default) { (_) in }
        
        alert.addAction(saveAction)
        alert.addAction(cancleAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    @objc func refreshTable(){
        // load core data into table
        let fetchRequest: NSFetchRequest<PutzSetting> = PutzSetting.fetchRequest()
        do {
            let profiles = try PersistenceService.context.fetch(fetchRequest)
            self.putzSettings = profiles
            self.tableView.reloadData()
        } catch {}
    }
    
    
    
    
}

extension PutzprofilTableVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return putzSettings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let putzProfile = putzSettings[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PutzProfileCell")
        
        let ppCell = cell  as! PutzProfileTableViewCell
        
        ppCell.setPutzprofile(putzProfile: putzProfile)
        
        return ppCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: NSNotification.Name("ShowPutzprofileMsg"), object: putzSettings[indexPath.row])
        PutzprofilTableVC.selectedPutzProfile = putzSettings[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let deletedProfile = putzSettings.remove(at: indexPath.row)
        PutzSettingsController.deletePutzProfile(putzProfile: deletedProfile)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        if (PutzprofilTableVC.selectedPutzProfile == deletedProfile ) {
            if (putzSettings.count > 0) {
                PutzprofilTableVC.selectedPutzProfile = putzSettings[0]
            } else {
                PutzprofilTableVC.selectedPutzProfile = nil
            }
            NotificationCenter.default.post(name: NSNotification.Name("ShowInitialPutzProfileMsg"), object: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100;//Choose your custom row height
    }
    
    
    
    
}


