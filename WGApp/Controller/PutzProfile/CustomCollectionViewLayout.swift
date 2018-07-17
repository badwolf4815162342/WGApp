import UIKit

class CustomCollectionViewLayout: UICollectionViewLayout {
    
    // Used for calculating each cells CGRect on screen.
    // CGRect will define the Origin and Size of the cell.
    let CELL_HEIGHT_HEADER = 30.0
    let CELL_HEIGHT_NORMAL = 150.0
    let CELL_WIDTH = 150.0
    let STATUS_BAR = UIApplication.shared.statusBarFrame.height
    
    // Dictionary to hold the UICollectionViewLayoutAttributes for
    // each cell. The layout attribtues will define the cell's size
    // and position (x, y, and z index). I have found this process
    // to be one of the heavier parts of the layout. I recommend
    // holding onto this data after it has been calculated in either
    // a dictionary or data store of some kind for a smooth performance.
    var cellAttrsDictionary = Dictionary<IndexPath, UICollectionViewLayoutAttributes>()
    
    // Defines the size of the area the user can move around in
    // within the collection view.
    var contentSize = CGSize.zero
    
    // Used to determine if a data source update has occured.
    // Note: The data source would be responsible for updating
    // this value if an update was performed.
    var dataSourceDidUpdate = true
    
    override var collectionViewContentSize : CGSize {
        return self.contentSize
    }
    
    override func prepare() {
        
        // Only update header cells.
        if !dataSourceDidUpdate {
            
            // Determine current content offsets.
            let xOffset = collectionView!.contentOffset.x
            let yOffset = collectionView!.contentOffset.y
            
            if let sectionCount = collectionView?.numberOfSections, sectionCount > 0 {
                for section in 0...sectionCount-1 {
                    
                    // Confirm the section has items.
                    if let rowCount = collectionView?.numberOfItems(inSection: section), rowCount > 0 {
                        
                        // Update all items in the first row.
                        if section == 0 {
                            for item in 0...rowCount-1 {
                                // Build indexPath to get attributes from dictionary.
                                let indexPath = IndexPath(item: item, section: section)
                                
                                // Update y-position to follow user.
                                if let attrs = cellAttrsDictionary[indexPath] {
                                    var frame = attrs.frame
                                    
                                    // Also update x-position for corner cell.
                                    if item == 0 {
                                        frame.origin.x = xOffset
                                    }
                                    
                                    frame.origin.y = yOffset
                                    attrs.frame = frame
                                }
                                
                            }
                            
                            // For all other sections, we only need to update
                            // the x-position for the fist item.
                        } else {
                            /**
                            // Build indexPath to get attributes from dictionary.
                            let indexPath = IndexPath(item: 0, section: section)
                            
                            // Update y-position to follow user.
                            if let attrs = cellAttrsDictionary[indexPath] {
                                var frame = attrs.frame
                                frame.origin.x = xOffset
                                attrs.frame = frame
                            }**/
                            
                        } // else
                    } // num of items in section > 0
                } // sections for loop
            } // num of sections > 0
            
            
            // Do not run attribute generation code
            // unless data source has been updated.
            return
        }
        
        // Acknowledge data source change, and disable for next time.
        dataSourceDidUpdate = false
        
        // Cycle through each section of the data source.
        if let sectionCount = collectionView?.numberOfSections, sectionCount > 0 {
            for section in 0...sectionCount-1 {
                
                // Cycle through each item in the section.
                if let rowCount = collectionView?.numberOfItems(inSection: section), rowCount > 0 {
                    for item in 0...rowCount-1 {
                        
                        // Build the UICollectionVieLayoutAttributes for the cell.
                        let cellIndex = IndexPath(item: item, section: section)
                        
                        //let xPos = Double(item) * CELL_WIDTH
                        var calculatedCellWidth: Double
                        var calculatedCellHeight: Double
                        var xPos: Double
                        var yPos: Double
                        var preitem = item + CONFIG.PUTZSETTINGS.WEEKS_BACK_IN_CALENDER
                        var repeatEveryWeeks = 0
                        if (section != 0) {
                            var putzProfil = PutzProfilCalenderVC.profiles![section-1]
                            var posDiff = posDiffFromStartDayOnTable(putzProfil: putzProfil)
                            repeatEveryWeeks = Int(PutzProfilCalenderVC.profiles![section-1].repeatEveryXWeeks)
                            // breite x mal (repeatEveryXWeeks)
                            calculatedCellWidth = Double(Int(CELL_WIDTH) * repeatEveryWeeks)
                            if (repeatEveryWeeks == 1) {
                                xPos = Double(posDiff) + (Double(item/repeatEveryWeeks) * calculatedCellWidth)
                            } else {
                                xPos = Double(posDiff) + (Double(item/repeatEveryWeeks) * calculatedCellWidth)
                            }
                        } else {
                            calculatedCellWidth = CELL_WIDTH
                            xPos = Double(item) * calculatedCellWidth
                        }
                        /**
                        if section % 2 == 0 && section != 0  && item != 0 {
                            calculatedCellWidth = CELL_WIDTH * 2
                            xPos = Double(item) * calculatedCellWidth - CELL_WIDTH
                        } else {
                            calculatedCellWidth = CELL_WIDTH
                            xPos = Double(item) * calculatedCellWidth
                        }
 **/
                        if (section != 0) {
                            // jedes xte zeichnen, da es über x spalten geht
                            if (((item - CONFIG.PUTZSETTINGS.WEEKS_BACK_IN_CALENDER) % repeatEveryWeeks) == 0) {
                                calculatedCellHeight = CELL_HEIGHT_NORMAL
                                yPos = (Double(section) * calculatedCellHeight) - calculatedCellHeight + CELL_HEIGHT_HEADER
                            } else {
                                calculatedCellHeight = 0.0
                                calculatedCellWidth = 0.0
                                yPos = (Double(section) * calculatedCellHeight) - calculatedCellHeight + CELL_HEIGHT_HEADER
                            }
                        } else {
                            calculatedCellHeight = CELL_HEIGHT_HEADER
                            yPos = (Double(section) * calculatedCellHeight)
                        }
                        
                        let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: cellIndex)
                        cellAttributes.frame = CGRect(x: xPos, y: yPos, width: calculatedCellWidth, height: calculatedCellHeight)
   
                        // Save the attributes.
                        cellAttrsDictionary[cellIndex] = cellAttributes
                        
                    }
                }
                
            }
        }
        
        // Update content size.
        let contentWidth = Double(collectionView!.numberOfItems(inSection: 0)) * CELL_WIDTH
        let contentHeight = (Double(collectionView!.numberOfSections) * CELL_HEIGHT_NORMAL) - CELL_HEIGHT_NORMAL + CELL_HEIGHT_HEADER
        self.contentSize = CGSize(width: contentWidth, height: contentHeight)
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        // Create an array to hold all elements found in our current view.
        var attributesInRect = [UICollectionViewLayoutAttributes]()
        
        // Check each element to see if it should be returned.
        for cellAttributes in cellAttrsDictionary.values {
            if rect.intersects(cellAttributes.frame) {
                attributesInRect.append(cellAttributes)
            }
        }
        
        // Return list of elements.
        return attributesInRect
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cellAttrsDictionary[indexPath]!
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    func posDiffFromStartDayOnTable(putzProfil: PutzSetting) -> Int{
        var length = Int(putzProfil.repeatEveryXWeeks)
        var startDate: Date = putzProfil.startDate as! Date
        var startDateOfCalender = PutzProfilCalenderVC.calenderFirstWeekStart
        while (startDate < startDateOfCalender!) {
            startDate = startDate.add(days: (length*7))
        }
        var weekDiff = startDate.days(from: startDateOfCalender!)/7
        var posDiff = Int(CELL_WIDTH) * weekDiff
        print("posDiff \(posDiff)")
        return posDiff
    }
    
}
