//
//  ShowActPutzItemsVC.swift
//  WGApp
//
//  Created by Viviane Rehor on 16.07.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit
import CoreData

class ShowActPutzItemsVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var items = [PutzWeekItem]()
    

    override func viewDidLoad() {
        collectionView.delegate = self
        collectionView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(refreshContent), name: NSNotification.Name("RefreshHomeScreenPutzItems"), object: nil)
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        refreshContent()
    }
   
    @objc func refreshContent(){
        // load core data into collection view
        let request: NSFetchRequest<PutzWeekItem> = PutzWeekItem.fetchRequest()
         request.predicate =  NSPredicate(format: "(weekStartDay <= %@) AND (weekEndDate >= %@)", Date() as NSDate, Date() as NSDate)
        request.returnsObjectsAsFaults = false
        do {
            var items = try PersistenceService.context.fetch(request)
            items = items.sorted(by: {
                if $0.done != $1.done { // first, compare by last names
                    return !$0.done && $1.done
                } else { // All other fields are tied, break ties by last name
                    return ($0.weekEndDate! as Date).compare($1.weekEndDate! as Date) == .orderedAscending
                }})
            self.items = items
            self.collectionView.reloadData()
        } catch {
            print("core data couldn't be loaded")
        }
    }


}

extension ShowActPutzItemsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "putzItemCell", for: indexPath) as! PutzItemViewCell
        let putzItem = items[indexPath.row]
        cell.setPutzItem(putzItem: putzItem)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
   
    }
}


extension PutzWeekItem {
    
    func getShowString() -> String {
        let outFormatter = DateFormatter()
        outFormatter.locale = NSLocale(localeIdentifier: "de") as Locale?
        outFormatter.dateFormat = "dd.MM.yy"
        var ret = ""
        if let user = self.user {
             ret += " \(user.name!): \(self.putzSetting!.title!) \n"
        } else {
             ret += " Gelöschter User: \(self.putzSetting!.title!) \n"
        }
        ret += "Zeiraum: " + outFormatter.string(from: (self.weekStartDay! as Date)) + " bis " + outFormatter.string(from: (self.weekEndDate! as Date))
        return ret
    }
}
