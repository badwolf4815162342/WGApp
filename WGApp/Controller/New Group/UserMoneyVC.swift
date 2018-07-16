//
//  UserMoneyVC.swift
//  WGApp
//
//  Created by Anna Abad on 15.07.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit

class UserMoneyVC: UIViewController {

    var user: Profil!
    
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var purchaseList: UITableView!
    @IBOutlet weak var debtList: UITableView!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func refresh(){
        name.text = user.name
        if user.profilIcon != nil, let image = UIImage(named: user.profilIcon!) {
            userIcon.image = image
        } else {
            userIcon.image = UIImage(named: "Bear-icon") // TODO questionmark image
            print("Picture of user could not be loaded !!! ")
        }
    }
    


    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
    }

}
