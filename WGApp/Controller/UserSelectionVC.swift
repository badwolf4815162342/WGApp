//
//  UserSelectionVC.swift
//  WGApp
//
//  Created by Viviane Rehor on 05.07.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit
import CoreData

class UserSelectionVC: UIViewController {
    
    var selectedProfil: Profil?

    enum UserSelectionVCType {
        case chooseSingleUser
        case choosePurchaseBuyer
        case chooseMoneyProfil
    }
    
    var dataType: UserSelectionVCType?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var label: UILabel!
    
    var people = [Profil]()
    
    func refreshContent(){
        
        if let type = self.dataType {
            switch type {
            case .chooseMoneyProfil: fallthrough
            case .choosePurchaseBuyer:
                let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
                do {
                    let people = try PersistenceService.context.fetch(fetchRequest)
                    self.people = people
                    self.collectionView.reloadData()
                } catch {
                    print("core data couldn't be loaded")
                }
            case .chooseSingleUser:
                let fetchRequest: NSFetchRequest<Profil> = Profil.fetchRequest()
                do {
                    let people = try PersistenceService.context.fetch(fetchRequest)
                    self.people = people
                    self.collectionView.reloadData()
                } catch {
                    print("core data couldn't be loaded")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        self.label.isHidden = true
        if let type = self.dataType {
            switch type {
            case UserSelectionVCType.chooseSingleUser:
                self.label.isHidden = true
                
            case UserSelectionVCType.choosePurchaseBuyer:
                self.label.isHidden = false
                self.label.text = "Wer zahlt den Einkauf?"
            case .chooseMoneyProfil:
                self.label.isHidden = false
                self.label.text = "Zu wessen Profil möchtest du?"
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.viewWillAppear(true)
        if segue.identifier == "UserChosen" {
            print("dest found")
            
        }
        if segue.identifier == "ShowPurchaseItems" {
            print("prepare show")
            if let purchaseItemsVC = segue.destination as? PurchaseItemsViewController {
                purchaseItemsVC.buyer = sender as! User
            }
        }
        if segue.identifier == "ShowMoneyProfil" {
            if let profilVC = segue.destination as? UserVC {
                profilVC.user = sender as! User
                profilVC.toMoney = true
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        refreshContent()
    }
}


extension UserSelectionVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! UserCollectionViewCell
        cell.icon.image = UIImage(named: people[indexPath.row].profilIcon!)
        cell.name.text = people[indexPath.row].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let type = self.dataType {
            switch type {
            case UserSelectionVCType.chooseSingleUser:
                self.selectedProfil = people[indexPath.row]
                performSegue(withIdentifier: "UnwindToBusProfileEditVC", sender: people[indexPath.row])
            case UserSelectionVCType.choosePurchaseBuyer:
                self.selectedProfil = people[indexPath.row]
                performSegue(withIdentifier: "ShowPurchaseItems", sender: people[indexPath.row])
            case .chooseMoneyProfil:
                self.selectedProfil = people[indexPath.row]
                performSegue(withIdentifier: "ShowMoneyProfil", sender: people[indexPath.row])
            }
        }
        
    }
}
