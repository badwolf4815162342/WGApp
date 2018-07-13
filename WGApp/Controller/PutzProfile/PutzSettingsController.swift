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
        } catch {
            print("core data couldn't be loaded")
        }
        calculateOrder(putzProfile: newPutzProfile)
        newPutzProfile.aktiv = false
        newPutzProfile.repeatEveryXWeeks = 1
        PersistenceService.saveContext()
        //for user in getOrderedUsers(ofProfile: newPutzProfile) {
            //print(user.name)
        //}
        return newPutzProfile
    }
    
    class func calculateOrder(putzProfile: PutzSetting){
        var userOrder: [String] = []
        var users: [User] = (putzProfile.participatingUsers?.toArray())!
        users.shuffle()
        for user in users {
            //print(user.name)
            userOrder.append(user.name!)
        }
        putzProfile.userOrder = userOrder as NSObject
        calculateItems(withOrder: users)
    }
    
    class func calculateItems(withOrder: [User]) {
        // calculate Items for next 26 weeks
    }
    
    class func getOrderedUsers(ofProfile: PutzSetting) -> [User]{
        var names: [String] = ofProfile.userOrder as! [String]
        var users: [User] = []
        var partUsers: [User] = (ofProfile.participatingUsers?.toArray())!
        for name in names {
            for user in partUsers {
                if(user.name == name) {
                    users.append(user)
                }
            }
        }
        return users
    }
    
}

extension MutableCollection {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffle() {
        for i in indices.dropLast() {
            let diff = distance(from: i, to: endIndex)
            let j = index(i, offsetBy: numericCast(arc4random_uniform(numericCast(diff))))
            swapAt(i, j)
        }
    }
}

extension Collection {
    /// Return a copy of `self` with its elements shuffled
    func shuffled() -> [Element] {
        var list = Array(self)
        list.shuffle()
        return list
    }
}
