//
//  HomeScreenVC.swift
//  WGApp
//
//  Created by Viviane Rehor on 27.05.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit
import CoreData

class HomeScreenVC: UIViewController {
    
   
    @IBOutlet weak var timeLabel: UILabel!
    var timer = Timer()
    
    @IBOutlet weak var overlayView: UIImageView!
    static var wg: HomeProfil?
    
    static var selectedUser: Profil?
    
    var items:[UIBarButtonItem] = []
    
    var profiles: [Profil] = []
    
    static var thisWeekStart : Date?
    static var thisWeekEnd: Date?

    @IBOutlet weak var homeNavigationItem: UINavigationItem!
    

    
    func refreshUsers(){
        // load core data into users list
        let fetchRequest: NSFetchRequest<Profil> = Profil.fetchRequest()
        do {
            let profiles = try PersistenceService.context.fetch(fetchRequest)
            self.profiles = profiles
            // self.collectionView.reloadData()
        } catch {
            print("core data couldn't be loaded")
        }
    }
    
    func addNavigationBarItems(){
       
        // left: burger menu
        let moreBtn: UIButton = UIButton(type: .custom)
        moreBtn.setImage(UIImage(named: "burger"), for: .normal)
        moreBtn.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        moreBtn.addTarget(self, action: #selector(more(sender:)), for: .touchUpInside)
        moreBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: moreBtn)
        
        self.homeNavigationItem.leftBarButtonItem = barButton
        
        
        // right: user icons
        
        refreshUsers()
        items = []
        
        let userIconsWidth: CGFloat = 420
        
        let userSelectionStackView = UIStackView(frame: CGRect(x: 0, y: 0, width: userIconsWidth, height: 50))
        let userSelectionScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: userIconsWidth, height: 50))

        let widthContraints =  NSLayoutConstraint(item: userSelectionScrollView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: userIconsWidth)
        let heightContraints = NSLayoutConstraint(item: userSelectionScrollView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
        NSLayoutConstraint.activate([heightContraints,widthContraints])
        
        // STackview in scrollview für userSelection
        userSelectionStackView.translatesAutoresizingMaskIntoConstraints = false
        userSelectionStackView.axis = .horizontal
        userSelectionStackView.spacing = 25.0
        userSelectionScrollView.addSubview(userSelectionStackView)
        
        userSelectionScrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[stackView]|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: ["stackView": userSelectionStackView]))
        userSelectionScrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[stackView]|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: ["stackView": userSelectionStackView]))
        

        for user in profiles {
            let button: UserUIButton = UserUIButton(type: .custom)
            button.setImage(UIImage(named: user.profilIcon!), for: .normal)
            button.imageView?.contentMode = UIViewContentMode.scaleAspectFit
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 5
            button.layer.borderColor = UIColor.lightGray.cgColor
            button.addTarget(self, action: #selector(switchUser(sender:)), for: .touchUpInside)

            button.user = user
            
            
            button.translatesAutoresizingMaskIntoConstraints = false
            userSelectionStackView.addArrangedSubview(button)
            
            // all constaints to set size IMPORTANT!!!!
            let widthContraints =  NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
            let heightContraints = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
            NSLayoutConstraint.activate([heightContraints,widthContraints])
            
        }
        
        userSelectionStackView.semanticContentAttribute = .forceRightToLeft
        userSelectionScrollView.transform = CGAffineTransform.init(scaleX: -1, y: 1)
        
        let barButtonsRight = UIBarButtonItem(customView: userSelectionScrollView)
        self.homeNavigationItem.rightBarButtonItem = barButtonsRight
        
    }
    
    @objc func more(sender: UIBarButtonItem){
       toggleSideMenu()
    }
    
    @objc func toggleSideMenu() {
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
        overlayView.isHidden = !overlayView.isHidden
        if (overlayView.isHidden) {
            overlayView.isUserInteractionEnabled = false
        } else {
            overlayView.alpha = 0.6
            overlayView.isUserInteractionEnabled = true
            
        }
    }
    
    @objc func tick() {

        timeLabel.text = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .medium)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 1.0,
            target: self,
            selector: #selector(tick),
            userInfo: nil,
            repeats: true)
        overlayView.isUserInteractionEnabled = false
        self.view.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleSideMenu))
        overlayView.addGestureRecognizer(tapRecognizer)
        HomeScreenVC.thisWeekStart = Date.today().previous(.monday,
                                              considerToday: true)
        HomeScreenVC.thisWeekEnd = Date.today().previous(.monday,
                                            considerToday: true).add(days: 6)
        // DELETE all busprofile Data
        //BusSettingsController.deleteAllData(entity: "PutzWeekItem")
        //print("items deleted")
        //BusSettingsController.deleteAllData(entity: "BusRoute")
        //BusSettingsController.deleteAllData(entity: "StopLocation")
        NotificationCenter.default.addObserver(self, selector: #selector(showUserManagement), name: NSNotification.Name("ShowUserManagement"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showBusManagement), name: NSNotification.Name("ShowBusManagement"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showPutzManagement), name: NSNotification.Name("ShowPutzManagement"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showPutzPlan), name: NSNotification.Name("ShowPutzPlan"), object: nil)

        createWGUser()
        HomeScreenVC.selectedUser = HomeScreenVC.wg
        
        //let mask = UIView(coder: self.nscoder)
        //mask.set
        /*mask = [[UIView alloc] initWithFrame:window.frame];
        [mask setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.78]];
        [self.view addSubview:mask];*/

        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.isUserInteractionEnabled = true
        overlayView.isHidden = true
        addNavigationBarItems()
    }
    
    @objc func switchUser(sender: UserUIButton){
        print(sender.user?.name)
        HomeScreenVC.selectedUser = sender.user
        for item in items {
            item.customView?.layer.borderColor = UIColor.lightGray.cgColor
        }
        sender.layer.borderColor = UIColor.darkGray.cgColor
        
        NotificationCenter.default.post(name: NSNotification.Name("globalSelectedUserChanged"), object: nil)
    }
    
    @objc func showUserManagement() {
        performSegue(withIdentifier: "ShowUserManagement", sender: nil)
    }
    
    @objc func showBusManagement() {
        performSegue(withIdentifier: "ShowBusManagement", sender: nil)
    }
    
    @objc func showPutzManagement() {
        performSegue(withIdentifier: "ShowPutzManagement", sender: nil)
    }
    
    @objc func showPutzPlan() {
        performSegue(withIdentifier: "ShowPutzPlan", sender: nil)
    }
    
    func createWGUser () {
        let fetchRequest: NSFetchRequest<HomeProfil> = HomeProfil.fetchRequest()
        do {
            let homes = try PersistenceService.context.fetch(fetchRequest)
            if (homes.count == 0) {
                let home = HomeProfil(context: PersistenceService.context)
                home.name = "WG"
                home.profilIcon = "wg-icon"
                PersistenceService.saveContext()
                HomeScreenVC.wg = home
            } else {
                HomeScreenVC.wg = homes[0]
            }
        } catch {
            print("core data couldn't be loaded")
        }
        
    }
    
    @IBAction func unwindCreatePurchase(sender: UIStoryboardSegue){}
    
}
