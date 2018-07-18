//
//  DebtsLayout.swift
//  WGApp
//
//  Created by Anna Abad on 18.07.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit

class DebtsLayout: UICollectionViewLayout {

    let CELL_HEIGHT = 60.0
    let CELL_WIDTH = 95.0
    
    var cellAttrsDictionary = Dictionary<IndexPath, UICollectionViewLayoutAttributes>()
    var contentSize = CGSize.zero
    var dataSourceDidUpdate = true
    
    
    override var collectionViewContentSize : CGSize {
        return self.contentSize
    }
    
    override func prepare(){
        
        // Only update header cells.
        if !dataSourceDidUpdate {
            let yOffset = collectionView!.contentOffset.y
            if let sectionCount = collectionView?.numberOfSections, sectionCount > 0 {
                for section in 0...sectionCount-1 {
                    if let rowCount = collectionView?.numberOfItems(inSection: section), rowCount > 0 {
                        if section == 0 {
                            for item in 0...rowCount-1 {
                                let indexPath = IndexPath(item: item, section: section)
                                if let attrs = cellAttrsDictionary[indexPath] {
                                    var frame = attrs.frame
                                    frame.origin.y = yOffset
                                    attrs.frame = frame
                                }
                            }
                        }
                    }
                }
            }
            return
        }
        
        dataSourceDidUpdate = false
     
        if let sectionCount = collectionView?.numberOfSections, sectionCount > 0 {
            for section in 0...sectionCount-1 {
                if let rowCount = collectionView?.numberOfItems(inSection: section), rowCount > 0 {
                    for item in 0...rowCount-1 {
                        let cellIndex = IndexPath(item: item, section: section)
                        let xPos = Double(item) * CELL_WIDTH
                        let yPos = Double(section) * CELL_HEIGHT

                        let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: cellIndex)
                        cellAttributes.frame = CGRect(x: xPos, y: yPos, width: CELL_WIDTH, height: CELL_HEIGHT)
                        
                        if section == 0 {
                            cellAttributes.zIndex = 2
                        } else {
                            cellAttributes.zIndex = 1
                        }
                        
                        // save the attributes
                        cellAttrsDictionary[cellIndex] = cellAttributes
                    }
                }
            }
        }
        // Update content size.
        let contentWidth = Double(collectionView!.numberOfItems(inSection: 0)) * CELL_WIDTH
        let contentHeight = (Double(collectionView!.numberOfSections) * CELL_HEIGHT)
        self.contentSize = CGSize(width: contentWidth, height: contentHeight)
    }
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributesInRect = [UICollectionViewLayoutAttributes]()
        for cellAttributes in cellAttrsDictionary.values {
            if rect.intersects(cellAttributes.frame) {
                attributesInRect.append(cellAttributes)
            }
        }
        return attributesInRect
    }
    
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cellAttrsDictionary[indexPath]!
    }
    
    
    // force the collection view to call prepare every time the bounds change
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
}


