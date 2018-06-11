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
    
    var placementAnswer = String()
    
    private let userIcons:[Image] = [
        Image(named: "Bat-icon"),
        Image(named: "Bear-icon"),
        Image(named: "Beaver-icon"),
        Image(named: "Bee-icon"),
        Image(named: "Bull-icon"),
        Image(named: "Cat-icon"),
        Image(named: "Chicken-icon")
    ]

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
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
        } catch {
            print("core data couldn't be loaded")
        }
        
        // init placementAnswer
        placementAnswer = userIcons[0].name!
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
        // alert
        let alert = UIAlertController(title: "Mitbewohner hinzufügen", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        // alert add name
        alert.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        // alert add mail
        alert.addTextField { (textField) in
            textField.placeholder = "E-Mail Adresse"
            textField.keyboardType = .emailAddress
        }
        // alert add icon
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 300)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
        pickerView.delegate = self
        pickerView.dataSource = self
        vc.view.addSubview(pickerView)
        alert.setValue(vc, forKey: "contentViewController")
        //alert.view.addSubview(pickerView)

        
        // alert button hinzufügen
        let action = UIAlertAction(title: "hinzufügen", style: .default) { (_) in
            let name = alert.textFields!.first!.text!
            let mail = alert.textFields!.last!.text!
            let user = User(context: PersistenceService.context)
            user.name = name
            user.mail = mail
            user.profilIcon = self.placementAnswer
            PersistenceService.saveContext()
            self.people.append(user)
            self.tableView.reloadData()
            // init placementAnswer
            self.placementAnswer = self.userIcons[0].name!
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

extension UserVC: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return userIcons.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let iconView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width, height: 60))
        let iconImageView = UIImageView(frame: CGRect(x: (pickerView.bounds.width/2)-25, y: 0, width: 50, height: 50))
        
        iconImageView.image = userIcons[row].image
        iconView.addSubview(iconImageView)

        return iconView
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        placementAnswer = userIcons[row].name!
    }


}




