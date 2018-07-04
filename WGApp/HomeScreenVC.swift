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
    
    var users: [User] = []

    @IBOutlet weak var homeNavigationItem: UINavigationItem!
    
    @IBAction func onMoreTabbed() {
        print("TOGGLE SIDE MENUE")
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    func refreshUsers(){
        // load core data into users list
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        do {
            let users = try PersistenceService.context.fetch(fetchRequest)
            self.users = users
            // self.collectionView.reloadData()
        } catch {
            print("core data couldn't be loaded")
        }
    }
    func addRightNavigationBarItems(){
        refreshUsers()
        var items:[UIBarButtonItem] = []
        for user in users{
            let button: UIButton = UIButton(type: .custom)
            button.setImage(UIImage(named: user.profilIcon!), for: .normal)
            button.addTarget(self, action: #selector(switchUser(sender:)), for: .touchUpInside)
            button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            let userButton = UserUIBarButtonItem(customView: button)
            userButton.user = user

            items.append(userButton)
        }
        self.homeNavigationItem.rightBarButtonItems = items
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // DELETE all busprofile Data
        //BusSettingsController.deleteAllData(entity: "BusSettings")
        //BusSettingsController.deleteAllData(entity: "BusRoute")
        //BusSettingsController.deleteAllData(entity: "StopLocation")
        NotificationCenter.default.addObserver(self, selector: #selector(showUserManagement), name: NSNotification.Name("ShowUserManagement"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showBusManagement), name: NSNotification.Name("ShowBusManagement"), object: nil)

        //addRightNavigationBarItems()

        createWGUser()
    }
    
    @objc func switchUser(sender: UserUIBarButtonItem){
        print(sender.user?.name)
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
