//
//  ViewControllerTest.swift
//  WGApp
//
//  Created by Viviane Rehor on 27.05.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//
import UIKit
import CoreData


class ChooseUserVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var people = [User]()
    
    func refreshContent(){
        // load core data into collection view
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowUser" {
            if let userVC = segue.destination as? UserVC {
                userVC.user = sender as! User
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshContent()
    }
    
    @IBAction func undwind2FromDeleteUser(sender: UIStoryboardSegue){}
    
    @IBAction func onPlusTapped(){
        // alert
        let alert = UIAlertController(title: "Mitbewohner hinzufügen", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
        // name
        alert.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        // mail
        alert.addTextField { (textField) in
            textField.placeholder = "E-Mail Adresse"
            textField.keyboardType = .emailAddress
        }
        // icon
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 300)
        let pickerView = UIUserIconPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
        vc.view.addSubview(pickerView)
        alert.setValue(vc, forKey: "contentViewController")
        
        // alert button hinzufügen
        let saveAction = UIAlertAction(title: "hinzufügen", style: .default) { (_) in
            let name = alert.textFields!.first!.text!
            let mail = alert.textFields!.last!.text!
            let user = User(context: PersistenceService.context)
            user.name = name
            user.mail = mail
            user.profilIcon = pickerView.selectedIconName
            PersistenceService.saveContext()
            
            self.refreshContent()
        }
        let cancleAction = UIAlertAction(title: "abbrechen", style: .default) { (_) in }
        
        alert.addAction(saveAction)
        alert.addAction(cancleAction)
        present(alert, animated: true, completion: nil)
    }
    
}

extension ChooseUserVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
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
        performSegue(withIdentifier: "ShowUser", sender: people[indexPath.row])
    }
}
