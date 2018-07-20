//
//  CollectionViewDebtCell.swift
//  WGApp
//
//  Created by Anna Abad on 18.07.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit

class CollectionViewDebtCell: UICollectionViewCell {
    
    @IBOutlet weak var debtLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var debt:Debt?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(named: "LIGHT_GRAY")?.cgColor
        self.layer.cornerRadius = 5.0
    }
    
    @IBAction func payDebts(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("PayDebt"), object: debt)
    }
}
