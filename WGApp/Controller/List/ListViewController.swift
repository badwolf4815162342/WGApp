//
//  ListViewController.swift
//  WGApp
//
//  Created by Anna Abad on 03.07.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UIViewController {

    @IBOutlet weak var listTableView: UITableView!
    
    var listItems = [ListItem]()
    
    let rowHeight: CGFloat = 50
    
    func refreshContent(){
        // load core data into table
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ListItem")
        fetchRequest.predicate = NSPredicate(format: "bought = %@", false)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let listItems = try PersistenceService.context.fetch(fetchRequest) as! [ListItem]
            self.listItems = listItems
            self.listTableView.reloadData()
        } catch {
            print("core data couldn't be loaded")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshContent()
    }
    
    override func viewDidLoad() {
        listTableView.rowHeight = rowHeight
        super.viewDidLoad()
        listTableView.delegate = self
        listTableView.dataSource = self
    }
    
    @IBAction func addItem(_ sender: UIButton) {
        // alert
        let alert = UIAlertController(title: "Element hinzufügen", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
        // name
        alert.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        
        // alert button hinzufügen
        let saveAction = UIAlertAction(title: "hinzufügen", style: .default) { (_) in
            let name = alert.textFields!.first!.text!
            let item = ListItem(context: PersistenceService.context)
            item.value = name
            PersistenceService.saveContext()
            
            self.refreshContent()
        }
        let cancleAction = UIAlertAction(title: "abbrechen", style: .default) { (_) in }
        
        alert.addAction(saveAction)
        alert.addAction(cancleAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectBuyer" {
            if let destinationVC = segue.destination as? UserSelectionVC {
                destinationVC.dataType = UserSelectionVC.UserSelectionVCType.choosePurchaseBuyer
            }
        }
    }
}




extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.textLabel?.textColor = UIColor(named: "GREY")
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.textLabel?.textColor = UIColor(named: "WHITE")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = listItems[indexPath.row].value
        cell.backgroundColor = UIColor(named: "GREY")
        cell.textLabel?.textColor = UIColor(named: "WHITE")
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // edit Item
        let editAction =  UIContextualAction(style: .normal, title: "bearbeiten", handler: { (action,view,completionHandler ) in
            // alert
            let alert = UIAlertController(title: "Element bearbeiten", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            
            // name
            alert.addTextField { (textField) in
                textField.text = self.listItems[indexPath.row].value
            }
            
            // alert button hinzufügen
            let saveAction = UIAlertAction(title: "speichern", style: .default) { (_) in
                let name = alert.textFields!.first!.text!
                let item = self.listItems[indexPath.row]
                item.value = name
                PersistenceService.saveContext()
                self.refreshContent()
            }
            let cancleAction = UIAlertAction(title: "abbrechen", style: .default) { (_) in }
            
            alert.addAction(saveAction)
            alert.addAction(cancleAction)
            self.present(alert, animated: true, completion: nil)
            completionHandler(true)
        })
        editAction.image = UIImage(named: "edit")
        editAction.backgroundColor = .green
        
        // delete Item
        let deleteAction =  UIContextualAction(style: .normal, title: "löschen", handler: { (action,view,completionHandler ) in
            // alert
            let alert = UIAlertController(title: "Sicher, dass du das Element löschen möchtest?", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            // alert button hinzufügen
            let saveAction = UIAlertAction(title: "löschen", style: .default) { (_) in
                print("delete item")
                PersistenceService.context.delete(self.listItems[indexPath.row])
                PersistenceService.saveContext()
                self.refreshContent()
            }
            let cancleAction = UIAlertAction(title: "abbrechen", style: .default) { (_) in }
            
            alert.addAction(saveAction)
            alert.addAction(cancleAction)
            self.present(alert, animated: true, completion: nil)
            completionHandler(true)
        })
        deleteAction.image = UIImage(named: "delete")
        deleteAction.backgroundColor = .red
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return configuration
    }
}
