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
        var userIconString = busprofile?.ofProfil?.profilIcon
        if userIconString != nil, let image = UIImage(named: userIconString!) {
            userImageView.image = image
        } else {
            userImageView.image = UIImage(named: "Bear-icon")
            print("Picture of user could not be loaded !!! ")
        }
        //userImageView.image = busSettings.
        
    }

}
