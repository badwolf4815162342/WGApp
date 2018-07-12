//
//  PutzSettingsController.swift
//  WGApp
//
//  Created by Viviane Rehor on 11.07.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import Foundation
import CoreData

class PutzSettingsController: NSObject {
    
    class func deletePutzProfile(putzProfile: PutzSetting) {
        PersistenceService.context.delete(putzProfile)
    }
    
    class func createEmptyPutzSetting(title: String) -> PutzSetting {
        var newPutzProfile = PutzSetting(context: PersistenceService.context)
        newPutzProfile.title = title
  
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        do {
            let profiles = try PersistenceService.context.fetch(fetchRequest)
            newPutzProfile.participatingUsers = NSSet(array : profiles)
            // self.collectionView.reloadData()
        } catch {
            print("core data couldn't be loaded")
        }
        calculateOrder(putzProfile: newPutzProfile)
        
        return newPutzProfile
    }
    
    class func calculateOrder(putzProfile: PutzSetting){
        var users = putzProfile.participatingUsers
        if let set = users {
            var order = set
        }
    }
    
}
