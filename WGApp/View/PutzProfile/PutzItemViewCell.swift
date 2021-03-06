//
//  PutzItemViewCell.swift
//  WGApp
//
//  Created by Viviane Rehor on 13.07.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit
import CoreData

class PutzItemViewCell: UICollectionViewCell {

    @IBOutlet weak var checkedImage: UIImageView!
    @IBOutlet weak var putzItemImageView: UIImageView!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var putzProfileTitle: UILabel!
    
    var putzItem:PutzWeekItem?
    
    func setPutzItemFromPutzProfile(putzProfile: PutzSetting, startDate: Date) {
        self.layer.borderColor = UIColor(named: "DARK_GRAY")?.cgColor
        self.layer.borderWidth = 10.0
        let putzItem = getPutzItem(putzProfile: putzProfile, startDate: startDate)
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
        let outFormatter = DateFormatter()
        outFormatter.dateFormat = "dd.MM.yy"
        let request: NSFetchRequest<PutzWeekItem> = PutzWeekItem.fetchRequest()
        request.predicate =  NSPredicate(format: "weekStartDay = %@ AND putzSetting = %@", startDate as NSDate, putzProfile)
        request.returnsObjectsAsFaults = false
        do {
            var items = try PersistenceService.context.fetch(request)
            if (items.count == 1){
                return items[0]
            } else if (items.count == 0){
                //print("ERROR: No than one item for \(String(describing: putzProfile.title)) on date \(outFormatter.string(from: startDate))")
                return nil
            } else {
                print("ERROR: More than one (\(items.count) item for \(String(describing: putzProfile.title)) on date \(outFormatter.string(from: startDate))")
            }
        } catch {
            print("ERROR: core data couldn't be loaded")
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
        }
        putzProfileTitle.text = "Bis: \((outFormatter.string(from: (putzItem.weekEndDate! as Date))))"
        let userIconString = putzItem.user?.profilIcon
        if userIconString != nil, let image = UIImage(named: userIconString!) {
            userImageView.image = image
        } else {
            userImageView.image = UIImage(named: "info")
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
        let deadline = (putzItem.weekEndDate! as Date)
        if (deadline.days(from: Date())+1 <= CONFIG.PUTZSETTINGS.ITEM_DAYS_UNTIL_DEADLINE_RED ) {
            self.backgroundColor = UIColor.init(named: "RED")
        } else if (deadline.days(from: Date())+1 <= CONFIG.PUTZSETTINGS.ITEM_DAYS_UNTIL_DEADLINE_YELLOW ){
            self.backgroundColor = UIColor.init(named: "YELLOW")
        } else if (deadline.days(from: Date())+1 <= CONFIG.PUTZSETTINGS.ITEM_DAYS_UNTIL_DEADLINE_GREEN ){
            self.backgroundColor = UIColor.init(named: "GREEN")
        } else {
            self.backgroundColor = UIColor.init(named: "GRAY")
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                // alert
                if let item = self.putzItem {
                    let alert = UIAlertController(title: "Erledigt?", message: item.getShowString(), preferredStyle: UIAlertControllerStyle.alert)
                    
                    // alert button hinzufügen
                    let saveAction = UIAlertAction(title: "Jap", style: .default) { (_) in
                        if !(item.done) {
                            item.done = true
                            PersistenceService.saveContext()
                            self.setDone(putzItem: item)
                            NotificationCenter.default.post(name: NSNotification.Name("RefreshHomeScreenPutzItems"), object: nil)
                        }
                    }
                    let cancleAction = UIAlertAction(title: "Nö", style: .default) { (_) in
                        if (item.done) {
                            item.done = false
                            PersistenceService.saveContext()
                            self.setDone(putzItem: item)
                            NotificationCenter.default.post(name: NSNotification.Name("RefreshHomeScreenPutzItems"), object: nil)
                        }
                    }
                    alert.addAction(saveAction)
                    alert.addAction(cancleAction)
                    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                    
            } else {
                // animate deselection
            }
        }
        }
        
    }
}
