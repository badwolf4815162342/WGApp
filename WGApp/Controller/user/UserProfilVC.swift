//
//  SingleUserVC.swift
//  WGApp
//
//  Created by Anna Abad on 04.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit
import CoreData

class UserProfilVC: UIViewController {
    
    var user: User!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var mail: UILabel!
    @IBOutlet weak var icon: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refresh()
    }
    
    @IBAction func deleteUser(_ sender: UIButton) {
        // alert
        let alert = UIAlertController(title: "Sicher, dass du den Mitbewohner löschen möchtest?", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        // alert button hinzufügen
        let saveAction = UIAlertAction(title: "löschen", style: .default) { (_) in
            
            // delte debts
            let fetchRequestD = NSFetchRequest<NSFetchRequestResult>(entityName: "Debt")
            fetchRequestD.predicate = NSPredicate(format: "creditor = %@", self.user)
            fetchRequestD.predicate = NSPredicate(format: "debtor = %@", self.user)
            fetchRequestD.returnsObjectsAsFaults = false
            do {
                let debts = try PersistenceService.context.fetch(fetchRequestD) as! [Debt]
                for debt in debts {
                    PersistenceService.context.delete(debt)
                }
            } catch{
                print("error when deleting debts")
            }
            // delte purchases
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Purchase")
            fetchRequest.predicate = NSPredicate(format: "buyer = %@", self.user)
            fetchRequest.returnsObjectsAsFaults = false
            do {
                let purchases = try PersistenceService.context.fetch(fetchRequest) as! [Debt]
                for purchase in purchases {
                    PersistenceService.context.delete(purchase)
                }
            } catch{
                print("error when deleting purchases")
            }
            
            PersistenceService.context.delete(self.user)
            PersistenceService.saveContext()
            self.performSegue(withIdentifier: "segue1DeleteUser", sender: self)
        }
        let cancleAction = UIAlertAction(title: "abbrechen", style: .default) { (_) in }
        
        
        alert.addAction(cancleAction)
        alert.addAction(saveAction)
        present(alert, animated: true, completion: nil)
    }
    
    func refresh(){
        name.text = user.name
        if let singleUser = user {
            mail.text = singleUser.mail
        }
        if user.profilIcon != nil, let image = UIImage(named: user.profilIcon!) {
            icon.image = image
        } else {
            icon.image = UIImage(named: "info")
            print("Picture of user could not be loaded !!! ") // TODO questionmark image
        }
    }
}

