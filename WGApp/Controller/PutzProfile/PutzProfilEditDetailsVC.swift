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
    
    var users: [User] = []
    
    var items:[UIBarButtonItem] = []
    
    var currentlySelectedUsers: [User] = []
    
    @IBOutlet weak var userOrderBar: UIToolbar!
    @IBOutlet weak var userSelectionBar: UIToolbar!
    
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
        if let userSet = PutzprofilTableVC.selectedPutzProfile?.participatingUsers {
            currentlySelectedUsers = userSet.allObjects as! [User]
            addUserSelectionItems()
            if let ordered = userSet as? NSOrderedSet {
                addUserOrderItems(set:ordered)
            }
        }
    }
    
    func addUserSelectionItems(){
        // right: user icons
        
        refreshUsers()
        items = []
        
        for user in users {
            let button: UserUIButton = UserUIButton(type: .custom)
            button.setImage(UIImage(named: user.profilIcon!), for: .normal)
            button.imageView?.contentMode = UIViewContentMode.scaleAspectFit
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 5
            if (currentlySelectedUsers.contains(user)){
                button.layer.borderColor = UIColor.darkGray.cgColor
            } else {
                button.layer.borderColor = UIColor.lightGray.cgColor
            }
            
            button.addTarget(self, action: #selector(toggleUser(sender:)), for: .touchUpInside)
            button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            button.user = user
            
            let barButton = UIBarButtonItem(customView: button)
            
            items.append(barButton)
        }
        self.userSelectionBar.items = items
    }
    
    func addUserOrderItems(set: NSOrderedSet){
        // right: user icons
        var userItems: [UIBarButtonItem] = []
        
        for user in users {
            let imageView: UIImageView = UIImageView()
            imageView.image =  UIImage(named: user.profilIcon!)
            imageView.contentMode = UIViewContentMode.scaleAspectFit
           
            imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            
            let barButton = UIBarButtonItem(customView: imageView)
            
            userItems.append(barButton)
        }
        self.userOrderBar.items = userItems
    }
    
    func refreshUsers(){
        // load core data into users list
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        do {
            let profiles = try PersistenceService.context.fetch(fetchRequest)
            self.users = profiles
            // self.collectionView.reloadData()
        } catch {
            print("core data couldn't be loaded")
        }
    }
    
    
    @objc func toggleUser(sender: UserUIButton){
        print(sender.user?.name)
        
        let index = currentlySelectedUsers.index(of: sender.user as! User)
        if (index != nil) {
            sender.layer.borderColor = UIColor.lightGray.cgColor
            currentlySelectedUsers.remove(at: index!)
        } else {
            currentlySelectedUsers.append(sender.user as! User)
            sender.layer.borderColor = UIColor.darkGray.cgColor
        }
    }
    

    
}
