//
//  UserVC.swift
//  WGApp
//
//  Created by Anna Abad on 18.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit

class UserVC: UIViewController {
    
    var user: User!

    @IBOutlet weak var tabBar: UITabBar!
    
    @IBOutlet weak var profilContainer: UIView!
    @IBOutlet weak var profilEditContainer: UIView!
    
    var profil: UserProfilVC?
    var edit: UserProfilEditVC?
    
    var userProp: User{
        get{
            return user
        }
        set{
            user = newValue
            profil?.user = user
            edit?.user = user
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.delegate = self
    }
    
    // change Profil and Edit
    @IBAction func unwindProfilAndEdit(sender: UIStoryboardSegue) {
        // from Profil to Edit
        if let profil = sender.source as? UserProfilVC {
            UIView.animate(withDuration: 0.5, animations: {
                self.profilContainer.alpha = 0
                self.profilEditContainer.alpha = 1
            })
            userProp = profil.user
            self.edit?.refresh()
        }
        // from Edit to Profil
        if let edit = sender.source as? UserProfilEditVC {
            print("unwind and set user")
            UIView.animate(withDuration: 0.5, animations: {
                self.profilContainer.alpha = 1
                self.profilEditContainer.alpha = 0
            })
            userProp = edit.user
            self.profil?.refresh()
        }
    }
    
    @IBAction func undwind1FromDeleteUser(sender: UIStoryboardSegue){
        self.performSegue(withIdentifier: "segue2DeleteUser", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let userProfilVC = segue.destination as? UserProfilVC {
            userProfilVC.user = self.user
            self.profil = userProfilVC
        }
        if let userEditVC = segue.destination as? UserProfilEditVC {
            userEditVC.user = self.user
            self.edit = userEditVC
        }
    }
}

extension UserVC: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print(item.title)
    }
}
