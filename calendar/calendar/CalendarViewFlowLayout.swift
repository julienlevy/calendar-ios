//
//  CalendarViewFlowLayout.swift
//  calendar
//
//  Created by Julien Levy on 25/01/2016.
//  Copyright © 2016 Julien. All rights reserved.
//

import UIKit

class CalendarViewFlowLayout: UICollectionViewFlowLayout {
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        if let cv = self.collectionView {
            let contentSize: CGSize = cv.contentSize
            
            //Taking rect of width 10 for performance purposes to only have the views in the first column not to loop through useless items
            if let attributesForVisibleCells = self.layoutAttributesForElementsInRect(CGRectMake(0, 0, 10, contentSize.height)) {
                var candidateAttributes : UICollectionViewLayoutAttributes?
                
                for attributes in attributesForVisibleCells {
                    
                    // == Skip comparison with non-cell items (headers and footers) == //
                    if attributes.representedElementCategory != UICollectionElementCategory.Cell {
                        continue
                    }
                    
                    if candidateAttributes == nil {
                        candidateAttributes = attributes;
                        continue;
                    }
                    
                    // Compare distance to origin of a view to previous target offset to find view with min
                    if fabsf(Float(attributes.frame.origin.y - proposedContentOffset.y)) < fabsf(Float(candidateAttributes!.frame.origin.y - proposedContentOffset.y)) {
                        candidateAttributes = attributes;
                    }
                }
                
                return CGPoint(x: proposedContentOffset.x, y: round(candidateAttributes!.frame.origin.y))
            }
            
        }
        
        // Fallback
        return super.targetContentOffsetForProposedContentOffset(proposedContentOffset)
    }
    
}