//
//  CalendarViewCell.swift
//  calendar
//
//  Created by Julien Levy on 23/01/2016.
//  Copyright © 2016 Julien. All rights reserved.
//

import UIKit

class CalendarViewCell: UICollectionViewCell {
    var isPast: Bool = false
    var isToday: Bool = false
    var day: Int = 0
    var month: String = "Jan"
    var numberOfEvents: Int = 0
    
    let dayLabel = UILabel()
    let monthLabel = UILabel()
    var eventsView: CircleView = CircleView(color: UIColor.clearColor())
    var selectedView: CircleView = CircleView(color: UIColor.blueColor())
    var highlightedView: CircleView = CircleView(color: UIColor.lightGrayColor())
    
    var monthHeightConstraint: NSLayoutConstraint = NSLayoutConstraint()

    override init(frame: CGRect) {
        
        
        super.init(frame: frame)
        
        self.setSubviewsAttributes()
        
        self.addSubview(eventsView)
        self.addSubview(highlightedView)
        self.addSubview(selectedView)
        self.addSubview(dayLabel)
        self.addSubview(monthLabel)
        
        self.setConstraints()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func reloadDisplay() {
        self.setSubviewsAttributes()
        
        self.monthHeightConstraint.constant = (self.shouldDisplayMonth() ? 20 : 0)
        
        self.layoutIfNeeded()
    }

    func setCellInfo(day: Int, month: String, past: Bool, today: Bool, events: Int) {
        self.day = day
        self.month = month
        self.isPast = past
        self.isToday = today
        self.numberOfEvents = events
        
        self.setSubviewsAttributes()
        
        self.monthHeightConstraint.constant = (self.shouldDisplayMonth() ? 20 : 0)
        
        self.layoutIfNeeded()
    }
    func setSubviewsAttributes(){
        self.backgroundColor = (self.isPast && !self.isToday ? pastBackgroundColor : normalBackgroundColor)
        
        self.selectedView.hidden = !self.selected
        self.highlightedView.hidden = !self.highlighted
        
        self.eventsView.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.2 * CGFloat(self.numberOfEvents))
        
        self.dayLabel.text = String(self.day)
        self.monthLabel.text = self.month
        
        self.dayLabel.textAlignment = .Center
        self.monthLabel.textAlignment = .Center
        
        self.monthLabel.textColor = sunriseSpecialColor
        self.dayLabel.textColor = textColorForState()
        
        self.dayLabel.font = UIFont.systemFontOfSize(16)
        self.monthLabel.font = UIFont.systemFontOfSize(12)
        
//        self.dayLabel.backgroundColor = UIColor.magentaColor()
//        self.monthLabel.backgroundColor = UIColor.greenColor()
    }
    
    func textColorForState() -> UIColor {
        if self.highlighted || self.selected {
            return UIColor.whiteColor()
        }
        if self.day == 1 {
            return sunriseSpecialColor
        }
        if self.isToday {
            return todayColor
        }
        return normalDayColor
    }
    
    func shouldDisplayMonth() -> Bool {
        return self.day == 1 && !self.selected && !self.highlighted
    }
    
    func setConstraints() {
        self.monthLabel.translatesAutoresizingMaskIntoConstraints = false
        let topMonth: NSLayoutConstraint = NSLayoutConstraint(item: self.monthLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: calendarVerticalInset)
        let centerXMonth: NSLayoutConstraint = NSLayoutConstraint(item: self.monthLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        monthHeightConstraint = NSLayoutConstraint(item: self.monthLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 0)
        
        self.dayLabel.translatesAutoresizingMaskIntoConstraints = false
        let topDay: NSLayoutConstraint = NSLayoutConstraint(item: self.dayLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.monthLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        let leftDay: NSLayoutConstraint = NSLayoutConstraint(item: self.dayLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        let bottomDay: NSLayoutConstraint = NSLayoutConstraint(item: self.dayLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -calendarVerticalInset)
        
        self.eventsView.translatesAutoresizingMaskIntoConstraints = false
        let eventsCenterX: NSLayoutConstraint = NSLayoutConstraint(item: self.eventsView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        let eventsWidth: NSLayoutConstraint = NSLayoutConstraint(item: self.eventsView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 5)
        let eventsProportion: NSLayoutConstraint = NSLayoutConstraint(item: self.eventsView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.eventsView, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        let bottomEvents: NSLayoutConstraint = NSLayoutConstraint(item: self.eventsView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -5)
        
        
        self.selectedView.translatesAutoresizingMaskIntoConstraints = false
        let selectedCenterX: NSLayoutConstraint = NSLayoutConstraint(item: self.selectedView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        let selectedCenterY: NSLayoutConstraint = NSLayoutConstraint(item: self.selectedView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        let selectedWidth: NSLayoutConstraint = NSLayoutConstraint(item: self.selectedView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: -2 * calendarVerticalInset)
        let selectedProportion: NSLayoutConstraint = NSLayoutConstraint(item: self.selectedView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.selectedView, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        
        self.highlightedView.translatesAutoresizingMaskIntoConstraints = false
        let highlightedCenterX: NSLayoutConstraint = NSLayoutConstraint(item: self.highlightedView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        let highlightedCenterY: NSLayoutConstraint = NSLayoutConstraint(item: self.highlightedView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        let highlightedWidth: NSLayoutConstraint = NSLayoutConstraint(item: self.highlightedView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: -2 * calendarVerticalInset)
        let highlightedProportion: NSLayoutConstraint = NSLayoutConstraint(item: self.highlightedView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.highlightedView, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        
        self.addConstraints([topMonth, centerXMonth, topDay, leftDay, bottomDay, selectedCenterX, selectedCenterY, selectedWidth, selectedProportion, highlightedCenterX, highlightedCenterY, highlightedWidth, highlightedProportion, eventsCenterX, eventsWidth, eventsProportion, bottomEvents, monthHeightConstraint])
    }
}
