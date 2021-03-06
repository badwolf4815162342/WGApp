//
//  PurchaseConfirmationViewController.swift
//  WGApp
//
//  Created by Anna Abad on 15.07.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit
import CoreData

class PurchaseConfirmationViewController: UIViewController {
    
    var buyer: User!
    var participants: [User]!
    var items: [ListItem]!
    var price: Double!
    let cellSpacingHeight: CGFloat = 15
    let participantsStackView = UIStackView()

    @IBOutlet weak var buyerIcon: UIImageView!
    @IBOutlet weak var itemsTableView: UITableView!
    @IBOutlet weak var participantsScrollView: UIScrollView!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // buyer
        if buyer.profilIcon != nil, let image = UIImage(named: buyer.profilIcon!) {
            buyerIcon.image = image
        } else {
            buyerIcon.image = UIImage(named: "info")
        }
        
        // price
        priceLabel.text =  String(format:"%.2f", self.price)
        
        // items
        self.itemsTableView.delegate = self
        self.itemsTableView.dataSource = self
        self.itemsTableView.register(UINib.init(nibName: "CheckMarkViewCell", bundle: nil), forCellReuseIdentifier: "CheckListIdentifier")
        
        // participants
        participantsStackView.translatesAutoresizingMaskIntoConstraints = false
        participantsStackView.axis = .horizontal
        participantsStackView.spacing = 23.0
        participantsScrollView.addSubview(participantsStackView)
        
        participantsScrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[stackView]|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: ["stackView": participantsStackView]))
        participantsScrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[stackView]|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: ["stackView": participantsStackView]))
        addParticipants()
    }
    
    func addParticipants(){
        participantsStackView.subviews.forEach { $0.removeFromSuperview() }
        for user in participants {
            let imageView: UIImageView = UIImageView()
            imageView.image = UIImage(named: user.profilIcon!)
            imageView.contentMode = UIViewContentMode.scaleAspectFit
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            self.participantsStackView.addArrangedSubview(imageView)
            // all constaints
            let widthContraints =  NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
            let heightContraints = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
            NSLayoutConstraint.activate([heightContraints,widthContraints])
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func savePurchase(_ sender: Any) {

        // mark items as bought
        for item in items{
            item.bought = true
        }
        
        // create purchase
        let purchase = Purchase(context: PersistenceService.context)
        purchase.buyer = self.buyer
        purchase.participants = []
        purchase.participants?.addingObjects(from: self.participants)
        purchase.sum = self.price
        purchase.date = NSDate.init()
        
        // create debts
        let difference: Double = self.price / Double(self.participants.count)
        
        for participant in self.participants {
            if participant != buyer{
                
                var lastDebts: [Debt] = []
                var lastDebt: Debt?
                var lastOtherDebt: Debt?
                
                // search for last debts
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Debt")
                fetchRequest.predicate = NSPredicate(format: "creditor = %@ and debtor = %@", buyer, participant)
                let sort = NSSortDescriptor(key: #keyPath(Debt.date), ascending: false)
                fetchRequest.sortDescriptors = [sort]
                fetchRequest.returnsObjectsAsFaults = false
                do {
                    lastDebts = try PersistenceService.context.fetch(fetchRequest) as! [Debt]
                    if lastDebts.count > 0{
                        
                        // existing debts!!
                        lastDebt = lastDebts[0]
                        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Debt")
                        fetchRequest.predicate = NSPredicate(format: "creditor = %@ and debtor = %@", participant, buyer)
                        let sort = NSSortDescriptor(key: #keyPath(Debt.date), ascending: false)
                        fetchRequest.sortDescriptors = [sort]
                        fetchRequest.returnsObjectsAsFaults = false
                        let otherDebts = try PersistenceService.context.fetch(fetchRequest) as! [Debt]
                        if otherDebts.count == 0{
                            print("ERROR! debt wasn't saved twice")
                        }
                        lastOtherDebt = otherDebts[0]
                    }
                } catch {
                    print("core data debts error")
                }
                
                let date = NSDate.init()
                
                // new debts!!
                let debt = Debt(context: PersistenceService.context)
                debt.creditor = buyer
                debt.debtor = participant
                debt.balance = difference
                debt.date = date
                
                let otherDebt = Debt(context: PersistenceService.context)
                otherDebt.creditor = participant
                otherDebt.debtor = buyer
                otherDebt.balance = difference * -1
                otherDebt.date = date

                if lastDebts.count > 0{
                    debt.balance = (lastDebt?.balance)! + difference
                    otherDebt.balance = (lastOtherDebt?.balance)! - difference
                }
                
            }
            PersistenceService.saveContext()
        }
        PersistenceService.saveContext()
    }
}



extension PurchaseConfirmationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckListIdentifier") as! CheckMarkViewCell
        cell.title.text = items[indexPath.section].value
        cell.checkMarkButton.isSelected = true
        cell.backgroundColor = UIColor(named: "GREY")
        cell.textLabel?.textColor = UIColor(named: "WHITE")
        return cell
    }
    
}



