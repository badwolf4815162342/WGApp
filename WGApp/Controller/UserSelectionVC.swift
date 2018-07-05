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
    }
    
    var dataType: UserSelectionVCType?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var people = [Profil]()
    
    func refreshContent(){
        // load core data into collection view
        let fetchRequest: NSFetchRequest<Profil> = Profil.fetchRequest()
        do {
            let people = try PersistenceService.context.fetch(fetchRequest)
            self.people = people
            self.collectionView.reloadData()
        } catch {
            print("core data couldn't be loaded")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        if let type = dataType {
            //change start view
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.viewWillAppear(true)
        if segue.identifier == "UserChosen" {
            print("dest found")
            
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
                print("setUserAndGoBacks")
                performSegue(withIdentifier: "UnwindToBusProfileEditVC", sender: people[indexPath.row])

            }
        }
        
    }
}
