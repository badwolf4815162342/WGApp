//
//  BusTripTableViewCell.swift
//  WGApp
//
//  Created by Viviane Rehor on 29.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit

class BusTripTableViewCell: UITableViewCell {

    @IBOutlet weak var startDirectionLabel: UILabel!
    @IBOutlet weak var startLineLable: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!

    @IBOutlet weak var countChangesLabel: UILabel!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var destLabel: UILabel!
    
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var realStratTime: UILabel!
    
    
    func setTrip(tripRMV: TripRMV, selectedTrips: [String]){
        if tripRMV.routeParts[0].feet {
            print("feet")
        } else {
            originLabel.text = tripRMV.originStopLocation.name?.getAcronyms()
            destLabel.text = tripRMV.destinationStopLocation.name?.getAcronyms()
            startDirectionLabel.text = tripRMV.routeParts[0].direction
            startLineLable.text = tripRMV.routeParts[0].transportationName
            let retValues = BusSettingsController.getMinutes(time: tripRMV.routeParts[0].realDepartureTime)
            let min = retValues.minutes
            let futureDeparture = retValues.futureDeparture
            minutesLabel.text = BusSettingsController.getMinutesLabel(minutes: min, futureDeparture: futureDeparture)
            countChangesLabel.text = (String) (tripRMV.routeParts.count-1)
            durationLabel.text = tripRMV.durationMinutes
            let outFormatter = DateFormatter()
            outFormatter.locale = NSLocale(localeIdentifier: "de") as Locale!
            outFormatter.dateFormat = "hh:mm"
            startTime.text = outFormatter.string(from: tripRMV.routeParts[0].plannedDepartureTime)
            realStratTime.text = outFormatter.string(from: tripRMV.routeParts[0].realDepartureTime)
            if (selectedTrips.contains(tripRMV.id)){
                //print("LONG: contains \(tripRMV.id)")
                self.backgroundColor = BusSettingsController.setSelectedColor(minutes: min, futureDeparture: futureDeparture)
            }
        }
    }
    
}

extension String
{
    public func getAcronyms(separator: String = "") -> String
    {
        let acronyms = self.components(separatedBy: " ")
        let first = acronyms[0].prefix(2)
        var rest = ""
        if (acronyms.count==2){
            rest = String(acronyms[1].prefix(4))
        } else {
            rest = acronyms.dropFirst().map({ $0.prefix(1) }).joined(separator: separator);
        }
        return first+" "+rest;
    }
    
    public func cutMinuteInfo() -> String {
        // for duration
        return self
    }
    
}
