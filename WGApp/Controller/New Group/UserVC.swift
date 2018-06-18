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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.delegate = self
    }
    
    func showProfil(){
        performSegue(withIdentifier: "ShowUserProfil", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowUserProfil" {
            if let userProfilVC = segue.destination as? UserProfilVC {
                userProfilVC.user = self.user
            }
        }
    }

}

extension UserVC: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print(item.title)
    }
}
