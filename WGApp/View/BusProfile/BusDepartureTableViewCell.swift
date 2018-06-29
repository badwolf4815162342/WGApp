//
//  BusDepartureTableViewCell.swift
//  WGApp
//
//  Created by Viviane Rehor on 29.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit

class BusDepartureTableViewCell: UITableViewCell {


    @IBOutlet weak var startLocation: UILabel!
    
    @IBOutlet weak var stopLocation: UILabel!
    
    func setDeparture(departureRMV: DepartureRMV){
        startLocation.text = departureRMV.stopLocation.name
        stopLocation.text = "NONE"

    }

}
