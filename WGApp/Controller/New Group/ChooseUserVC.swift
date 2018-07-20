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
        
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 400)
        
        let name: UITextField = UITextField(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
        name.placeholder = "Name"
        name.allowsEditingTextAttributes = true
        name.becomeFirstResponder()
        vc.view.addSubview(name)

        let mail: UITextField = UITextField(frame: CGRect(x: 0, y: 50, width: 250, height: 50))
        mail.placeholder = "E-Mail Adresse"
        mail.keyboardType = .emailAddress
        mail.allowsEditingTextAttributes = true
        vc.view.addSubview(mail)
        
        // icon
        let pickerView = UIUserIconPickerView(frame: CGRect(x: 0, y: 100, width: 250, height: 300))
        vc.view.addSubview(pickerView)
        alert.setValue(vc, forKey: "contentViewController")
        
        // alert button hinzufügen
        let saveAction = UIAlertAction(title: "hinzufügen", style: .default) { (_) in
            let name = name.text //alert.textFields!.first!.text!
            let mail = mail.text //alert.textFields!.last!.text!
            let user = User(context: PersistenceService.context)
            user.name = name
            user.mail = mail
            user.profilIcon = pickerView.selectedIconName
            PersistenceService.saveContext()
            
            self.refreshContent()
        }
        let cancleAction = UIAlertAction(title: "abbrechen", style: .default) { (_) in }
        
        
        alert.addAction(cancleAction)
        alert.addAction(saveAction)

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
