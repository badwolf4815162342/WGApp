//
//  UserFavoritesVC.swift
//  WGApp
//
//  Created by Viviane Rehor on 06.07.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit
import CoreData

class UserFavoritesVC: UIViewController {
    
    var user: User!
    static var selectedBusProfile: BusSetting?
    var busSettings = [BusSetting]()
    
    @IBOutlet weak var userIconImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "BusProfilCell", bundle: nil), forCellReuseIdentifier: "BusPCell")

        //BusSettingsController.addTestBusSettings()
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 0))
        tableView.tableFooterView = footerView
        
        refresh()
        refreshTable()
        if busSettings.count == 0 {
            textLabel.text = "Es sind noch keine Busprofile vorhanden."
        } else {
            textLabel.text = "Favorisiere deine Busprofile:"
        }
    }
    
    
    @objc func refreshTable(){
        // load core data into table
        let fetchRequest: NSFetchRequest<BusSetting> = BusSetting.fetchRequest()
        do {
            let busSettings = try PersistenceService.context.fetch(fetchRequest)
            print(busSettings.count)
            self.busSettings = busSettings
            self.tableView.reloadData()
        } catch {}
    }
    
    func refresh() {
        let userIconString = user.profilIcon
        if userIconString != nil, let image = UIImage(named: userIconString!) {
            userIconImageView.image = image
        } else {
            userIconImageView.image = UIImage(named: "info") // TODO questionmark
            print("Picture of user could not be loaded !!! ")
        }
        userNameLabel.text = user.name
    }
    
    
}

extension UserFavoritesVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return busSettings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let busProfile = busSettings[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusPCell") as! BusProfilCell
        cell.setBusprofile(busSettings: busProfile)
        cell.setFavorite(busSetting: busProfile, profil: self.user)
        cell.favoriteImage.contentMode = UIViewContentMode.scaleAspectFit
        cell.userImageView.contentMode = UIViewContentMode.scaleAspectFit
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        BusSettingsController.changeProfilFavorite(busSetting: busSettings[indexPath.row], profil: self.user)
        let cell:UITableViewCell? = tableView.cellForRow(at: indexPath)
        cell?.selectionStyle = .none
        let bpCell = cell  as! BusProfilCell
        bpCell.setBusprofile(busSettings: busSettings[indexPath.row])
        bpCell.setFavorite(busSetting: busSettings[indexPath.row], profil: self.user)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50;
    }
  
    
}
