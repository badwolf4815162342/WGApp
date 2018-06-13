//
//  UserEditVC.swift
//  WGApp
//
//  Created by Anna Abad on 11.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit

class UserEditVC: UIViewController {
    
    var user: User!

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var icon: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = user.name
        mail.text = user.mail
    }

    func save() {
        var changed = false
        if name.text != user.name && name.text != ""{
            user.name = name.text
            changed = true
        }
        if mail.text != user.mail && mail.text != ""{
            user.mail = mail.text
            changed = true
        }
        if changed{
            PersistenceService.saveContext()
        }
        print("save executed in edit")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        save()
    }
}
