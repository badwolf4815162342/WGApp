//
//  BusProfilEditViewController.swift
//  WGApp
//
//  Created by Viviane Rehor on 02.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit

class BusProfilEditVC: UIViewController {
    
    public var rmvApiController : RMVApiController = RMVApiController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func printAllNetworkStaff(_ sender: UIButton) {
        self.rmvApiController.getStoplocations(withEntryString: "Dreiwei Wi", completion: { articles in
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
        })
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
