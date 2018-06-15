//
//  RouteTableViewCell.swift
//  WGApp
//
//  Created by Viviane Rehor on 03.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit

class RouteTableViewCell: UITableViewCell {


    @IBOutlet weak var originLocationLabel: UILabel!
    
    @IBOutlet weak var destinationLocationLabel: UILabel!
    
    func setRoute(route: BusRoute){

        originLocationLabel.text = route.origin?.name
        destinationLocationLabel.text = route.destination?.name
    }
}