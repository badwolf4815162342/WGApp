//
//  PutzItemViewCell.swift
//  WGApp
//
//  Created by Viviane Rehor on 13.07.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit

class PutzItemViewCell: UICollectionViewCell {

    @IBOutlet weak var checkedImage: UIImageView!
    @IBOutlet weak var putzItemImageView: UIImageView!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var putzProfileTitle: UILabel!
    
    var putzItem:PutzWeekItem?
    
    func setPutzItemFromPutzProfile(putzProfile: PutzSetting, startDate: Date) {
        self.layer.borderColor = UIColor(named: "DARK_GRAY")?.cgColor
        self.layer.borderWidth = 10.0
        var putzItem = getPutzItem(putzProfile: putzProfile, startDate: startDate)
        let outFormatter = DateFormatter()
        outFormatter.dateFormat = "dd.MM.yy"
        if let putzItem = putzItem {
            setPutzItem(putzItem: putzItem)
        } else {
            self.putzProfileTitle.text = "No Item found on date \(outFormatter.string(from: startDate)) for profile \(putzProfile)"
            //self.isHidden = true
        }
    }
    
    func getPutzItem(putzProfile: PutzSetting, startDate: Date) -> PutzWeekItem? {
        for item in putzProfile.weekItems! {
            print("Item of \((item as! PutzWeekItem).user?.name) ond datestart \((item as! PutzWeekItem).weekStartDay)")
            if (startDate == ((item as! PutzWeekItem).weekStartDay! as Date) ) {
                return (item as! PutzWeekItem)
            }
        }
        return nil
    }
    
    func setPutzItem(putzItem: PutzWeekItem){

        let outFormatter = DateFormatter()
        outFormatter.dateFormat = "dd.MM.yy"
        self.putzItem = putzItem
        let putzIconString = putzItem.putzSetting?.profilIcon
        if putzIconString != nil, let image = UIImage(named: putzIconString!) {
            putzItemImageView.image = image
        } else {
            putzItemImageView.image = UIImage(named: "info")
            print("Picture of putzprofile could not be loaded !!! ")
        }
        putzProfileTitle.text = "Bis: \((outFormatter.string(from: (putzItem.weekEndDate! as Date))))"
        let userIconString = putzItem.user?.profilIcon
        if userIconString != nil, let image = UIImage(named: userIconString!) {
            userImageView.image = image
        } else {
            userImageView.image = UIImage(named: "Bear-icon")
            print("Picture of putzprofile could not be loaded !!! ")
        }
        setColor(putzItem: self.putzItem!)
        setDone(putzItem: self.putzItem!)
    }
    
    func setDone(putzItem: PutzWeekItem) {
        if (putzItem.done) {
            checkedImage.isHidden = false
            checkedImage.alpha = 0.9
            self.backgroundColor = UIColor.init(named: "GRAY")
        } else {
            checkedImage.isHidden = true
        }
    }
    
    func setColor(putzItem: PutzWeekItem) {
        let outFormatter = DateFormatter()
        outFormatter.dateFormat = "dd.MM.yy"
        var deadline = (putzItem.weekEndDate! as! Date)
        print("DEADLINE \(outFormatter.string(from: deadline)) days \( deadline.days(from: Date())+1 ) <= \(CONFIG.PUTZSETTINGS.ITEM_DAYS_UNTIL_DEADLINE_GREEN)")
        if (deadline.days(from: Date())+1 <= CONFIG.PUTZSETTINGS.ITEM_DAYS_UNTIL_DEADLINE_RED ) {
            self.backgroundColor = UIColor.init(named: "RED")
        } else if (deadline.days(from: Date())+1 <= CONFIG.PUTZSETTINGS.ITEM_DAYS_UNTIL_DEADLINE_YELLOW ){
            print("DEADLINE yellow")
            self.backgroundColor = UIColor.init(named: "YELLOW")
        } else if (deadline.days(from: Date())+1 <= CONFIG.PUTZSETTINGS.ITEM_DAYS_UNTIL_DEADLINE_GREEN ){
            print("DEADLINE green")
            self.backgroundColor = UIColor.init(named: "GREEN")
        } else {
            self.backgroundColor = UIColor.init(named: "GRAY")
        }
    }

}

extension UIImage {
    func image(alpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: .normal, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
