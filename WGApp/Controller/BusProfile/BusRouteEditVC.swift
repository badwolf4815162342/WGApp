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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let header = UILabel(frame: CGRect(x: 0, y: 0, width: originLocationTextField.frame.width, height: 30))
        header.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        header.textAlignment = .center
        header.font = UIFont.systemFont(ofSize: 14)
        header.text = "Ergebnisse"
        originLocationTextField.resultsListHeader = header
        originLocationTextField.clearButtonMode = .whileEditing
        
        destinationLocationTextField.minCharactersNumberToStartFiltering = 2
        destinationLocationTextField.resultsListHeader = header
        destinationLocationTextField.clearButtonMode = .whileEditing
        
        originLocationTextField.text = busRoute?.origin?.name
        let oldOriginStopLocation = StopLocationRMV(id: (busRoute?.origin?.id)!, name: (busRoute?.origin?.name)!)
        originLocationTextField.selectedStopLocation = oldOriginStopLocation
        destinationLocationTextField.text = busRoute?.destination?.name
        let oldDestinationStopLocation = StopLocationRMV(id: (busRoute?.destination?.id)!, name: (busRoute?.destination?.name)!)
        destinationLocationTextField.selectedStopLocation = oldDestinationStopLocation
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepareForSegue");
        if segue.identifier == "routeSaved" {
            if let destinationVC = segue.destination as? BusProfilEditVC {
                // ifChanges
                var newBusRoute = BusRoute(context: PersistenceService.context)
                
                let actOriginLocation = StopLocation(context: PersistenceService.context)
                let actDestinationLocation = StopLocation(context: PersistenceService.context)
                
                actOriginLocation.id = originLocationTextField.selectedStopLocation?.id
                actOriginLocation.name = originLocationTextField.selectedStopLocation?.name
                actOriginLocation.addToOriginOfBusRoutes(newBusRoute)
                
                print(originLocationTextField.selectedStopLocation?.name)
                
                actDestinationLocation.id = destinationLocationTextField.selectedStopLocation?.id
                actDestinationLocation.name = destinationLocationTextField.selectedStopLocation?.name
                actDestinationLocation.addToDestinationOfBusRoutes(newBusRoute)
                
                newBusRoute.origin = actOriginLocation
                newBusRoute.destination = actDestinationLocation
                
                //TODO: return old one if no changes
                //if (busRoute == newBusRoute) {
                    print("notequalroutes")
                    busRoute = newBusRoute
                    PersistenceService.saveContext()
                /*} else {
                    print("equalroutes")
                }
            **/
            }
        }
        
    }
    
 
  



    


}
