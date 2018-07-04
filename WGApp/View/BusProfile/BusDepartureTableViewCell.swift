//
//  BusDepartureTableViewCell.swift
//  WGApp
//
//  Created by Viviane Rehor on 29.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit

class BusDepartureTableViewCell: UITableViewCell {


    @IBOutlet weak var lineLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    
    @IBOutlet weak var minutesLabel: UILabel!

    
    @IBOutlet weak var originLabel: UILabel!

    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var realStratTime: UILabel!

    
    func setDeparture(departureRMV: DepartureRMV){
        originLabel.text = departureRMV.stopLocation.name?.getAcronyms()
        directionLabel.text = departureRMV.direction
        lineLabel.text = departureRMV.transportationName
        minutesLabel.text = BusSettingsController.setMinutesLabel(time: departureRMV.realDepartureTime)
        let outFormatter = DateFormatter()
        outFormatter.locale = NSLocale(localeIdentifier: "de") as Locale!
        outFormatter.dateFormat = "hh:mm"
        startTime.text = outFormatter.string(from: departureRMV.plannedDepartureTime)
        realStratTime.text = outFormatter.string(from: departureRMV.realDepartureTime)
        //print(departureRMV)
    }

}
