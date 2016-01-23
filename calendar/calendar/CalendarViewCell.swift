//
//  CalendarViewCell.swift
//  calendar
//
//  Created by Julien Levy on 23/01/2016.
//  Copyright © 2016 Julien. All rights reserved.
//

import UIKit

let firstOfMonthColor: UIColor = UIColor.redColor()
let todayColor: UIColor = UIColor.blackColor()
let normalDayColor: UIColor = UIColor.grayColor()
let pastBackgroundColor: UIColor = UIColor.lightGrayColor()
let normalBackgroundColor: UIColor = UIColor.whiteColor()

class CalendarViewCell: UICollectionViewCell {
    var isPast: Bool = false
    var isToday: Bool = false
    var day: Int = 2
    var month: String = "Jan"
    
    let dayLabel = UILabel()
    let monthLabel = UILabel()
    
    func setCellInfo(day: Int, month: String, past: Bool, today: Bool) {
        self.day = day
        self.month = month
        self.isPast = past
        self.isToday = today
        setupView()
    }
    
    func setupView() {
        self.backgroundColor = (isPast && !isToday ? pastBackgroundColor : normalBackgroundColor)
        if day == 1 {
            setupMonthLabel()
            dayLabel.textColor = firstOfMonthColor
        }
        else {
            //Necessary because of UICollectioview Bug that reorders cells...
            monthLabel.frame = CGRectZero
            dayLabel.textColor = (isToday ? todayColor : normalDayColor)
        }
        dayLabel.text = String(day)
        dayLabel.textAlignment = .Center
        dayLabel.font = UIFont.systemFontOfSize(14)
        dayLabel.frame = CGRectMake(0, monthLabel.frame.height, self.frame.width, self.frame.height - monthLabel.frame.height)
        self.addSubview(dayLabel)
    }
    func setupMonthLabel() {
        monthLabel.text = month
        monthLabel.textAlignment = .Center
        monthLabel.textColor = firstOfMonthColor
        monthLabel.font = UIFont.systemFontOfSize(10)
        monthLabel.frame = CGRectMake(0, 0, self.frame.width, self.frame.height/4)
        self.addSubview(monthLabel)
    }
}
