//
//  PutzProfilVC.swift
//  WGApp
//
//  Created by Viviane Rehor on 11.07.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit

class PutzProfilVC: UIViewController {
    
    static var typeEinst = true

    @IBOutlet weak var tabBar: UITabBar!
    
    @IBOutlet weak var putzProfilEditContainer: UIView!
    @IBOutlet weak var putzProfilCalenderContainer: UIView!
    
    var actContainer: UIView?
    
    var putzProfilEditVC: PutzProfilEditVC?
    var putzProfilCalenderVC: PutzProfilCalenderVC?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (PutzProfilVC.typeEinst) {
            actContainer = putzProfilCalenderContainer
            changeActViewContainer(destinationContainer: putzProfilEditContainer)
        } else {
            actContainer = putzProfilEditContainer
            changeActViewContainer(destinationContainer: putzProfilCalenderContainer)
        }
        PutzProfilVC.typeEinst = true
        tabBar.delegate = self
    }
    

    func changeActViewContainer(destinationContainer: UIView){
        UIView.animate(withDuration: 0.5, animations: {
            self.actContainer?.alpha = 0
            destinationContainer.alpha = 1
        })
        actContainer = destinationContainer
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let putzProfilCalenderVC = segue.destination as? PutzProfilCalenderVC {
            putzProfilCalenderVC.refresh()
            self.putzProfilCalenderVC = putzProfilCalenderVC
        }
    }
    

}

extension PutzProfilVC: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if (item.title == "Putzprofil Einstellungen") {
            self.changeActViewContainer(destinationContainer: self.putzProfilEditContainer)
        } else if (item.title == "Putzplan") {
            self.changeActViewContainer(destinationContainer: self.putzProfilCalenderContainer)
            //self.putzProfilCalenderVC?.refresh()
        }
    }
}
