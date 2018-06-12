//
//  BusprofileTableViewCell.swift
//  WGApp
//
//  Created by Viviane Rehor on 07.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit

class BusprofileTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var busprofileTitleLabel: UILabel!
    
    var busprofile: BusSettings?
    
    func setBusprofile(busSettings: BusSettings) {
        busprofile = busSettings
        
        busprofileTitleLabel.text = busSettings.title
        userImageView.backgroundColor = UIColor.darkGray
        //userImageView.image = busSettings.
        
    }

}
