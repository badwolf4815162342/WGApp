//
//  PutzProfileTableViewCell.swift
//  WGApp
//
//  Created by Viviane Rehor on 11.07.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit

class PutzProfileTableViewCell: UITableViewCell {
    

    @IBOutlet weak var putzProfileTitleLabel: UILabel!
    @IBOutlet weak var putzIcon: UIImageView!
    var putzprofile: PutzSetting?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setPutzprofile(putzProfile: PutzSetting) {
        putzprofile = putzProfile
        
        putzProfileTitleLabel.text = putzprofile?.title
        let userIconString = putzprofile?.profilIcon
        if userIconString != nil, let image = UIImage(named: userIconString!) {
            putzIcon.image = image
        } else {
            putzIcon.image = UIImage(named: "info")
        }
        
    }

}
