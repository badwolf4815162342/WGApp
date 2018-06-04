//
//  SingleUserVC.swift
//  WGApp
//
//  Created by Anna Abad on 04.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit

class SingleUserVC: UIViewController {
    
    var user: User!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var mail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = user.name
        mail.text = user.mail
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
