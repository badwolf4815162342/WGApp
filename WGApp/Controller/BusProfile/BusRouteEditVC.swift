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
    
    @IBOutlet weak var destinationLabel: UILabel!
    
    var destinationActivated = true
    
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
        
        destinationActivated = true
        if let busRoute = busRoute {
            // set default origin text
            originLocationTextField.text = busRoute.origin?.name
            // set currently selected origin
            let oldOriginStopLocation = StopLocationRMV.stopLocationToRmv(stopLocation: (busRoute.origin)!)
            originLocationTextField.selectedStopLocation = oldOriginStopLocation
            
            // set default destination text
            destinationLocationTextField.text = busRoute.destination?.name
            // set currently selected destination
            let oldDestinationStopLocation = StopLocationRMV(id: (busRoute.destination?.id)!, name: (busRoute.destination?.name)!)
            destinationLocationTextField.selectedStopLocation = oldDestinationStopLocation
        } else {
            originLocationTextField.text = "Start suchen"
            destinationLocationTextField.text = "Ziel suchen"
        }
        
    }
    
    @IBAction func destinationActivationChanged(_ sender: UISwitch) {
        destinationActivated = !destinationActivated
        if (destinationActivated) {
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
                if ((destinationActivated == true) && (originLocationTextField.selectedStopLocation == nil || destinationLocationTextField.selectedStopLocation == nil)) {
                    showAlert()
                    return false
                // Falls kein Ziel ausgewählt sein soll, aber auch kein Strat ausgewählt ist
                } else if (originLocationTextField.selectedStopLocation == nil && destinationActivated == false) {
                    showAlert()
                    return false
                }
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepareForSegue");
        print("ID: ",segue.identifier)
        if segue.identifier == "routeSaved" {
            if segue.destination is BusProfilEditVC {
                if busRoute != nil {
                    // EDIT existing Route
                    // ifChanges ???

                    BusSettingsController.saveOriginStopLocationRMVToBusRoute(rmvStopLocation: originLocationTextField.selectedStopLocation!, busRoute: busRoute!)
                    
                    if let dest = destinationLocationTextField.selectedStopLocation {
                        BusSettingsController.saveDestinationStopLocationRMVToBusRoute(rmvStopLocation: dest, busRoute: busRoute!)
                    } else {
                        BusSettingsController.saveDestinationStopLocationRMVToBusRoute(rmvStopLocation: nil, busRoute: busRoute!)
                    }
                    //print("after setting:", busRoute?.origin?.name ," dest " , busRoute?.destination?.name)
                } else {
                    // CREATE new Route
                    var newBusRoute = BusRoute(context: PersistenceService.context)
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
