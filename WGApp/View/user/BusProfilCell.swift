//
//  BusProfilCell.swift
//  WGApp
//
//  Created by Anna Abad on 20.07.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit

class BusProfilCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var busprofileTitleLabel: UILabel!
    
    @IBOutlet weak var favoriteImage: UIImageView!
    var busprofile: BusSetting?

    func setBusprofile(busSettings: BusSetting) {
        busprofile = busSettings
        
        busprofileTitleLabel.text = busSettings.title
        let userIconString = busprofile?.ofProfil?.profilIcon
        if userIconString != nil, let image = UIImage(named: userIconString!) {
            userImageView.image = image
        } else {
            userImageView.image = UIImage(named: "info")
        }
        
    }
    
    func setFavorite(busSetting: BusSetting, profil: Profil) {
        if (busSetting.favoriteOfProfiles?.contains(profil))! {
            favoriteImage.image = UIImage(named: "star")
        } else {
            favoriteImage.image = UIImage(named: "starUnselect")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
