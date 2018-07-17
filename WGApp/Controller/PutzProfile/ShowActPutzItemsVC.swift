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
            let items = try PersistenceService.context.fetch(request)
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
        let alert = UIAlertController(title: "Erledigt?", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        var item = items[indexPath.row]
        // alert button hinzufügen
        let saveAction = UIAlertAction(title: "Jap", style: .default) { (_) in
            item.done = true
            PersistenceService.saveContext()
            self.refreshContent()
        }
        let cancleAction = UIAlertAction(title: "Nö", style: .default) { (_) in
            item.done = false
            PersistenceService.saveContext()
            self.refreshContent()
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancleAction)
        present(alert, animated: true, completion: nil)
    }
}
