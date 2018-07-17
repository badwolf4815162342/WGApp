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
        refreshContent()
        super.viewDidLoad()
    }
   
    func refreshContent(){
        // load core data into collection view
        let fetchRequest: NSFetchRequest<PutzWeekItem> = PutzWeekItem.fetchRequest()
        let fromPredicate = NSPredicate(format: "%@ >= %@", Date() as NSDate)
        let toPredicate = NSPredicate(format: "%@ < %@", (Date().add(days: 7) as NSDate))
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
        fetchRequest.predicate = datePredicate
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let items = try PersistenceService.context.fetch(fetchRequest)
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
        //performSegue(withIdentifier: "ShowUser", sender: people[indexPath.row])
    }
}
