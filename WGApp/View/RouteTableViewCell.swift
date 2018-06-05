//
//  RouteTableViewCell.swift
//  WGApp
//
//  Created by Viviane Rehor on 03.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit

class RouteTableViewCell: UITableViewCell {

    
    @IBOutlet weak var originLocationTextField: UIStopLocationSearchTextField!
    
    @IBOutlet weak var destinationLocationTextField: UIStopLocationSearchTextField!
    
    func setRoute(originStopLocation: StopLocationRMV, destinationStopLocation: StopLocationRMV){
        originLocationTextField.placeholderLabel?.text = originStopLocation.name
        destinationLocationTextField.placeholderLabel?.text = destinationStopLocation.name
    }
}
