//
//  UIStopLocationUIStopLocationSearchTextField.swift
//  WGApp
//
//  Created by Viviane Rehor on 03.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit

class UIStopLocationSearchTextField: SearchTextField {

    func filterStopLocations(stopLocations: [StopLocationRMV]) {
        var items = [SearchTextFieldItem]()
        
        for value in stopLocations {
            items.append(SearchTextFieldItem(rmvStopLocation: value))
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
        RMVApiController.getStoplocations(withEntryString: self.text!, completion: { stopLocations in
            DispatchQueue.main.async {
                self.showLoadingIndicator()
                print("NetworkStoplocations for \(self.text!): \(stopLocations.count)")
                //self.filterStrings(stopLocations.map { $0.name })
                self.filterStopLocations(stopLocations: stopLocations)
                self.filter(forceShowAll: addAll)
                self.prepareDrawTableResult()
                if let header = self.resultsListHeader {
                    if let headerLabel = header as? UILabel {
                        headerLabel.text = ("\(self.filteredResults.count)/\(stopLocations.count): Onlineergebnisse")
                    }
                }
                print("NetworkStoplocations for \(self.text!): \(stopLocations.count) done!")
                self.stopLoadingIndicator()
            }
            
            
        })
    }
    
    func filterKnownStopLocations(forceShowAll addAll: Bool) {
        let stopLocations = getKnownStopLocations()
        self.filterStopLocations(stopLocations: stopLocations)
        self.filter(forceShowAll: addAll)
        self.prepareDrawTableResult()
        if let header = self.resultsListHeader {
            if let headerLabel = header as? UILabel {
                headerLabel.text = ("\(filteredResults.count)/\(stopLocations.count): Oft gesucht")
            }
        }

    }
    
    func getKnownStopLocations() -> Array<StopLocationRMV> {
        var stopLocations = BusSettingsController.getAllStopLocations().map {StopLocationRMV.stopLocationToRmv(stopLocation: $0)}
        return stopLocations
    }
    
    @objc override open func textFieldDidChange() {
        print("-------------didchange")
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
            } else {//if text!.count == minCharactersNumberToStartFiltering {
                //print("Eingabetextlänge: \(text!.count), filterNetworkStopLocations")
                filterNewStopLocations(forceShowAll: forceNoFiltering)
            }
           /** else {
                //print("Eingabetextlänge: \(text!.count), filterActStopLocations")
                filter(forceShowAll: forceNoFiltering)
                prepareDrawTableResult()
                if let header = self.resultsListHeader {
                    if let headerLabel = header as? UILabel {
                        headerLabel.text = ("\(filteredResults.count)/\(filterDataSource.count): Ergebnisse")
                    }
                }
            }**/
        }
        //self.stopLoadingIndicator()
        buildPlaceholderLabel()
    }

}

