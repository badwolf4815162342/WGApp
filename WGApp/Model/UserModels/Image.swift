//
//  UIImageView.swift
//  WGApp
//
//  Created by Anna Abad on 11.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import Foundation
import UIKit

struct Image {
    var image: UIImage?
    var name: String?
    
    init(named name: String) {
        self.image = UIImage(named: name)
        self.name = name
    }
}
