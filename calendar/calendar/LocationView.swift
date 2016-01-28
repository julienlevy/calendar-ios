//
//  LocationView.swift
//  calendar
//
//  Created by Julien Levy on 28/01/2016.
//  Copyright © 2016 Julien. All rights reserved.
//

import UIKit

class LocationView: UIView {
    let iconView: UIImageView
    let locationNameLabel: UILabel
    
    init() {
        self.iconView = UIImageView(image: UIImage(named: "Location"))
        self.locationNameLabel = UILabel()
        
        super.init(frame: CGRectZero)
        
        self.locationNameLabel.textColor = UIColor.sunriseGrayTextColor()
        self.locationNameLabel.font = UIFont.systemFontOfSize(12.0)
        
        self.iconView.contentMode = .ScaleAspectFit
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLocationName(location: String?) {
        if location == nil {
            self.removeConstraints(self.constraints)
            for subview in subviews {
                subview.removeFromSuperview()
            }
            
            return
        }
        self.locationNameLabel.text = location!
        
        self.addSubview(self.locationNameLabel)
        self.addSubview(self.iconView)
        
        self.setupConstraints()
    }
    
    func setupConstraints() {
        self.iconView.translatesAutoresizingMaskIntoConstraints = false
        let top: NSLayoutConstraint = NSLayoutConstraint(item: self.iconView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0)
        let bottom: NSLayoutConstraint = NSLayoutConstraint(item: self.iconView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
        let height: NSLayoutConstraint = NSLayoutConstraint(item: self.iconView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 10)
        let width: NSLayoutConstraint = NSLayoutConstraint(item: self.iconView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 10)
        let left: NSLayoutConstraint = NSLayoutConstraint(item: self.iconView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0)
        
        height.priority = 999
        
        self.locationNameLabel.translatesAutoresizingMaskIntoConstraints = false
        let leftLabel: NSLayoutConstraint = NSLayoutConstraint(item: self.locationNameLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.iconView, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 2)
        let centerLabel: NSLayoutConstraint = NSLayoutConstraint(item: self.locationNameLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
        
        self.addConstraints([top, bottom, height, width, left, leftLabel, centerLabel])
    }
}

