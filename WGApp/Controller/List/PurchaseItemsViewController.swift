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
    @IBOutlet weak var buyerIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if buyer.profilIcon != nil, let image = UIImage(named: buyer.profilIcon!) {
            buyerIcon.image = image
        } else {
            buyerIcon.image = UIImage(named: "Bear-icon")
            print("Picture of user could not be loaded !!! ")
        }


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
