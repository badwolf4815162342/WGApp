//
//  UIUserIconPickerView.swift
//  WGApp
//
//  Created by Anna Abad on 18.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit

class UIUserIconPickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    private let userIcons:[Image] = [
        Image(named: "Deer-icon"),
        Image(named: "Fish-icon"),
        Image(named: "Penguin-icon"),
        Image(named: "Shark-icon"),
        Image(named: "Chicken-icon"),
        Image(named: "Dolphin-icon"),
        Image(named: "Frog-icon"),
        Image(named: "Gorilla-icon"),
        Image(named: "Crocodile-icon"),
        Image(named: "Kangaroo-icon"),
        Image(named: "Lion-icon"),
        Image(named: "Lizard-icon"),
        Image(named: "Monkey-icon"),
        Image(named: "Mouse-icon"),
        Image(named: "Koala-icon"),
        Image(named: "Bee-icon"),
        Image(named: "Raccoon-icon"),
        Image(named: "Turtle-icon"),
        Image(named: "Rat-icon")
    ]
    
    var imageSize: CGFloat = 50
    var imageBounds: CGFloat = 60
    
    func setImageSize(imageSize: CGFloat, imageBounds: CGFloat){
        self.imageSize = imageSize
        self.imageBounds = imageBounds
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
        self.dataSource = self
    }
    
    var placementAnswer = ""
    
    var selectedIconName:String{
        set {
            placementAnswer = newValue
            setActualImage()
        }
        get {
            if placementAnswer == "" {
                placementAnswer = userIcons[0].name!
            }
            return placementAnswer
        }
    }
    
    func setActualImage(){
        for index in 0...userIcons.count {
            if userIcons[index].name == selectedIconName{
                super.selectRow(index, inComponent: 0, animated: true)
                break
            }
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return userIcons.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return imageBounds
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let iconView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width, height: imageBounds))
        let iconImageView = UIImageView(frame: CGRect(x: (pickerView.bounds.width/2)-(imageSize/2), y: 0, width: imageSize, height: imageSize))
        
        iconImageView.image = userIcons[row].image
        iconView.addSubview(iconImageView)
        
        return iconView
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        placementAnswer = userIcons[row].name!
    }
}
