//
//  PutzProfilEditDetailsVC.swift
//  WGApp
//
//  Created by Viviane Rehor on 11.07.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit
import CoreData

class PutzProfilEditDetailsVC: UIViewController {

  
    @IBOutlet weak var titleTextField: UITextField!
 
    @IBOutlet weak var putzIcon: UIImageView!

    @IBOutlet weak var noPutzProfilesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // erstmal gehen wir von routes aus
        noPutzProfilesLabel.isHidden  = true
    
        setInitialPutzProfile()
        //get Notification if BusProfile changes
        NotificationCenter.default.addObserver(self, selector: #selector(changePutzProfile), name: NSNotification.Name("ShowPutzprofileMsg"), object: nil)
        // show first busprofile when deleting one which is selcted
        NotificationCenter.default.addObserver(self, selector: #selector(setInitialPutzProfile), name: NSNotification.Name("ShowInitialPutzProfileMsg"), object: nil)
        
    }
    
    @objc func changePutzProfile(notification: NSNotification) {
        PutzprofilTableVC.selectedPutzProfile = notification.object as! PutzSetting
        setInitValuesOfProfil()
        var subViews = self.view.subviews
        for v in subViews {
            v.isHidden = false
        }
        noPutzProfilesLabel.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @objc func setInitialPutzProfile(){
        print("Set initialPutzProfile")
        // load core data into table
        if let profile = PutzprofilTableVC.selectedPutzProfile {
            //print(profile.title! + "found")
            setInitValuesOfProfil()
        } else {
            let fetchRequest: NSFetchRequest<PutzSetting> = PutzSetting.fetchRequest()
            do {
                let profiles = try PersistenceService.context.fetch(fetchRequest)
                if (profiles.count <= 0) {
                    var subViews = self.view.subviews
                    for v in subViews {
                        v.isHidden = true
                    }
                    noPutzProfilesLabel.isHidden = false
                } else {
                    noPutzProfilesLabel.isHidden = true
                    PutzprofilTableVC.selectedPutzProfile = profiles[0]
                    setInitValuesOfProfil()
                }
            } catch {}
        }
        
    }
    
    func setInitValuesOfProfil() {
        titleTextField.text = PutzprofilTableVC.selectedPutzProfile?.title
        var profilIconString = PutzprofilTableVC.selectedPutzProfile?.profilIcon
        if profilIconString != nil, let image = UIImage(named: profilIconString!) {
            putzIcon.image = image
        } else {
            putzIcon.image = UIImage(named: "Fish-icon")
            print("Picture of putzprofile could not be loaded !!! ")
        }
    }

    
}
