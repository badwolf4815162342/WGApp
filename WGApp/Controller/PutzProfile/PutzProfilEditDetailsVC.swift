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

  
    @IBOutlet weak var currentActiveButton: UISwitch!
    @IBOutlet weak var weeksLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var titleTextField: UITextField!
 
    @IBOutlet weak var putzIcon: UIImageView!

    @IBOutlet weak var noPutzProfilesLabel: UILabel!
    
    @IBOutlet weak var userOrderScrollView: UIScrollView!
    @IBOutlet weak var userSelectionScrollView: UIScrollView!
    var users: [User] = []
    
    var currentNumberOfWeeks = 1
    
    var currentlySelectedUsers: [User] = []
    
    var userSelectionStackView = UIStackView()
    var userOrderStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // erstmal gehen wir von routes aus
        noPutzProfilesLabel.isHidden  = true
    
        setInitialPutzProfile()
        //get Notification if BusProfile changes
        NotificationCenter.default.addObserver(self, selector: #selector(changePutzProfile), name: NSNotification.Name("ShowPutzprofileMsg"), object: nil)
        // show first busprofile when deleting one which is selcted
        NotificationCenter.default.addObserver(self, selector: #selector(setInitialPutzProfile), name: NSNotification.Name("ShowInitialPutzProfileMsg"), object: nil)
        
        userSelectionStackView.translatesAutoresizingMaskIntoConstraints = false
        userSelectionStackView.axis = .horizontal
        userSelectionStackView.spacing = 23.0
        userSelectionScrollView.addSubview(userSelectionStackView)
        
        userSelectionScrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[stackView]|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: ["stackView": userSelectionStackView]))
        userSelectionScrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[stackView]|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: ["stackView": userSelectionStackView]))
        
        userOrderStackView.translatesAutoresizingMaskIntoConstraints = false
        userOrderStackView.axis = .horizontal
        userOrderStackView.spacing = 23.0
        userOrderScrollView.addSubview(userOrderStackView)
        
        userOrderScrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[stackView]|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: ["stackView": userOrderStackView]))
        userOrderScrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[stackView]|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: ["stackView": userOrderStackView]))
        
    }
    
    @IBAction func saveChangings(_ sender: Any) {
        PutzprofilTableVC.selectedPutzProfile?.title = titleTextField.text
        PutzprofilTableVC.selectedPutzProfile?.aktiv = currentActiveButton.isOn
        PutzprofilTableVC.selectedPutzProfile?.repeatEveryXWeeks = Int64(Int(stepper.value))
        PutzprofilTableVC.selectedPutzProfile?.participatingUsers = NSSet(array : currentlySelectedUsers)
        if (PutzprofilTableVC.selectedPutzProfile?.aktiv)! {
            PutzSettingsController.calculateOrder(putzProfile: PutzprofilTableVC.selectedPutzProfile!)
        }
        setInitValuesOfProfil()
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
    
    @IBAction func onWeekManipulated(_ sender: Any) {
        var number = Int(stepper.value)
        setWeekLabel(number: number)
        currentNumberOfWeeks = Int(stepper.value)
    }
    
    func setWeekLabel(number: Int) {
        if (number == 1) {
            weeksLabel.text = CONFIG.PUTZSETTINGS.ONE_WEEK_REPEAT_LABEL_TEXT
        } else {
            var formattedString = String(format: CONFIG.PUTZSETTINGS.X_WEEK_REPEAT_LABEL_TEXT, number)
            weeksLabel.text = formattedString
        }
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
        userOrderStackView.subviews.forEach { $0.removeFromSuperview() }
        userSelectionStackView.subviews.forEach { $0.removeFromSuperview() }
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
            addUserOrderItems(set:userSet)
        }
        setWeekLabel(number: Int((PutzprofilTableVC.selectedPutzProfile?.repeatEveryXWeeks)!))
        currentActiveButton.isOn = (PutzprofilTableVC.selectedPutzProfile?.aktiv)!
        
    }
    
    func addUserSelectionItems(){
        // right: user icons
        refreshUsers()
        
        for user in users {
            let button: UserUIButton = UserUIButton(type: .custom)
            button.setImage(UIImage(named: user.profilIcon!), for: .normal)
            button.imageView?.contentMode = UIViewContentMode.scaleAspectFit
            button.imageView?.backgroundColor = UIColor.cyan

            button.layer.borderWidth = 2
            button.layer.cornerRadius = 5
            if (currentlySelectedUsers.contains(user)){
                button.layer.borderColor = UIColor.darkGray.cgColor
            } else {
                button.layer.borderColor = UIColor.lightGray.cgColor
            }
            
            button.addTarget(self, action: #selector(toggleUser(sender:)), for: .touchUpInside)
            button.user = user

            button.translatesAutoresizingMaskIntoConstraints = false
            self.userSelectionStackView.addArrangedSubview(button)
            // all constaints
            let widthContraints =  NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
            let heightContraints = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
            NSLayoutConstraint.activate([heightContraints,widthContraints])
        }
    }
    
    func addUserOrderItems(set: NSSet){
        if (PutzprofilTableVC.selectedPutzProfile?.aktiv)! {
            let users: [User] = PutzSettingsController.getOrderedUsers(ofProfile: PutzprofilTableVC.selectedPutzProfile!)
            for user in users {
                print(user.name)
            }
            for user in users {
                let imageView: UIImageView = UIImageView()
                imageView.image = UIImage(named: user.profilIcon!)
                imageView.contentMode = UIViewContentMode.scaleAspectFit

                imageView.translatesAutoresizingMaskIntoConstraints = false
                self.userOrderStackView.addArrangedSubview(imageView)
                // all constaints
                let widthContraints =  NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
                let heightContraints = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
                NSLayoutConstraint.activate([heightContraints,widthContraints])
            }
        }
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


extension NSSet {
    func toArray<T>() -> [T] {
        let array = self.map({ $0 as! T})
        return array
    }
}
