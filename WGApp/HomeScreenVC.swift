//
//  HomeScreenVC.swift
//  WGApp
//
//  Created by Viviane Rehor on 27.05.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit

class HomeScreenVC: UIViewController {

    @IBAction func onMoreTabbed() {
        print("TOGGLE SIDE MENUE")
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showScreen), name: NSNotification.Name("ShowUsermanagement"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showScreen), name: NSNotification.Name("ShowGeldmanagement"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showScreen), name: NSNotification.Name("ShowBusprofile"), object: nil)
    }
    
    @objc func showScreen() {
        performSegue(withIdentifier: "ShowGeldmanagement", sender: nil)
    }
}
