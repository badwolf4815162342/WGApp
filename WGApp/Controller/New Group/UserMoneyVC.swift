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
        
        NotificationCenter.default.addObserver(self, selector: #selector(payDebt), name: NSNotification.Name("PayDebt"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func payDebt(n: Notification){
        let debt = n.object as! Debt
        let posBalance = debt.balance * -1

        //let creditor = NSManagedObjectContext.init(coder: debt.creditor)
        let message = String(format: "Hast du %@ %.2f € gezahlt? Falls ja, trag es hier ein! Ansonsten zahl erst deine Schulden!", debt.debtor!.name!, posBalance)
        let alert = UIAlertController(title: "Bezahlt?", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let payAction = UIAlertAction(title: "Schulden bezahlt", style: .default) { (_) in
            
            // new debts!!
            let date = NSDate.init()
            
            let debtOne = Debt(context: PersistenceService.context)
            debtOne.creditor = debt.creditor
            debtOne.debtor = debt.debtor
            debtOne.balance = 0.0
            debtOne.date = date
            
            let debtTwo = Debt(context: PersistenceService.context)
            debtTwo.creditor = debt.debtor
            debtTwo.debtor = debt.creditor
            debtTwo.balance = 0.0
            debtTwo.date = date
            
            PersistenceService.saveContext()
            self.debtDataSource.setData(user: self.user)
            
            self.debtDataSource = CollectionViewDataSource()
            self.debtDataSource.setData(user: self.user)
            self.debtsCollectionView.delegate = self.debtDataSource
            self.debtsCollectionView.dataSource = self.debtDataSource
        }
        let cancleAction = UIAlertAction(title: "Abbrechen", style: .default) { (_) in }
        
        alert.addAction(payAction)
        alert.addAction(cancleAction)
        present(alert, animated: true, completion: nil)
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
        
        cell.sumLabel.text = String(format:"%.2f €", purchase.sum)
        
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
            cell.debt = debt
            // color and payment
            cell.debtLabel.backgroundColor = UIColor(named: "DARK_GRAY")
            // cell.button.isHidden = true
            if row == 0 {
                if debt.balance < -0.0001 {
                    cell.debtLabel.backgroundColor = UIColor(named: "RED")
                    cell.button.isHidden = false
                } else if debt.balance > 0.0001 {
                    cell.debtLabel.backgroundColor = UIColor(named: "GREEN")
                }
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            cell.dateLabel.text = dateFormatter.string(from: debt.date! as Date)
            
            if indexPath.section == 1 {
                // TODO Btn
                cell.button = UIButton(type: .custom)
            }
            
            return cell
        } else {
            if row == 0 {
                // no debts cell (first row)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewDebtCell", for: indexPath) as! CollectionViewDebtCell
                cell.debtLabel.backgroundColor = UIColor(named: "DARK_GRAY")
                cell.debtLabel.text = String(format:"%.2f€", 0.0)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yyyy"
                cell.dateLabel.text = dateFormatter.string(from: NSDate.init() as Date)
            }
            
            // empty cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmtpyCell", for: indexPath)
            return cell
        }
    }
}
