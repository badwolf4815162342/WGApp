//
//  PutzProfilCalenderVC.swift
//  WGApp
//
//  Created by Viviane Rehor on 11.07.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit
import CoreData

let reuseIdentifier = "customCell"
let itemIdentifier = "putzItemCell"

class PutzProfilCalenderVC: UICollectionViewController {
    
    var numberOfPutzSettings = 0
    static var calenderFirstWeekStart : Date?
    static var calenderFirstlastWeekEnd: Date?
    static var profiles: [PutzSetting]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        PutzProfilCalenderVC.calenderFirstWeekStart = HomeScreenVC.thisWeekStart?.subtract(days: (7*CONFIG.PUTZSETTINGS.WEEKS_BACK_IN_CALENDER))
        PutzProfilCalenderVC.calenderFirstlastWeekEnd = HomeScreenVC.thisWeekEnd?.subtract(days: (7*CONFIG.PUTZSETTINGS.WEEKS_BACK_IN_CALENDER))
        refresh()
    }
    
    func refresh() {
        let fetchRequest: NSFetchRequest<PutzSetting> = PutzSetting.fetchRequest()
        do {
            let profiles = try PersistenceService.context.fetch(fetchRequest)
            numberOfPutzSettings = profiles.count
            PutzProfilCalenderVC.profiles = profiles
        } catch {
            print("core data couldn't be loaded")
        }
        self.collectionView?.reloadData()
    }

   
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        // number of
        return numberOfPutzSettings+1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        // down
        return CONFIG.PUTZSETTINGS.NEXT_X_WEEKS_PUTZSETTINGS_ARE_CALCULATED_FOR + CONFIG.PUTZSETTINGS.WEEKS_BACK_IN_CALENDER
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let addingDays = (7 * (Int(indexPath.item.description)!))
        let actWeekStart = PutzProfilCalenderVC.calenderFirstWeekStart?.add(days: addingDays)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CustomCollectionViewCell
        if (Int(indexPath.section.description) == 0) {
            //print("Weeks from current \(Int(indexPath.item.description)!)")
            cell.label.text = getWeekDates(weeksFromCurrent: Int(indexPath.item.description)!)
            if (actWeekStart == HomeScreenVC.thisWeekStart) {
                cell.backgroundColor = UIColor.init(named: "GREEN")
            }
        } else {
            let icell = collectionView.dequeueReusableCell(withReuseIdentifier: itemIdentifier, for: indexPath) as!
            PutzItemViewCell
            let actPutzSetting = PutzProfilCalenderVC.profiles![Int(indexPath.section.description)!-1]
            // Configure the cell
            icell.setPutzItemFromPutzProfile(putzProfile: actPutzSetting, startDate: actWeekStart!)
            return icell
        }
        return cell
    }
    
    func getWeekDates(weeksFromCurrent: Int) -> String{
        var addingDays = (7 * (weeksFromCurrent))
        var weekStart = PutzProfilCalenderVC.calenderFirstWeekStart?.add(days: addingDays)
        var weekEnd = PutzProfilCalenderVC.calenderFirstlastWeekEnd?.add(days: addingDays)
        let outFormatter = DateFormatter()
        outFormatter.dateFormat = "dd.MM.yy"
        return "\(outFormatter.string(from: weekStart!)) bis \(outFormatter.string(from: weekEnd!))"
    }
}

extension Date {
    
    /// Returns a Date with the specified days added to the one it is called with
    func add(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date {
        var targetDay: Date
        targetDay = Calendar.current.date(byAdding: .year, value: years, to: self)!
        targetDay = Calendar.current.date(byAdding: .month, value: months, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .day, value: days, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .hour, value: hours, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .minute, value: minutes, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .second, value: seconds, to: targetDay)!
        return targetDay
    }
    
    /// Returns a Date with the specified days subtracted from the one it is called with
    func subtract(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date {
        let inverseYears = -1 * years
        let inverseMonths = -1 * months
        let inverseDays = -1 * days
        let inverseHours = -1 * hours
        let inverseMinutes = -1 * minutes
        let inverseSeconds = -1 * seconds
        return add(years: inverseYears, months: inverseMonths, days: inverseDays, hours: inverseHours, minutes: inverseMinutes, seconds: inverseSeconds)
    }
    
    static func today() -> Date {
        return Date()
    }
    
    func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.Next,
                   weekday,
                   considerToday: considerToday)
    }
    
    func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.Previous,
                   weekday,
                   considerToday: considerToday)
    }
    
    func get(_ direction: SearchDirection,
             _ weekDay: Weekday,
             considerToday consider: Bool = false) -> Date {
        
        let dayName = weekDay.rawValue
        
        let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }
        
        assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
        
        let searchWeekdayIndex = weekdaysName.index(of: dayName)! + 1
        
        let calendar = Calendar(identifier: .gregorian)
        
        if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
            return self
        }
        
        var nextDateComponent = DateComponents()
        nextDateComponent.weekday = searchWeekdayIndex
        
        
        let date = calendar.nextDate(after: self,
                                     matching: nextDateComponent,
                                     matchingPolicy: .nextTime,
                                     direction: direction.calendarSearchDirection)
        
        return date!
    }
    
}

// MARK: Helper methods
extension Date {
    func getWeekDaysInEnglish() -> [String] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar.weekdaySymbols
    }
    
    enum Weekday: String {
        case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    }
    
    enum SearchDirection {
        case Next
        case Previous
        
        var calendarSearchDirection: Calendar.SearchDirection {
            switch self {
            case .Next:
                return .forward
            case .Previous:
                return .backward
            }
        }
    }
}
