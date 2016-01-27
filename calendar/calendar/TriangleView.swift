//
//  TriangleView.swift
//  calendar
//
//  Created by Julien Levy on 27/01/2016.
//  Copyright © 2016 Julien. All rights reserved.
//

import UIKit

class TriangleView: UIView {
    override func drawRect(rect: CGRect) {
        let path = UIBezierPath()
        
        path.moveToPoint(CGPointMake(rect.origin.x, rect.origin.y))
        path.addLineToPoint(CGPointMake(rect.width, rect.height / 2.0))
        path.addLineToPoint(CGPointMake(rect.origin.x, rect.height))
        path.closePath()
        
        UIColor.sunriseSpecialColor().setFill()
        path.fill()
    }
}
