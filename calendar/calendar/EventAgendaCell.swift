//
//  EventAgendaCell.swift
//  calendar
//
//  Created by Julien Levy on 24/01/2016.
//  Copyright © 2016 Julien. All rights reserved.
//

import UIKit

class EventAgendaCell: AgendaCell {
    var timeLabel: UILabel = UILabel()
    var durationLabel: UILabel = UILabel()
    var eventTypeView: EventTypeView = EventTypeView()
    var titleLabel: UILabel = UILabel()
    
    var memberView: MembersView = MembersView()
    var locationView: UIView = UIView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.timeLabel.text = "09:41"
        self.durationLabel.text = "2h 30m"
        self.titleLabel.text = "Sunrise iOS Challenge"
        self.eventTypeView.backgroundColor = UIColor.blueColor()
        
        self.timeLabel.textColor = UIColor.blackColor()
        self.durationLabel.textColor = UIColor.sunriseGrayTextColor()
        self.titleLabel.textColor = UIColor.blackColor()
        
        self.timeLabel.font = UIFont.systemFontOfSize(12)
        self.durationLabel.font = UIFont.systemFontOfSize(12)
        self.titleLabel.font = UIFont.systemFontOfSize(15)
        
        self.addSubview(self.timeLabel)
        self.addSubview(self.durationLabel)
        self.addSubview(self.titleLabel)
        self.addSubview(self.eventTypeView)
        self.addSubview(self.memberView)
        self.addSubview(self.locationView)
        
        self.setupConstraints()
        
        //To resize memberView and location view : sizeToFit() or clipsToBounds
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupConstraints() {
        self.timeLabel.translatesAutoresizingMaskIntoConstraints = false
        let topTime: NSLayoutConstraint = NSLayoutConstraint(item: self.timeLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: rowVerticalInset)
        let leftTime: NSLayoutConstraint = NSLayoutConstraint(item: self.timeLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: rowLateralInset)
        
        self.durationLabel.translatesAutoresizingMaskIntoConstraints = false
        let topDuration: NSLayoutConstraint = NSLayoutConstraint(item: self.durationLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.timeLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 2)
        let leftDuration: NSLayoutConstraint = NSLayoutConstraint(item: self.durationLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: rowLateralInset)
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let topTitle: NSLayoutConstraint = NSLayoutConstraint(item: self.titleLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: rowVerticalInset)
        let leftTitle: NSLayoutConstraint = NSLayoutConstraint(item: self.titleLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: rowEventTitleYOrigin)
        
        self.eventTypeView.translatesAutoresizingMaskIntoConstraints = false
        let centerYType: NSLayoutConstraint = NSLayoutConstraint(item: self.eventTypeView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.titleLabel, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 2)
        let centerXType: NSLayoutConstraint = NSLayoutConstraint(item: self.eventTypeView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: rowEventTypeCenterX)
        let proportionType: NSLayoutConstraint = NSLayoutConstraint(item: self.eventTypeView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.eventTypeView, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        let widthMinType: NSLayoutConstraint = NSLayoutConstraint(item: self.eventTypeView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.GreaterThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 10)
        let widthMaxType: NSLayoutConstraint = NSLayoutConstraint(item: self.eventTypeView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.LessThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 20)
        
        self.memberView.translatesAutoresizingMaskIntoConstraints = false
        let topMember: NSLayoutConstraint = NSLayoutConstraint(item: self.memberView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.titleLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 2)
        let leftMember: NSLayoutConstraint = NSLayoutConstraint(item: self.memberView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.titleLabel, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        
        self.locationView.translatesAutoresizingMaskIntoConstraints = false
        let topLocation: NSLayoutConstraint = NSLayoutConstraint(item: self.locationView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.memberView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 2)
        let leftLocation: NSLayoutConstraint = NSLayoutConstraint(item: self.locationView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.titleLabel, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        
        //Setting bottom as equal to max of 2 views that can be at bottom
        let bottomDuration: NSLayoutConstraint = NSLayoutConstraint(item: self.durationLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.LessThanOrEqual, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -rowVerticalInset)
        let bottomLocation: NSLayoutConstraint = NSLayoutConstraint(item: self.locationView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.LessThanOrEqual, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -rowVerticalInset)
        
        self.addConstraints([topTime, leftTime, topDuration, leftDuration, topTitle, leftTitle, centerXType, centerYType, proportionType,widthMinType, widthMaxType, topMember, leftMember, topLocation, leftLocation, bottomDuration, bottomLocation])
    }
}
