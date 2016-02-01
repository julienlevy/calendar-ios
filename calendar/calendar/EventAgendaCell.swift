//
//  EventAgendaCell.swift
//  calendar
//
//  Created by Julien Levy on 24/01/2016.
//  Copyright © 2016 Julien. All rights reserved.
//

import UIKit

class EventAgendaCell: WeatherAgendaTableViewCell {
//    var isCurrent: Bool = false
    
    var triangleCurrentView: TriangleView = TriangleView()
    var timeLabel: UILabel = UILabel()
    var durationLabel: UILabel = UILabel()
    var eventTypeView: EventTypeView = EventTypeView()
    var titleLabel: UILabel = UILabel()
    
    var soonLabel: UILabel = UILabel()
    var memberView: MembersView = MembersView()
    var locationView: LocationView = LocationView()
    
    var topTimeConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.weatherTopConstraint.constant = rowVerticalInset
        
        self.timeLabel.text = "09:41"
        self.durationLabel.text = "2h 30m"
        self.titleLabel.text = "Sunrise iOS Challenge"
        
        self.eventTypeView.backgroundColor = UIColor.blueColor()
        
        self.timeLabel.textColor = UIColor.blackColor()
        self.durationLabel.textColor = UIColor.sunriseGrayTextColor()
        self.titleLabel.textColor = UIColor.blackColor()
        self.soonLabel.textColor = UIColor.whiteColor()
        
        self.timeLabel.font = UIFont.systemFontOfSize(12)
        self.durationLabel.font = UIFont.systemFontOfSize(12)
        self.titleLabel.font = UIFont.systemFontOfSize(15)
        self.soonLabel.font = UIFont.systemFontOfSize(11)
        
        self.titleLabel.numberOfLines = 0
        
        self.soonLabel.backgroundColor = UIColor.sunriseSpecialColor()
        self.soonLabel.textAlignment = .Center
        
        self.triangleCurrentView.hidden = true
        self.triangleCurrentView.backgroundColor = UIColor.clearColor()
        
        self.addSubview(self.triangleCurrentView)
        self.addSubview(self.soonLabel)
        self.addSubview(self.timeLabel)
        self.addSubview(self.durationLabel)
        self.addSubview(self.titleLabel)
        self.addSubview(self.eventTypeView)
        self.addSubview(self.memberView)
        self.addSubview(self.locationView)
        
        self.setupEventConstraints()
        
        //To resize memberView and location view : sizeToFit() or clipsToBounds
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setEvent(event: Event, formattedTime: String, formattedDuration: String, eventIsCurrent: Bool = false, soonWarning: String? = nil) {
        self.titleLabel.text = event.title
        self.timeLabel.text = (event.allDay ? "ALL DAY" : formattedTime)
        self.durationLabel.text = (event.allDay ? "" : formattedDuration)
        self.memberView.setMembers(event.members)
        self.locationView.setLocationName(event.locationName)
        self.triangleCurrentView.hidden = !eventIsCurrent
        if soonWarning != nil {
            self.soonLabel.text = soonWarning!
            self.topTimeConstraint.constant = rowVerticalInset / 2
        }
        else {
            self.soonLabel.text = ""
            self.topTimeConstraint.constant = rowVerticalInset
        }
        
        self.eventTypeView.backgroundColor = colorForEvent(event.containingCalendar)
        
        self.layoutIfNeeded()
    }

    func setupEventConstraints() {
        self.soonLabel.translatesAutoresizingMaskIntoConstraints = false
        let topSoon: NSLayoutConstraint = NSLayoutConstraint(item: self.soonLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        let leftSoon: NSLayoutConstraint = NSLayoutConstraint(item: self.soonLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let widthSoon: NSLayoutConstraint = NSLayoutConstraint(item: self.soonLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: rowEventTypeCenterX)
        
        self.timeLabel.translatesAutoresizingMaskIntoConstraints = false
        topTimeConstraint = NSLayoutConstraint(item: self.timeLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.soonLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: rowVerticalInset)
        let leftTime: NSLayoutConstraint = NSLayoutConstraint(item: self.timeLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: rowLateralInset)

        self.durationLabel.translatesAutoresizingMaskIntoConstraints = false
        let topDuration: NSLayoutConstraint = NSLayoutConstraint(item: self.durationLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.timeLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 2)
        let leftDuration: NSLayoutConstraint = NSLayoutConstraint(item: self.durationLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: rowLateralInset)
        
        self.triangleCurrentView.translatesAutoresizingMaskIntoConstraints = false
        let topTriangle: NSLayoutConstraint = NSLayoutConstraint(item: self.triangleCurrentView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.timeLabel, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        let leftTriangle: NSLayoutConstraint = NSLayoutConstraint(item: self.triangleCurrentView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let heightTriangle: NSLayoutConstraint = NSLayoutConstraint(item: self.triangleCurrentView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 14)
        let triangleProportion: CGFloat = 0.6
        let widthProportion: NSLayoutConstraint = NSLayoutConstraint(item: self.triangleCurrentView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.triangleCurrentView, attribute: NSLayoutAttribute.Height, multiplier: triangleProportion, constant: 0)
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let topTitle: NSLayoutConstraint = NSLayoutConstraint(item: self.titleLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.timeLabel, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        let leftTitle: NSLayoutConstraint = NSLayoutConstraint(item: self.titleLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: rowEventTitleYOrigin)
        let rightTitle: NSLayoutConstraint = NSLayoutConstraint(item: self.titleLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.weatherIcon, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: -rowLateralInset)
        
        self.eventTypeView.translatesAutoresizingMaskIntoConstraints = false
        let centerYType: NSLayoutConstraint = NSLayoutConstraint(item: self.eventTypeView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.titleLabel, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        let centerXType: NSLayoutConstraint = NSLayoutConstraint(item: self.eventTypeView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: rowEventTypeCenterX)
        let proportionType: NSLayoutConstraint = NSLayoutConstraint(item: self.eventTypeView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.eventTypeView, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        let widthMinType: NSLayoutConstraint = NSLayoutConstraint(item: self.eventTypeView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.GreaterThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 10)
        let widthMaxType: NSLayoutConstraint = NSLayoutConstraint(item: self.eventTypeView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.LessThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 20)
        
        self.memberView.translatesAutoresizingMaskIntoConstraints = false
        let topMember: NSLayoutConstraint = NSLayoutConstraint(item: self.memberView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.titleLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        let leftMember: NSLayoutConstraint = NSLayoutConstraint(item: self.memberView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.titleLabel, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        
        self.locationView.translatesAutoresizingMaskIntoConstraints = false
        let topLocation: NSLayoutConstraint = NSLayoutConstraint(item: self.locationView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.memberView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        let leftLocation: NSLayoutConstraint = NSLayoutConstraint(item: self.locationView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.titleLabel, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        
        //Setting bottom as equal to max of 2 views that can be at bottom
        let bottomDuration: NSLayoutConstraint = NSLayoutConstraint(item: self.durationLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.LessThanOrEqual, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -rowVerticalInset)
        let bottomLocation: NSLayoutConstraint = NSLayoutConstraint(item: self.locationView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.LessThanOrEqual, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -rowVerticalInset)
        
        //Resolves layout warning due to table view encapsulated height but doesn't change display
        for constraint in [topSoon, leftSoon, widthSoon, leftTime, topDuration, leftDuration, topTitle, leftTitle, centerXType, centerYType, proportionType,widthMinType, widthMaxType, topMember, leftMember, topLocation, leftLocation, bottomDuration, bottomLocation] {
            constraint.priority = 999
        }
        
        self.addConstraints([topSoon, leftSoon, widthSoon, topTimeConstraint, leftTime, topDuration, leftDuration, topTitle, leftTitle, rightTitle, centerXType, centerYType, proportionType,widthMinType, widthMaxType, topMember, leftMember, topLocation, leftLocation, bottomDuration, bottomLocation, topTriangle, leftTriangle, heightTriangle, widthProportion])
    }
}
