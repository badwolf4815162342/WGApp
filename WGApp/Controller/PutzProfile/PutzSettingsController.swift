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
    
    /**
     * Delete Putzprofile and all its items
     **/
    class func deletePutzProfile(putzProfile: PutzSetting) {
        deleteAllItems(ofPutzSetting: putzProfile)
        PersistenceService.saveContext()
        PersistenceService.context.delete(putzProfile)
    }
    
    /**
     * create putzprofile without participating users and order
     **/
    class func createEmptyPutzSetting(title: String) -> PutzSetting {
        let newPutzProfile = PutzSetting(context: PersistenceService.context)
        newPutzProfile.title = title
        
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        do {
            let profiles = try PersistenceService.context.fetch(fetchRequest)
            newPutzProfile.participatingUsers = NSSet(array : profiles)
        } catch {
            print("ERROR: core data couldn't be loaded")
        }
        newPutzProfile.repeatEveryXWeeks = 1
        newPutzProfile.aktiv = false
        newPutzProfile.startDate = (Date.today().previous(.monday,
                                                          considerToday: true)) as NSDate
        newPutzProfile.profilIcon = "info"
        PersistenceService.saveContext()
        return newPutzProfile
    }
    
    /**
     * Delete all items of putzprofile
     **/
    class func deleteAllItems(ofPutzSetting: PutzSetting) {
        ofPutzSetting.userOrder = nil
        for item in ofPutzSetting.weekItems! {
           PersistenceService.context.delete((item as! PutzWeekItem))
        }
        PersistenceService.saveContext()
    }
    
    /**
     * calculate userOrder from participating users
     **/
    class func calculateOrder(putzProfile: PutzSetting){
        deleteAllItems(ofPutzSetting: putzProfile)
        var userOrder: [String] = []
        var users: [User] = (putzProfile.participatingUsers?.toArray())!
        users.shuffle()
        for user in users {
            userOrder.append(user.name!)
        }
        putzProfile.userOrder = userOrder as NSObject
        calculateItems(withOrder: users, putzProfile: putzProfile)
        PersistenceService.saveContext()
    }
    
    /**
     * Calculate the next 26 putzitems from now on
     **/
    class func calculateItems(withOrder: [User], putzProfile: PutzSetting) {
        var user = withOrder[0]
        // calculate Items for next 26 weeks
        for i in 0...(CONFIG.PUTZSETTINGS.PRE_CALCULATED_WEEK_ITEMS/Int(putzProfile.repeatEveryXWeeks)) {
            let newPutzItem = PutzWeekItem(context: PersistenceService.context)
            newPutzItem.putzSetting = putzProfile
            newPutzItem.done = false
            newPutzItem.numberOfWeeks = putzProfile.repeatEveryXWeeks
            let date = Date.today().previous(.monday,
                                             considerToday: true).add(days: (i*7*Int(newPutzItem.numberOfWeeks)))
            newPutzItem.weekStartDay = date as NSDate
            newPutzItem.weekEndDate = date.add(days: ((7*Int(newPutzItem.numberOfWeeks))-1)) as NSDate
            newPutzItem.user = user
            user = withOrder.after(user, loop: true)!
            PersistenceService.saveContext()
        }
    }
    
    /**
     * get Users who participate on putzProfile with specific order
     **/
    class func getOrderedUsers(ofProfile: PutzSetting) -> [User]{
        let names: [String] = ofProfile.userOrder as! [String]
        var users: [User] = []
        let partUsers: [User] = (ofProfile.participatingUsers?.toArray())!
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


extension BidirectionalCollection where Iterator.Element: Equatable {
    typealias Element = Self.Iterator.Element
    
    func after(_ item: Element, loop: Bool = false) -> Element? {
        if let itemIndex = self.index(of: item) {
            let lastItem: Bool = (index(after:itemIndex) == endIndex)
            if loop && lastItem {
                return self.first
            } else if lastItem {
                return nil
            } else {
                return self[index(after:itemIndex)]
            }
        }
        return nil
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
