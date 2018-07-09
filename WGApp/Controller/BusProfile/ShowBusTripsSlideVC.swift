//
//  ShowBusTripsVC.swift
//  WGApp
//
//  Created by Viviane Rehor on 29.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit
import CoreData

class ShowBusTripsSlideVC: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        
    var pages = [UIViewController]()

    //var busSettingVCs = [BusSettings]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self

        // selected User changed
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name("globalSelectedUserChanged"), object: nil)
    }
    
    @objc func refresh() {
        var profiles: [BusSetting]?
        pages = []
        if (HomeScreenVC.selectedUser == HomeScreenVC.wg) {
            let fetchRequest: NSFetchRequest<BusSetting> = BusSetting.fetchRequest()
            do {
                profiles = try PersistenceService.context.fetch(fetchRequest)
            } catch {}
        } else {
            profiles = (((HomeScreenVC.selectedUser?.favoriteBusSettings)!).allObjects as? [BusSetting])!
        }
        if let profiles = profiles {
            for profile in profiles {
                if (profile.withDestinations) {
                    let vc: ShowBusTripsTableVC! = (storyboard?.instantiateViewController(withIdentifier: "busTripsTableView"))! as! ShowBusTripsTableVC
                    vc.selectedBusProfile = profile
                    vc.tripsTableType = ShowBusTripsTableVC.TripsTableType.trip
                    pages.append(vc)
                } else {
                    let vc: ShowBusTripsTableVC! = (storyboard?.instantiateViewController(withIdentifier: "busTripsTableView"))! as! ShowBusTripsTableVC
                    vc.selectedBusProfile = profile
                    vc.tripsTableType = ShowBusTripsTableVC.TripsTableType.departure
                    pages.append(vc)
                }
                
                /**else {
                    let vc: ShowBusDepartureTableVC! = (storyboard?.instantiateViewController(withIdentifier: "busDeparturesTableView"))! as! ShowBusDepartureTableVC
                    vc.selectedBusProfile = profile
                    pages.append(vc)
                }**/
            }
            print("label found")
            if(profiles.count==0) {
                let vc: NoTripsVC! = (storyboard?.instantiateViewController(withIdentifier: "noTripsView"))! as! NoTripsVC
                pages.append(vc)
                self.view.isUserInteractionEnabled = false
            } else {
                self.view.isUserInteractionEnabled = true
            }
            setViewControllers([pages[0]], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)

        }
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear of ShowBusTripsSlideVC")
        refresh()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController)-> UIViewController? {
        
        let cur = pages.index(of: viewController)!
        
        // if you prefer to NOT scroll circularly, simply add here:
        // if cur == 0 { return nil }
        
        let prev = abs((cur - 1) % pages.count)
        return pages[prev]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController)-> UIViewController? {
        
        let cur = pages.index(of: viewController)!
        
        // if you prefer to NOT scroll circularly, simply add here:
        // if cur == (pages.count - 1) { return nil }
        
        let nxt = abs((cur + 1) % pages.count)
        return pages[nxt]
    }
    
    func presentationIndex(for pageViewController: UIPageViewController)-> Int {
        return pages.count
    }
}
    

