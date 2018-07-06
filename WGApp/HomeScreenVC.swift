//
//  HomeScreenVC.swift
//  WGApp
//
//  Created by Viviane Rehor on 27.05.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit
import CoreData

class HomeScreenVC: UIViewController {
    
    static var wg: HomeProfil?
    
    static var selectedUser: Profil?
    
    var items:[UIBarButtonItem] = []
    
    var profiles: [Profil] = []

    @IBOutlet weak var homeNavigationItem: UINavigationItem!
    
    /*@IBAction func onMoreTabbed() {
        print("TOGGLE SIDE MENUE")
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }*/
    
    
    func refreshUsers(){
        // load core data into users list
        let fetchRequest: NSFetchRequest<Profil> = Profil.fetchRequest()
        do {
            let profiles = try PersistenceService.context.fetch(fetchRequest)
            self.profiles = profiles
            // self.collectionView.reloadData()
        } catch {
            print("core data couldn't be loaded")
        }
    }
    
    func addNavigationBarItems(){
       
        // left: burger menu
        let moreBtn: UIButton = UIButton(type: .custom)
        moreBtn.setImage(UIImage(named: "burger"), for: .normal)
        moreBtn.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        moreBtn.addTarget(self, action: #selector(more(sender:)), for: .touchUpInside)
        moreBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: moreBtn)
        
        self.homeNavigationItem.leftBarButtonItem = barButton
        
        // right: user icons
        refreshUsers()
        
        for user in profiles {
            let button: UserUIButton = UserUIButton(type: .custom)
            button.setImage(UIImage(named: user.profilIcon!), for: .normal)
            button.imageView?.contentMode = UIViewContentMode.scaleAspectFit
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 5
            button.layer.borderColor = UIColor.lightGray.cgColor
            button.addTarget(self, action: #selector(switchUser(sender:)), for: .touchUpInside)
            button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            button.user = user
            let barButton = UIBarButtonItem(customView: button)

            items.append(barButton)
        }
        self.homeNavigationItem.rightBarButtonItems = items
    }
    
    @objc func more(sender: UIBarButtonItem){
        print("TOGGLE SIDE MENUE")
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // DELETE all busprofile Data
        //BusSettingsController.deleteAllData(entity: "BusSettings")
        //BusSettingsController.deleteAllData(entity: "BusRoute")
        //BusSettingsController.deleteAllData(entity: "StopLocation")
        NotificationCenter.default.addObserver(self, selector: #selector(showUserManagement), name: NSNotification.Name("ShowUserManagement"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showBusManagement), name: NSNotification.Name("ShowBusManagement"), object: nil)

        addNavigationBarItems()

        createWGUser()
        HomeScreenVC.selectedUser = HomeScreenVC.wg
    }
    
    @objc func switchUser(sender: UserUIButton){
        print(sender.user?.name)
        HomeScreenVC.selectedUser = sender.user
        for item in items {
            item.customView?.layer.borderColor = UIColor.lightGray.cgColor
        }
        sender.layer.borderColor = UIColor.darkGray.cgColor
        
        NotificationCenter.default.post(name: NSNotification.Name("globalSelectedUserChanged"), object: nil)
    }
    
    @objc func showUserManagement() {
        performSegue(withIdentifier: "ShowUserManagement", sender: nil)
    }
    
    @objc func showBusManagement() {
        performSegue(withIdentifier: "ShowBusManagement", sender: nil)
    }
    
    func createWGUser () {
        let fetchRequest: NSFetchRequest<HomeProfil> = HomeProfil.fetchRequest()
        do {
            let homes = try PersistenceService.context.fetch(fetchRequest)
            if (homes.count == 0) {
                let home = HomeProfil(context: PersistenceService.context)
                home.name = "WG"
                home.profilIcon = "wg-icon"
                PersistenceService.saveContext()
                HomeScreenVC.wg = home
            } else {
                HomeScreenVC.wg = homes[0]
            }
        } catch {
            print("core data couldn't be loaded")
        }
        
    }
}
