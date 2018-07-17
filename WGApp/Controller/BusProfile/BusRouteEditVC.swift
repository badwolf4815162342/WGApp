//
//  BusRouteEditVC.swift
//  WGApp
//
//  Created by Viviane Rehor on 09.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit

class BusRouteEditVC: UIViewController {
    
   
    @IBOutlet weak var originLocationTextField: UIStopLocationSearchTextField!
    
    @IBOutlet weak var destinationLocationTextField: UIStopLocationSearchTextField!
    
    var busRoute: BusRoute?
    
    var withDestinations: Bool?
    
    @IBOutlet weak var destinationLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set Searchtextfield theme and settings
        let header = UILabel(frame: CGRect(x: 0, y: 0, width: originLocationTextField.frame.width, height: 30))
        header.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        header.textAlignment = .center
        header.font = UIFont.systemFont(ofSize: 14)
        header.text = "Ergebnisse"
        originLocationTextField.resultsListHeader = header
        originLocationTextField.minCharactersNumberToStartFiltering = 2
        originLocationTextField.clearButtonMode = .whileEditing
        destinationLocationTextField.minCharactersNumberToStartFiltering = 2
        destinationLocationTextField.resultsListHeader = header
        destinationLocationTextField.clearButtonMode = .whileEditing
        
        // busRoute is already there
        if let busRoute = busRoute {
            // set default origin text
            originLocationTextField.text = busRoute.origin?.name
            // set currently selected origin
            let oldOriginStopLocation = StopLocationRMV.stopLocationToRmv(stopLocation: (busRoute.origin)!)
            originLocationTextField.selectedStopLocation = oldOriginStopLocation
            
            // set default destination text
            destinationLocationTextField.text = busRoute.destination?.name
            // set currently selected destination
            if let dest = busRoute.destination {
                let oldDestinationStopLocation = StopLocationRMV(id: (dest.id)!, name: (dest.name)!)
                destinationLocationTextField.selectedStopLocation = oldDestinationStopLocation
            }
            destinationActivationChanged(withDestination: busRoute.withDestination)
        } else {
            // if busroutes have destination
            if let withDest = withDestinations {
                originLocationTextField.text = "Start suchen"
                destinationLocationTextField.text = "Ziel suchen"
                destinationActivationChanged(withDestination: withDest)
            } else {
                print("ERROR: NO INFO WithDEST")
            }
        }

        
    }
    
    func destinationActivationChanged(withDestination: Bool) {
        if (withDestination) {
            destinationLocationTextField.isHidden = false
            destinationLabel.text = "Ziel"
        } else {
            destinationLocationTextField.selectedStopLocation = nil
            destinationLocationTextField.isHidden = true
            destinationLabel.text = "Route ohne Ziel"
        }
    }
    
    override func shouldPerformSegue(withIdentifier withIidentifier: String?, sender: Any?) -> Bool {
        if let ident = withIidentifier {
            if ident == "routeSaved" {
                if ((withDestinations == true) && (originLocationTextField.selectedStopLocation == nil || destinationLocationTextField.selectedStopLocation == nil)) {
                    showAlert()
                    return false
                // Falls kein Ziel ausgewählt sein soll, aber auch kein Strat ausgewählt ist
                } else if (originLocationTextField.selectedStopLocation == nil && withDestinations == false) {
                    showAlert()
                    return false
                }
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "routeSaved" {
            if segue.destination is BusProfilEditVC {
                if busRoute != nil {
                    // EDIT existing Route
                    BusSettingsController.saveOriginStopLocationRMVToBusRoute(rmvStopLocation: originLocationTextField.selectedStopLocation!, busRoute: busRoute!)
                    
                    if let dest = destinationLocationTextField.selectedStopLocation {
                        BusSettingsController.saveDestinationStopLocationRMVToBusRoute(rmvStopLocation: dest, busRoute: busRoute!)
                    } else {
                        BusSettingsController.saveDestinationStopLocationRMVToBusRoute(rmvStopLocation: nil, busRoute: busRoute!)
                    }
                } else {
                    // CREATE new Route
                    let newBusRoute = BusRoute(context: PersistenceService.context)
                    BusSettingsController.saveOriginStopLocationRMVToBusRoute(rmvStopLocation: originLocationTextField.selectedStopLocation!, busRoute: newBusRoute)
                    
                    if let dest = destinationLocationTextField.selectedStopLocation {
                        BusSettingsController.saveDestinationStopLocationRMVToBusRoute(rmvStopLocation: dest, busRoute: newBusRoute)
                    } else {
                        BusSettingsController.saveDestinationStopLocationRMVToBusRoute(rmvStopLocation: nil, busRoute: newBusRoute)
                    }
                    busRoute = newBusRoute
                }
            }
        }
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Keine valide Haltestelle ausgewählt!", message: "Start- oder Zielhaltestelle sind noch nicht ausgewählt, hole dies nach oder brich das Bearbeiten/Hinzufügen mit 'Back' ab.", preferredStyle: UIAlertControllerStyle.alert)
        
        let cancleAction = UIAlertAction(title: "ok", style: .default) { (_) in }

        alert.addAction(cancleAction)
        present(alert, animated: true, completion: nil)
    }

}
