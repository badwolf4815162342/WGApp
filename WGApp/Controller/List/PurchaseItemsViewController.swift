//
//  PurchaseItemsViewController.swift
//  WGApp
//
//  Created by Anna Abad on 14.07.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit
import CoreData

class PurchaseItemsViewController: UIViewController {
    
    var buyer: User!
    var listItems = [ListItem]()
    let rowHeight: CGFloat = 50
    let cellSpacingHeight: CGFloat = 15
    let questionText = "Was hast du gekauft "
    let participantsStackView = UIStackView()
    var users: [User] = []
    var currentlySelectedUsers: [User] = []
    
    @IBOutlet weak var buyerIcon: UIImageView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var participantsLabel: UILabel!
    @IBOutlet weak var participantsScrollView: UIScrollView!
    @IBOutlet weak var listTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set table
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.register(UINib.init(nibName: "CheckMarkViewCell", bundle: nil), forCellReuseIdentifier: "CheckListIdentifier")

        // set buyer information
        self.questionLabel.text = questionText + buyer.name! + "?"
        if buyer.profilIcon != nil, let image = UIImage(named: buyer.profilIcon!) {
            buyerIcon.image = image
        } else {
            print("Picture of user could not be loaded !!! ")
        }
        
        refreshContent()
        
        currentlySelectedUsers = []
        currentlySelectedUsers.append(contentsOf: users)
        print(currentlySelectedUsers.count)
        self.participantsLabel.isHidden = true
        self.participantsScrollView.isHidden = true
        
        // Stackview in scrollview für userSelection
        participantsStackView.translatesAutoresizingMaskIntoConstraints = false
        participantsStackView.axis = .horizontal
        participantsStackView.spacing = 23.0
        participantsScrollView.addSubview(participantsStackView)
        
        participantsScrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[stackView]|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: ["stackView": participantsStackView]))
        participantsScrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[stackView]|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: ["stackView": participantsStackView]))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func unwindCreatePurchaseFromPrice(sender: UIStoryboardSegue){
        self.performSegue(withIdentifier: "unwindCreatePurchaseID", sender: self)
    }
    
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
        self.listTableView.reloadData()
        // load core data into users list
        let fetchRequestUser: NSFetchRequest<User> = User.fetchRequest()
        do {
            let users = try PersistenceService.context.fetch(fetchRequestUser)
            self.users = users
        } catch {
            print("core data couldn't be loaded")
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPurchasePrice" {
            if let priceVC = segue.destination as? PurchasePriceViewController {
                
                // set buyer
                priceVC.buyer = self.buyer
                
                // set selected items
                var items:[ListItem] = []
                let cells = self.listTableView.visibleCells as! Array<CheckMarkViewCell>
                if cells.count != self.listItems.count{
                    print("ERROR ERROR")
                }
                for x in 0..<cells.count{
                    if cells[x].checkMarkButton.isSelected {
                        items.append(listItems[x])
                    }
                }
                priceVC.items = items
                
                // set participants
                priceVC.participants = []
                priceVC.participants.append(contentsOf: currentlySelectedUsers)
            }
        }
    }
    
    func addUserSelectionItems(){
        participantsStackView.subviews.forEach { $0.removeFromSuperview() }
        print(currentlySelectedUsers.count)
        // je user buttons erstellen
        for user in users {
            let button: UserUIButton = UserUIButton(type: .custom)
            // button bild hinzufügen
            button.setImage(UIImage(named: user.profilIcon!), for: .normal)
            button.imageView?.contentMode = UIViewContentMode.scaleAspectFit
            
            button.layer.borderWidth = 5
            button.layer.cornerRadius = 5
            if (currentlySelectedUsers.contains(user)){
                button.layer.borderColor = UIColor(named: "YELLOW")?.cgColor
            } else {
                button.layer.borderColor = UIColor(named: "DARK_GRAY")?.cgColor
            }
            
            button.addTarget(self, action: #selector(toggleUser(sender:)), for: .touchUpInside)
            button.user = user
            
            button.translatesAutoresizingMaskIntoConstraints = false
            //buttons stackview hinzufügen
            self.participantsStackView.addArrangedSubview(button)
            // all constaints to set size IMPORTANT!!!!
            let widthContraints =  NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
            let heightContraints = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
            NSLayoutConstraint.activate([heightContraints,widthContraints])
        }
    }
    
    @objc func toggleUser(sender: UserUIButton){
        let index = currentlySelectedUsers.index(of: sender.user as! User)
        if (index != nil) {
            sender.layer.borderColor = UIColor(named: "DARK_GRAY")?.cgColor
            currentlySelectedUsers.remove(at: index!)
        } else {
            currentlySelectedUsers.append(sender.user as! User)
            sender.layer.borderColor = UIColor(named: "YELLOW")?.cgColor
        }
    }
    
    @IBAction func changeParticipantsValue(_ sender: UISwitch) {
        if sender.isOn{
            currentlySelectedUsers = []
            currentlySelectedUsers.append(contentsOf: users)
            self.participantsLabel.isHidden = true
            self.participantsScrollView.isHidden = true
        } else{
            addUserSelectionItems()
            self.participantsLabel.isHidden = false
            self.participantsScrollView.isHidden = false
            
        }
    }
    
}



extension PurchaseItemsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return listItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    /*func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
        }else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
        }
    }*/
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckListIdentifier") as! CheckMarkViewCell
        cell.title.text = listItems[indexPath.section].value
        cell.selectionStyle = .none
        cell.checkMarkButton.addTarget(self, action: #selector(checkButtonClicked(sender:)), for: UIControlEvents.touchUpInside)
        //cell.backgroundColor = UIColor(named: "GREY")
        //cell.textLabel?.textColor = UIColor(named: "WHITE")
        return cell
    }
    
    @objc func checkButtonClicked(sender: UIButton){
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }
    
}


