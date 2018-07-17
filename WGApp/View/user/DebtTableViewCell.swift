//
//  DebtTableViewCell.swift
//  WGApp
//
//  Created by Anna Abad on 16.07.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit

class DebtTableViewCell: UITableViewCell {

    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
