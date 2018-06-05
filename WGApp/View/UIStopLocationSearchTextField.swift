//
//  UIStopLocationUIStopLocationSearchTextField.swift
//  WGApp
//
//  Created by Viviane Rehor on 03.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit

class UIStopLocationSearchTextField: SearchTextField {
    
    public var rmvApiController : RMVApiController = RMVApiController()
    
    var selectedStopLocation: StopLocationRMV?
    
    /// Set an array of strings to be used for suggestions
    override open func filterStrings(_ strings: [String]) {
        var items = [SearchTextFieldItem]()
        for value in strings {
            items.append(SearchTextFieldItem(title: value))
        }
        filterItems(items)
    }
    
    override func filter(forceShowAll addAll: Bool) {
        clearResults()
        
        for i in 0 ..< filterDataSource.count {
            
            let item = filterDataSource[i]
            
            if !inlineMode {
                // Find text in title and subtitle
                let titleFilterRange = (item.title as NSString).range(of: text!, options: comparisonOptions)
                let subtitleFilterRange = item.subtitle != nil ? (item.subtitle! as NSString).range(of: text!, options: comparisonOptions) : NSMakeRange(NSNotFound, 0)
                
                if titleFilterRange.location != NSNotFound || subtitleFilterRange.location != NSNotFound || addAll {
                    item.attributedTitle = NSMutableAttributedString(string: item.title)
                    item.attributedSubtitle = NSMutableAttributedString(string: (item.subtitle != nil ? item.subtitle! : ""))
                    
                    item.attributedTitle!.setAttributes(highlightAttributes, range: titleFilterRange)
                    
                    if subtitleFilterRange.location != NSNotFound {
                        item.attributedSubtitle!.setAttributes(highlightAttributesForSubtitle(), range: subtitleFilterRange)
                    }
                    filteredResults.append(item)
                }
            } else {
                var textToFilter = text!.lowercased()
                
                if inlineMode, let filterAfter = startFilteringAfter {
                    if let suffixToFilter = textToFilter.components(separatedBy: filterAfter).last, (suffixToFilter != "" || startSuggestingInmediately == true), textToFilter != suffixToFilter {
                        textToFilter = suffixToFilter
                    } else {
                        placeholderLabel?.text = ""
                        return
                    }
                }
                
                if item.title.lowercased().hasPrefix(textToFilter) {
                    let indexFrom = textToFilter.index(textToFilter.startIndex, offsetBy: textToFilter.characters.count)
                    let itemSuffix = item.title[indexFrom...]
                    
                    item.attributedTitle = NSMutableAttributedString(string: String(itemSuffix))
                    filteredResults.append(item)
                }
            }
        }
        
        tableView?.reloadData()
        
        if inlineMode {
            handleInlineFiltering()
        }
    }
    
    func filterNewStopLocations(forceShowAll addAll: Bool) {
        self.rmvApiController.getTestStoplocations(withEntryString: self.text!, completion: { stopLocations in
            print("NetworkStoplocations for \(self.text!): \(stopLocations.count)")
            self.filterStrings(stopLocations.map { $0.name })
            self.filter(forceShowAll: addAll)
            self.prepareDrawTableResult()
            if let header = self.resultsListHeader {
                if let headerLabel = header as? UILabel {
                    headerLabel.text = ("\(self.filteredResults.count)/\(stopLocations.count): Onlineergebnisse")
                }
            }
            
        })
    }
    
    func filterKnownStopLocations(forceShowAll addAll: Bool) {
        let stopLocations = getKnownStopLocations()
        self.filterStrings(stopLocations.map { $0.name })
        self.filter(forceShowAll: addAll)
        self.prepareDrawTableResult()
        if let header = self.resultsListHeader {
            if let headerLabel = header as? UILabel {
                headerLabel.text = ("\(filteredResults.count)/\(stopLocations.count): Oft gesucht")
            }
        }

    }
    
    func getKnownStopLocations() -> Array<StopLocationRMV> {
        var stopLocations = [StopLocationRMV]()
        // TODO: Fetch DATABASE StopLocations
        let stopLocationWiHbf = StopLocationRMV(id: "001", name: "Wi Hbf" )
        let stopLocationMainzHbf = StopLocationRMV(id: "002", name: "Mainz Hbf" )
        let stopLocationFrHbf = StopLocationRMV(id: "003", name: "FR Hbf" )
        let stopLocationWiesHbf = StopLocationRMV(id: "004", name: "Wiesloch Hbf" )
        stopLocations.append(stopLocationWiHbf)
        stopLocations.append(stopLocationMainzHbf)
        stopLocations.append(stopLocationFrHbf)
        stopLocations.append(stopLocationWiesHbf)
        return stopLocations
    }
    
    @objc override open func textFieldDidChange() {
        if !inlineMode && tableView == nil {
            buildSearchTableView()
        }
        
        interactedWith = true
        
        // Detect pauses while typing
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: typingStoppedDelay, target: self, selector: #selector(SearchTextField.typingDidStop), userInfo: self, repeats: false)
        
        if text!.isEmpty {
            clearResults()
            tableView?.reloadData()
            self.placeholderLabel?.text = ""
            filterKnownStopLocations(forceShowAll: true)
        } else {
            if text!.count < minCharactersNumberToStartFiltering {
                //print("Eingabetextlänge: \(text!.count), filterKnownStopLocations")
                filterKnownStopLocations(forceShowAll: forceNoFiltering)
            } else if text!.count == minCharactersNumberToStartFiltering {
                //print("Eingabetextlänge: \(text!.count), filterNetworkStopLocations")
                filterNewStopLocations(forceShowAll: forceNoFiltering)
            } else {
                //print("Eingabetextlänge: \(text!.count), filterActStopLocations")
                filter(forceShowAll: forceNoFiltering)
                prepareDrawTableResult()
                if let header = self.resultsListHeader {
                    if let headerLabel = header as? UILabel {
                        headerLabel.text = ("\(filteredResults.count)/\(filterDataSource.count): Ergebnisse")
                    }
                }
            }
        }
        
        buildPlaceholderLabel()
    }


}
