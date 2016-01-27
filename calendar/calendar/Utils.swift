//
//  Utils.swift
//  calendar
//
//  Created by Julien Levy on 24/01/2016.
//  Copyright © 2016 Julien. All rights reserved.
//

import UIKit

let dayHeaderViewHeight: CGFloat = 20

let minimalRowHeight: CGFloat = 30
let rowLateralInset: CGFloat = 5.0
let rowHeaderHeight: CGFloat = 27.0
let temperatureRowVerticalInset: CGFloat = 10.0
let rowVerticalInset: CGFloat = 15.0
let rowEventTypeCenterX: CGFloat = 60.0
let rowEventTitleYOrigin: CGFloat = 80.0

let calendarVerticalInset: CGFloat = 5.0

extension UIColor {
    class func sunriseSpecialColor() -> UIColor {
        return UIColor(red: 247.0/255, green: 88.0/255, blue: 94.0/255, alpha: 1.0)
    }
    class func sunriseBlueColor() -> UIColor {
        return UIColor(red: 47.0/255, green: 139.0/255, blue: 225.0/255, alpha: 1.0)
    }
    class func sunriseCalendarHighlightedColor() -> UIColor {
        return UIColor(red: 239.0/255, green: 239.0/255, blue: 244.0/255, alpha: 1.0)
    }
    
    class func sunriseGrayTextColor() -> UIColor {
        return UIColor(red: 142.0/255, green: 142.0/255, blue: 147.0/255, alpha: 1.0)
    }
    class func sunriseDefaultGrayBackgrund() -> UIColor {
        return UIColor(white: 245.0/255, alpha: 1.0)
    }
    class func sunrisePastCalendarGrayBackground() -> UIColor {
        return UIColor(white: 248.0/255, alpha: 1.0)
    }
    class func sunriseFutureCalendarGrayBackground() -> UIColor {
        return UIColor.whiteColor()
    }
    
    
}