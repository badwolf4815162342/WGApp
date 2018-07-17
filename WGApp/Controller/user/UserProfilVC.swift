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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refresh()
    }
    
    @IBAction func deleteUser(_ sender: UIButton) {
        // alert
        let alert = UIAlertController(title: "Sicher, dass du den Mitbewohner löschen möchtest?", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        // alert button hinzufügen
        let saveAction = UIAlertAction(title: "löschen", style: .default) { (_) in
            print("delete")
            PersistenceService.context.delete(self.user)
            PersistenceService.saveContext()
            self.performSegue(withIdentifier: "segue1DeleteUser", sender: self)
        }
        let cancleAction = UIAlertAction(title: "abbrechen", style: .default) { (_) in }
        
        alert.addAction(saveAction)
        alert.addAction(cancleAction)
        present(alert, animated: true, completion: nil)
    }
    
    func refresh(){
        name.text = user.name
        if let singleUser = user {
            mail.text = singleUser.mail
        }
        if user.profilIcon != nil, let image = UIImage(named: user.profilIcon!) {
            icon.image = image
        } else {
            icon.image = UIImage(named: "info")
            print("Picture of user could not be loaded !!! ") // TODO questionmark image
        }
    }
}

