//
//  PutzSettingsController.swift
//  WGApp
//
//  Created by Viviane Rehor on 11.07.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import Foundation

class PutzSettingsController: NSObject {
    
    class func deletePutzProfile(putzProfile: PutzSetting) {
        PersistenceService.context.delete(putzProfile)
    }
    
}
