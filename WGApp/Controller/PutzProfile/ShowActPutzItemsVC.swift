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
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("items refreshed")
        refreshContent()
    }
   
    func refreshContent(){
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
                   return ($0.weekEndDate as! Date).compare($1.weekEndDate as! Date) == .orderedAscending
                }})
            print("items \(items.count)")
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
        // alert
        var item = items[indexPath.row]
        let alert = UIAlertController(title: "Erledigt?", message: item.getShowString(), preferredStyle: UIAlertControllerStyle.alert)
        
        // alert button hinzufügen
        let saveAction = UIAlertAction(title: "Jap", style: .default) { (_) in
            if !(item.done) {
                item.done = true
                PersistenceService.saveContext()
                self.refreshContent()
            }
        }
        let cancleAction = UIAlertAction(title: "Nö", style: .default) { (_) in
            if (item.done) {
                item.done = false
                PersistenceService.saveContext()
                self.refreshContent()
            }
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancleAction)
        present(alert, animated: true, completion: nil)
    }
}


extension PutzWeekItem {
    
    func getShowString() -> String {
        let outFormatter = DateFormatter()
        outFormatter.locale = NSLocale(localeIdentifier: "de") as Locale!
        outFormatter.dateFormat = "dd.MM.yy"
        var ret = ""
        ret += " \(self.user!.name!): \(self.putzSetting!.title!) \n"
        ret += "Zeiraum: " + outFormatter.string(from: (self.weekStartDay as! Date)) + " bis " + outFormatter.string(from: (self.weekEndDate as! Date))
        return ret
    }
}
