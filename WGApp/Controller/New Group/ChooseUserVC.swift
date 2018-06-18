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

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var people = [User]()
    
    func refreshTable(){
        // load core data into table
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        do {
            let people = try PersistenceService.context.fetch(fetchRequest)
            self.people = people
            self.tableView.reloadData()
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
        refreshTable()
    }
  
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
            
            self.refreshTable()
        }
        let cancleAction = UIAlertAction(title: "abbrechen", style: .default) { (_) in }
        
        alert.addAction(saveAction)
        alert.addAction(cancleAction)
        present(alert, animated: true, completion: nil)
    }
   
}

extension ChooseUserVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = people[indexPath.row].name
        cell.detailTextLabel?.text = people[indexPath.row].mail
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(people[indexPath.row].name)
        performSegue(withIdentifier: "ShowUser", sender: people[indexPath.row])
    }
}



