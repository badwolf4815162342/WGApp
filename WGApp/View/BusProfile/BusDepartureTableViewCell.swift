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

    
    func setDeparture(departureRMV: DepartureRMV, selectedDepartures: [String]){
        originLabel.text = departureRMV.stopLocation.name?.getAcronyms()
        directionLabel.text = departureRMV.direction
        lineLabel.text = departureRMV.transportationName
        let retValues = BusSettingsController.getMinutes(time: departureRMV.realDepartureTime)
        let min = retValues.minutes
        let futureDeparture = retValues.futureDeparture
        minutesLabel.text = BusSettingsController.getMinutesLabel(minutes: min, futureDeparture: futureDeparture)
        let outFormatter = DateFormatter()
        outFormatter.locale = NSLocale(localeIdentifier: "de") as Locale?
        outFormatter.dateFormat = "HH:mm"
        startTime.text = outFormatter.string(from: departureRMV.plannedDepartureTime)
        realStratTime.text = outFormatter.string(from: departureRMV.realDepartureTime)
        if (selectedDepartures.contains(departureRMV.id)){
            self.backgroundColor = BusSettingsController.setSelectedColor(minutes: min, futureDeparture: futureDeparture)
        } else {
            self.backgroundColor = UIColor(named: "LIGHT_GRAY")
        }
    }

}
