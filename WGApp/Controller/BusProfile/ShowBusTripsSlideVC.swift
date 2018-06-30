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

       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear of ShowBusTripsSlideVC")
        let fetchRequest: NSFetchRequest<BusSettings> = BusSettings.fetchRequest()
        do {
            let profiles = try PersistenceService.context.fetch(fetchRequest)
            var busSettings = profiles
            for profile in busSettings {
                if (profile.withDestinations) {
                    let vc: ShowBusTripsTableVC! = (storyboard?.instantiateViewController(withIdentifier: "busTripsTableView"))! as! ShowBusTripsTableVC
                    vc.selectedBusProfile = profile
                    pages.append(vc)
                } else {
                    let vc: ShowBusDepartureTableVC! = (storyboard?.instantiateViewController(withIdentifier: "busDeparturesTableView"))! as! ShowBusDepartureTableVC
                    vc.selectedBusProfile = profile
                    pages.append(vc)
                }
            }
        } catch {}
        
         setViewControllers([pages[0]], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
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
    

