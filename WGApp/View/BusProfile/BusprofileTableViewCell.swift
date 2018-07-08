//
//  BusprofileTableViewCell.swift
//  WGApp
//
//  Created by Viviane Rehor on 07.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit

class BusprofileTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var busprofileTitleLabel: UILabel!
    
    @IBOutlet weak var favoriteImage: UIImageView!
    var busprofile: BusSetting?
    
    func setBusprofile(busSettings: BusSetting) {
        busprofile = busSettings
        
        busprofileTitleLabel.text = busSettings.title
        var userIconString = busprofile?.ofProfil?.profilIcon
        if userIconString != nil, let image = UIImage(named: userIconString!) {
            userImageView.image = image
        } else {
            userImageView.image = UIImage(named: "Bear-icon")
            print("Picture of user could not be loaded !!! ")
        }
        
       
        
    }
    
    func setFavorite(busSetting: BusSetting, profil: Profil) {
        if (busSetting.favoriteOfProfiles?.contains(profil))! {
            favoriteImage.isHidden = false
        } else {
            favoriteImage.isHidden = true
        }
    }

}
