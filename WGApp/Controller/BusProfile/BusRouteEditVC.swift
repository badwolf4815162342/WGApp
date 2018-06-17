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
        print("ID: ",segue.identifier)
        if segue.identifier == "routeSaved" {
            if let destinationVC = segue.destination as? BusProfilEditVC {
                // ifChanges
               // var newBusRoute = BusRoute(context: PersistenceService.context)
                
                busRoute = BusSettingsController.saveOriginStopLocationRMVToBusRoute(rmvStopLocation: originLocationTextField.selectedStopLocation!, busRoute: busRoute!)
                print(originLocationTextField.selectedStopLocation?.name)
                
                busRoute = BusSettingsController.saveDestinationStopLocationRMVToBusRoute(rmvStopLocation: destinationLocationTextField.selectedStopLocation!, busRoute: busRoute!)
                
                print("after setting:", busRoute?.origin?.name ," dest " , busRoute?.destination?.name)
                
                //busRoute = newBusRoute

            }
        }
        
    }
    
 
  



    


}
