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
        
        NotificationCenter.default.addObserver(self, selector: #selector(showUserEdit), name: NSNotification.Name("ShowUserEditMsg"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showUsers), name: NSNotification.Name("BackToUsersMsg"), object: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func edit(_ sender: Any) {
         NotificationCenter.default.post(name: NSNotification.Name("ShowUserEditMsg"), object: nil)
    }
    
    @objc func showUserEdit(notification: NSNotification) {
        performSegue(withIdentifier: "ShowUserEdit", sender: nil)
    }
    
    @objc func showUsers(notification: NSNotification) {
        performSegue(withIdentifier: "BackToUsers", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowUserEdit" {
            if let destinationVC = segue.destination as? UserEditVC {
                destinationVC.user = self.user
            }
        }
    }
    
    func back(sender: UIBarButtonItem) {
        NotificationCenter.default.post(name: NSNotification.Name("BackToUsersMsg"), object: nil)
    }
    
}

