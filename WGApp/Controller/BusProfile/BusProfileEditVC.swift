//
//  BusProfilEditViewController.swift
//  WGApp
//
//  Created by Viviane Rehor on 02.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit

class BusProfilEditVC: UIViewController {
    
    @IBOutlet weak var testStopLocationSearchField: UIStopLocationSearchTextField!
    
    @IBOutlet weak var routesTableView: UITableView!
    
    public var rmvApiController : RMVApiController = RMVApiController()
    
    var stopLocationsForBusProfile = [StopLocationRMV]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        routesTableView.delegate = self
        routesTableView.dataSource = self
        // ab wieviel eingabe params soll gesucht werden
        testStopLocationSearchField.minCharactersNumberToStartFiltering = 2
        let header = UILabel(frame: CGRect(x: 0, y: 0, width: testStopLocationSearchField.frame.width, height: 30))
        header.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        header.textAlignment = .center
        header.font = UIFont.systemFont(ofSize: 14)
        header.text = "Ergebnisse"
        testStopLocationSearchField.resultsListHeader = header
        // Do any additional setup after loading the view.
        
        let stopLocationWiHbf = StopLocationRMV(id: "001", name: "Wi Hbf" )
        let stopLocationMainzHbf = StopLocationRMV(id: "002", name: "Mainz Hbf" )
        let stopLocationFrHbf = StopLocationRMV(id: "003", name: "FR Hbf" )
        let stopLocationWiesHbf = StopLocationRMV(id: "004", name: "Wiesloch Hbf" )
        stopLocationsForBusProfile.append(stopLocationWiHbf)
        stopLocationsForBusProfile.append(stopLocationMainzHbf)
        stopLocationsForBusProfile.append(stopLocationFrHbf)
        stopLocationsForBusProfile.append(stopLocationWiesHbf)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func printAllNetworkStaff(_ sender: UIButton) {
        self.rmvApiController.getTestStoplocations(withEntryString: "Dreiwei Wi", completion: { stopLocations in
            DispatchQueue.main.async {
                self.stopLocationsForBusProfile = stopLocations
                self.routesTableView?.reloadData()
            }
        })
        /**
        self.rmvApiController.getTestStoplocations(withEntryString: "Dreiwei Wi", completion: { articles in
            print(articles.count)
            print("TestStops")
            for stop in articles {
                print(stop)
            }
        })
        self.rmvApiController.getDepartures(fromOriginId: "003025274", completion: { departures in
            print(departures.count)
            print("TestDepartures")
            for departure in departures {
                print(departure)
            }
        })**/
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension BusProfilEditVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stopLocationsForBusProfile.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let stopLocation = stopLocationsForBusProfile[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RouteCell")
        
        let rtCell = cell  as! RouteTableViewCell
        
        rtCell.setRoute(originStopLocation: stopLocation, destinationStopLocation: stopLocation)
        
        return rtCell
    }
}
