//
//  PutzProfilVC.swift
//  WGApp
//
//  Created by Viviane Rehor on 11.07.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit

class PutzProfilVC: UIViewController {

    //var user: Profil!
    
    @IBOutlet weak var tabBar: UITabBar!
    
    @IBOutlet weak var putzProfilEditContainer: UIView!
    @IBOutlet weak var putzProfilCalenderContainer: UIView!
    
    var actContainer: UIView?
    
    var putzProfilEditVC: PutzProfilEditVC?
    var putzProfilCalenderVC: PutzProfilCalenderVC?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actContainer = putzProfilCalenderContainer
        changeActViewContainer(destinationContainer: putzProfilEditContainer)
        tabBar.delegate = self
    }
    

    func changeActViewContainer(destinationContainer: UIView){
        UIView.animate(withDuration: 0.5, animations: {
            self.actContainer?.alpha = 0
            destinationContainer.alpha = 1
        })
        actContainer = destinationContainer
    }
    

}

extension PutzProfilVC: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print(item.title)
        if (item.title == "Putzprofil Einstellungen") {
            self.changeActViewContainer(destinationContainer: self.putzProfilEditContainer)
//            self.favorites?.refreshTable()
        } else if (item.title == "Putzkalender") {
            self.changeActViewContainer(destinationContainer: self.putzProfilCalenderContainer)
            print("refresh \(self.putzProfilCalenderVC)")
            putzProfilCalenderVC?.refresh()
        }
    }
}
