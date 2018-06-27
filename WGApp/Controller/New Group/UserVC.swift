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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.delegate = self
    }
    
    @IBAction func editBtn(_ sender: Any) {
        self.profilContainer.alpha = 0
        self.profilEditContainer.alpha = 1
        viewWillAppear(true)
    }
    @IBAction func saveBtn(_ sender: Any) {
        self.profilContainer.alpha = 1
        self.profilEditContainer.alpha = 0
    }
    
    @IBAction func showComponent(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.profilContainer.alpha = 1
                self.profilEditContainer.alpha = 0
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.profilContainer.alpha = 0
                self.profilEditContainer.alpha = 1
            })
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let userProfilVC = segue.destination as? UserProfilVC {
            userProfilVC.user = self.user
        }
        if let userVCEdit = segue.destination as? UserProfilEditVC {
            userVCEdit.user = self.user
        }
    }

}

extension UserVC: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print(item.title)
    }
}
