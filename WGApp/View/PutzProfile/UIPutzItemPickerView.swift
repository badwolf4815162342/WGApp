//
//  UIPutzItemPickerView.swift
//  WGApp
//
//  Created by Viviane Rehor on 16.07.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit

class UIPutzItemPickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    private let putzIcons:[Image] = [
        Image(named: "008-vacuum"),
        Image(named: "009-mop"),
        Image(named: "010-dusting"),
        Image(named: "015-sink"),
        Image(named: "018-dishwasher"),
        Image(named: "023-toilet"),
        Image(named: "029-glass-cleaning"),
        Image(named: "038-garbage"),
        Image(named: "021-shower"),
        Image(named: "info")
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
                placementAnswer = putzIcons[0].name!
            }
            return placementAnswer
        }
    }
    
    func setActualImage(){
        for index in 0...putzIcons.count-1 {
            if putzIcons[index].name == selectedIconName{
                super.selectRow(index, inComponent: 0, animated: true)
                break
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return putzIcons.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return imageBounds
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let iconView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width, height: imageBounds))
        let iconImageView = UIImageView(frame: CGRect(x: (pickerView.bounds.width/2)-(imageSize/2), y: 0, width: imageSize, height: imageSize))
        
        iconImageView.image = putzIcons[row].image
        iconView.addSubview(iconImageView)
        
        return iconView
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        placementAnswer = putzIcons[row].name!
    }
}
