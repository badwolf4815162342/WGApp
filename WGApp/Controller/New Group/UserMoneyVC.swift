//
//  UserMoneyVC.swift
//  WGApp
//
//  Created by Anna Abad on 15.07.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit
import CoreData

class UserMoneyVC: UIViewController {

    var user: User!
    
    
    var debtDataSource: CollectionViewDataSource!
    var purchasesDataSource: TableViewDataSource!

    
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var purchaseList: UITableView!
    @IBOutlet weak var debtsCollectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
        
        self.purchasesDataSource = TableViewDataSource()
        purchaseList.delegate = self.purchasesDataSource
        purchaseList.dataSource = self.purchasesDataSource
        purchaseList.register(UINib.init(nibName: "PurchaseTableViewCell", bundle: nil), forCellReuseIdentifier: "PurchaseCellIdentifier")

        self.debtDataSource = CollectionViewDataSource()
        self.debtDataSource.setData(user: self.user)
        self.debtsCollectionView.delegate = self.debtDataSource
        self.debtsCollectionView.dataSource = self.debtDataSource
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func refresh(){
        // set label and icon
        name.text = user.name
        if user.profilIcon != nil, let image = UIImage(named: user.profilIcon!) {
            userIcon.image = image
        } else {
            userIcon.image = UIImage(named: "info") 
        }
    }
}

class TableViewDataSource:NSObject,UITableViewDelegate, UITableViewDataSource {
    
    var purchases: [Purchase] = []
    
    override init(){
        super.init()
        // load purchases form data base
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Purchase")
        let sort = NSSortDescriptor(key: #keyPath(Purchase.date), ascending: false)
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let purchases = try PersistenceService.context.fetch(fetchRequest)
            self.purchases = purchases as! [Purchase]
        } catch {
            print("error when loading core data")
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return purchases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let purchase = purchases[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PurchaseCellIdentifier") as! PurchaseTableViewCell
        cell.buyerImage.image = UIImage(named: (purchase.buyer?.profilIcon!)!)
        cell.buyerImage.contentMode = UIViewContentMode.scaleAspectFit
        
        cell.sumLabel.text = String(format:"%.2f€", purchase.sum)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd. MMM yyyy"
        cell.dateLabel.text = dateFormatter.string(from: purchase.date! as Date)
        
        return cell
    }
}

class CollectionViewDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var otherUsers: [User] = []
    var debts: [[Debt]] = []
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        var sections = 2
        for debts in debts{
            if (debts.count+1) > sections{
                sections = debts.count+1
            }
        }
        return sections
    }
    
    func setData(user: User){
        // get all other users:
        let fetchRequestUser = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequestUser.predicate = NSPredicate(format: "self != %@", user)
        do {
            self.otherUsers = try PersistenceService.context.fetch(fetchRequestUser) as! [User]
        } catch {
            print("core data couldn't be loaded") // error
        }
        
        // save debts for each otherUser
        self.debts = []
        for otherUser in otherUsers{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Debt")
            fetchRequest.predicate = NSPredicate(format: "creditor = %@ and debtor = %@", user, otherUser)
            let sort = NSSortDescriptor(key: #keyPath(Purchase.date), ascending: false)
            fetchRequest.sortDescriptors = [sort]
            fetchRequest.returnsObjectsAsFaults = false
            do {
                let debts = try PersistenceService.context.fetch(fetchRequest) as! [Debt]
                self.debts.append(debts)
            } catch {
                print("error when loading core data")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return otherUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewHeaderCell", for: indexPath) as! CollectionViewHeaderCell
            print("(",otherUsers.count,")")
            cell.userIcon.image = UIImage(named: self.otherUsers[indexPath.row].profilIcon!)
            return cell
        }
        
        // naming
        let column = indexPath.row
        let row = indexPath.section-1
        
        // other rows: debts
        let debts = self.debts[column]
        if row < debts.count{
            let debt = debts[row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewDebtCell", for: indexPath) as! CollectionViewDebtCell
            cell.debtLabel.text = String(format:"%.2f€", debt.balance)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            cell.dateLabel.text = dateFormatter.string(from: debt.date! as Date)
            
            if indexPath.section == 1 {
                cell.button = UIButton(type: .custom)
            }
            
            return cell
        } else {
            // empty cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmtpyCell", for: indexPath)
            return cell
        }
    }
    
}

/*
extension UserMoneyVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
        //return otherUsers.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
        var sections = 1
        for debts in debts{
            if (debts.count+1) > sections{
                sections = debts.count+1
            }
        }
        return sections
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestCell", for: indexPath) as! TestCollectionViewCell
        cell.label.text = "section: \(indexPath.section) && row: \(indexPath.row)"
        return cell

        let cell = UICollectionViewCell(frame: CGRect(x: 0, y: 0, width: 222, height: 74))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 222, height: 74))
        label.text = "section: \(indexPath.section) && row: \(indexPath.row)"
        cell.addSubview(label)
        return cell*/
        
        
        /*
        // first row: images
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DebtHeaderCellIdentifier") as! DebtHeaderTableViewCell
            cell.userIcon.image = UIImage(named: self.otherUsers[indexPath.row].profilIcon!)
            return cell
        }
        
        // naming
        let column = indexPath.row
        let row = indexPath.section-1
        
        // other rows: debts
        let debts = self.debts[column]
        if row < debts.count{
            let debt = debts[row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "DebtCellIdentifier") as! DebtTableViewCell
            cell.balanceLabel.text = String(format:"%.2f€", debt.balance)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd. MMM yyyy"
            cell.dateLabel.text = dateFormatter.string(from: debt.date! as Date)
            
            if indexPath.section == 1 {
                cell.button = UIButton(type: .custom)
            }
            
            return cell
        } else {
            // empty cell
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            return cell
        }
    }
}*/
