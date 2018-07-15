//
//  PurchasePriceViewController.swift
//  WGApp
//
//  Created by Anna Abad on 15.07.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit

class PurchasePriceViewController: UIViewController {
    
    var buyer: User!
    var participants: [User]!
    var items: [ListItem]!
    var price: Double!

    @IBOutlet weak var buyerIcon: UIImageView!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var warnText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if buyer.profilIcon != nil, let image = UIImage(named: buyer.profilIcon!) {
            buyerIcon.image = image
        } else {
            print("Picture of user could not be loaded !!! ")
        }
        
        warnText.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindCreatePurchaseFromConfirmation(sender: UIStoryboardSegue){
        self.performSegue(withIdentifier: "unwindCreatePurchaseFromPriceID", sender: self)
    }

    @IBAction func checkPrice(_ sender: Any) {
        if let price = Double(self.amountField.text!) {
            self.price = price
            warnText.isHidden = true
            self.performSegue(withIdentifier: "ShowPurchaseConfirmation", sender: self)
        } else {
            warnText.isHidden = false
        }
        
    }
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPurchaseConfirmation"{
            if let confirmationVC = segue.destination as? PurchaseConfirmationViewController {
                confirmationVC.buyer = self.buyer
                confirmationVC.participants = self.participants
                confirmationVC.items = self.items
                confirmationVC.price = self.price
            }
        }
    }


}
