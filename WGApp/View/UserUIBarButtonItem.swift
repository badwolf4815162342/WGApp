//
//  UserUIBarButtonItem.swift
//  WGApp
//
//  Created by Anna Abad on 04.07.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit

class UserUIButton: UIButton {
    var user: Profil?
    var insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 30)
    
    override var alignmentRectInsets: UIEdgeInsets{
        get{
            return insets
        }
    }
}
