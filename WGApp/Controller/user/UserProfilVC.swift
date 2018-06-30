//
//  SingleUserVC.swift
//  WGApp
//
//  Created by Anna Abad on 04.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit

class UserProfilVC: UIViewController {
    
    var user: User!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var mail: UILabel!
    @IBOutlet weak var icon: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
    }
    
    func refresh(){
        name.text = user.name
        mail.text = user.mail
        if user.profilIcon != nil, let image = UIImage(named: user.profilIcon!) {
            icon.image = image
        } else {
            icon.image = UIImage(named: "Bear-icon")
            print("Picture of user could not be loaded !!! ")
        }
    }
}

