//
//  UserEditVC.swift
//  WGApp
//
//  Created by Anna Abad on 11.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit

class UserProfilEditVC: UIViewController {
    
    var user: User!

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var pickerView: UIUserIconPickerView!
    
    
    override func viewDidLoad() {
        pickerView.setImageSize(imageSize: 130, imageBounds: 150)
        super.viewDidLoad()
        refresh()
    }
    
    func refresh(){
        name.text = user.name
        if let singleUser = user {
            mail.text = singleUser.mail
        }
        pickerView.selectedIconName = user.profilIcon!
    }

    func save() {
        var changed = false
        if name.text != user.name && name.text != ""{
            user.name = name.text
            changed = true
        }
        if let singleUser = user {
            if mail.text != singleUser.mail && mail.text != ""{
                singleUser.mail = mail.text
                changed = true
            }
        }
        if pickerView.selectedIconName != user.profilIcon {
            user.profilIcon = pickerView.selectedIconName
            changed = true
        }
        if changed{
            PersistenceService.saveContext()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveUser"{
            save()
        }
    }
    
}

