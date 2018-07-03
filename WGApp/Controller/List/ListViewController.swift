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
    
    func refreshContent(){
        // load core data into table
        let fetchRequest: NSFetchRequest<ListItem> = ListItem.fetchRequest()
        do {
            let listItems = try PersistenceService.context.fetch(fetchRequest)
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = listItems[indexPath.row].value
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // edit and delete
        print(listItems[indexPath.row].value)
    }
}
