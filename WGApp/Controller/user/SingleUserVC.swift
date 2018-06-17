//
//  SingleUserVC.swift
//  WGApp
//
//  Created by Anna Abad on 04.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit

class SingleUserVC: UIViewController {
    
    var user: User!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var mail: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = user.name
        mail.text = user.mail
        if user.profilIcon != nil, let image = UIImage(named: user.profilIcon!) {
            icon.image = image
        } else {
            icon.image = UIImage(named: "Bear-icon")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowUserEdit" {
            let userEditVC = segue.destination as! UserEditVC
                userEditVC.user = self.user
            
        }
    }
    
    @IBAction func didUnwindFromUserEditVC(sender: UIStoryboardSegue) {
        if let userEditVC = sender.source as? UserEditVC {
            self.user = userEditVC.user!
            viewDidLoad()
        }
    }
    
}

