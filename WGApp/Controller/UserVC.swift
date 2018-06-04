//
//  ViewControllerTest.swift
//  WGApp
//
//  Created by Viviane Rehor on 27.05.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit
import CoreData

class UserVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var people = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // oberserver to load single user page
        NotificationCenter.default.addObserver(self, selector: #selector(showUser), name: NSNotification.Name("ShowUserMsg"), object: nil)
        
        // load core data into table
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        do {
            let people = try PersistenceService.context.fetch(fetchRequest)
            self.people = people
            self.tableView.reloadData()
        } catch {}
    }
    
    @objc func showUser(notification: NSNotification) {
        let user = notification.object as! User
        performSegue(withIdentifier: "ShowUser", sender: user)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowUser" {
            if let destinationVC = segue.destination as? SingleUserVC {
                destinationVC.user = sender as! User
            }
        }
    }
    
    @IBAction func onPlusTapped(){
        let alert = UIAlertController(title: "Mitbewohner hinzufügen", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "E-Mail Adresse"
            textField.keyboardType = .emailAddress
        }
        let action = UIAlertAction(title: "hinzufügen", style: .default) { (_) in
            let name = alert.textFields!.first!.text!
            let mail = alert.textFields!.last!.text!
            let user = User(context: PersistenceService.context)
            user.name = name
            user.mail = mail
            PersistenceService.saveContext()
            self.people.append(user)
            self.tableView.reloadData()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
   
}

extension UserVC: UITableViewDelegate, UITableViewDataSource {
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
        NotificationCenter.default.post(name: NSNotification.Name("ShowUserMsg"), object: people[indexPath.row])
    }
    
    
}
