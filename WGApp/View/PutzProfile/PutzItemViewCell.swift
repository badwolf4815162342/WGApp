//
//  PutzItemViewCell.swift
//  WGApp
//
//  Created by Viviane Rehor on 13.07.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit

class PutzItemViewCell: UICollectionViewCell {

    @IBOutlet weak var putzItemImageView: UIImageView!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var putzProfileTitle: UILabel!
    
    func setPutzItem(putzProfile: PutzSetting) {
        //putzProfileTitle = putzProfile.title
    }

}
