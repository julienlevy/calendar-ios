//
//  Utils.swift
//  calendar
//
//  Created by Julien Levy on 24/01/2016.
//  Copyright © 2016 Julien. All rights reserved.
//

import UIKit

let dayHeaderViewHeight: CGFloat = 20

let agendaHeaderHeight: CGFloat = 20

let minimalRowHeight: CGFloat = 30
let rowLateralInset: CGFloat = 15.0
let rowHeaderHeight: CGFloat = 27.0
let temperatureRowVerticalInset: CGFloat = 10.0
let cityNameToWeatherIconSpace: CGFloat = 4.0

let rowVerticalInset: CGFloat = 15.0
let rowVerticalSpaceWithin: CGFloat = 8.0

let rowEventTypeCenterX: CGFloat = 83.0
let rowEventTitleYOrigin: CGFloat = 103.0

let calendarVerticalInset: CGFloat = 5.0

let refToWeatherImageName = ["01d" : "weather-clear",
    "02d" : "weather-few",
    "03d" : "weather-few",
    "04d" : "weather-broken",
    "09d" : "weather-shower",
    "10d" : "weather-rain",
    "11d" : "weather-tstorm",
    "13d" : "weather-snow",
    "50d" : "weather-mist",
    "01n" : "weather-moon",
    "02n" : "weather-few-night",
    "03n" : "weather-few-night",
    "04n" : "weather-broken",
    "09n" : "weather-shower",
    "10n" : "weather-rain-night",
    "11n" : "weather-tstorm",
    "13n" : "weather-snow",
    "50n" : "weather-mist",
]

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
    class func sunriseDarkSpecialColor() -> UIColor {
        return UIColor(red: 209.0/255, green: 73.0/255, blue: 79.0/255, alpha: 1.0)
    }
    
}