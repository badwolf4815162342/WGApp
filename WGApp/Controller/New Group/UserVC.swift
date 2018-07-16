//
//  UserVC.swift
//  WGApp
//
//  Created by Anna Abad on 18.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit

class UserVC: UIViewController {
    
    var user: Profil!

    @IBOutlet weak var tabBar: UITabBar!
    
    @IBOutlet weak var profilContainer: UIView!
    @IBOutlet weak var profilEditContainer: UIView!
    @IBOutlet weak var profilFavoritesContainer: UIView!
    @IBOutlet weak var profilMoneyContainer: UIView!
    
    var actContainer: UIView?
    
    var profil: UserProfilVC?
    var edit: UserProfilEditVC?
    var favorites: UserFavoritesVC?
    var money: UserMoneyVC?
    
    var userProp: Profil {
        get{
            return user
        }
        set{
            user = newValue
            profil?.user = user
            edit?.user = user
            favorites?.user = user
            money?.user = user
            
            self.edit?.refresh()
            self.profil?.refresh()
            self.favorites?.refresh()
            self.money?.refresh()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actContainer = profilContainer
        tabBar.delegate = self
    }
    
    // change Profil and Edit
    @IBAction func unwindProfilAndEdit(sender: UIStoryboardSegue) {
        // from Profil to Edit
        if let profil = sender.source as? UserProfilVC {
            changeActViewContainer(destinationContainer: self.profilEditContainer)
            userProp = profil.user
            self.edit?.refresh()
        }
        // from Edit to Profil
        if let edit = sender.source as? UserProfilEditVC {
            print("unwind and set user")
            changeActViewContainer(destinationContainer: self.profilContainer)
            userProp = edit.user
            self.profil?.refresh()
        }
    }
    
    func changeActViewContainer(destinationContainer: UIView){
        UIView.animate(withDuration: 0.5, animations: {
            destinationContainer.alpha = 1
            self.actContainer?.alpha = 0
        })
        actContainer = destinationContainer
    }
    
    
    
    @IBAction func undwind1FromDeleteUser(sender: UIStoryboardSegue){
        self.performSegue(withIdentifier: "segue2DeleteUser", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare")
        if let userProfilVC = segue.destination as? UserProfilVC {
            userProfilVC.user = self.user
            self.profil = userProfilVC
        }
        if let userEditVC = segue.destination as? UserProfilEditVC {
            userEditVC.user = self.user
            self.edit = userEditVC
        }
        if let userFavoritesVC = segue.destination as? UserFavoritesVC {
            userFavoritesVC.user = self.user
            self.favorites = userFavoritesVC
        }
        if let userMoneyVC = segue.destination as? UserMoneyVC {
            userMoneyVC.user = self.user
            self.money = userMoneyVC
        }
    }
}

extension UserVC: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title == "Favoriten" && actContainer != profilFavoritesContainer  {
            self.changeActViewContainer(destinationContainer: self.profilFavoritesContainer)
            self.favorites?.refreshTable()
        } else if (item.title == "Profil" && actContainer != profilContainer) {
            self.changeActViewContainer(destinationContainer: self.profilContainer)
        } else if item.title == "Geld" && actContainer != profilMoneyContainer {
            self.changeActViewContainer(destinationContainer: self.profilMoneyContainer)
        }
    }
}
