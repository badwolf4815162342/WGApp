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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = user.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
