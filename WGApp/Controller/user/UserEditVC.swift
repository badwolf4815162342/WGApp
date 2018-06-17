//
//  UserEditVC.swift
//  WGApp
//
//  Created by Anna Abad on 11.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit

class UserEditVC: UIViewController {
    
    var placementAnswer = String()
    
    private let userIcons:[Image] = [
        Image(named: "Bat-icon"),
        Image(named: "Bear-icon"),
        Image(named: "Beaver-icon"),
        Image(named: "Bee-icon"),
        Image(named: "Bull-icon"),
        Image(named: "Cat-icon"),
        Image(named: "Chicken-icon")
    ]
    
    var user: User!

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = user.name
        mail.text = user.mail
        
        pickerView.delegate = self
        pickerView.dataSource = self
        setActualImage()
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
        if placementAnswer != user.profilIcon {
            user.profilIcon = placementAnswer
            changed = true
        }
        if changed{
            PersistenceService.saveContext()
        }
    }
    
    func setActualImage(){
        placementAnswer = user.profilIcon!
        for index in 0...userIcons.count {
            if userIcons[index].name == user.profilIcon{
                pickerView.selectRow(index, inComponent: 0, animated: true)
                break
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        save()
    }
}

extension UserEditVC: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return userIcons.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let iconView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width, height: 60))
        let iconImageView = UIImageView(frame: CGRect(x: (pickerView.bounds.width/2)-25, y: 0, width: 50, height: 50))
        
        iconImageView.image = userIcons[row].image
        iconView.addSubview(iconImageView)
        
        return iconView
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        placementAnswer = userIcons[row].name!
    }
}

