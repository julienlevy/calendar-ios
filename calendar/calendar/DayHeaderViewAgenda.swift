//
//  DayHeaderViewAgenda.swift
//  calendar
//
//  Created by Julien Levy on 24/01/2016.
//  Copyright © 2016 Julien. All rights reserved.
//

import UIKit

class DayHeaderViewAgenda: UIView {
    var titleLabel: UILabel = UILabel()
    
    init(frame: CGRect, title: String, isToday: Bool) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.groupTableViewBackgroundColor()
        self.titleLabel.text = title
        self.titleLabel.textColor = (isToday ? UIColor.sunriseBlueColor() : UIColor.sunriseGrayTextColor())
        self.titleLabel.font = UIFont.systemFontOfSize(12)
        self.titleLabel.frame = self.bounds
        self.addSubview(self.titleLabel)
        
        self.setupConstraints()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let top: NSLayoutConstraint = NSLayoutConstraint(item: self.titleLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        let left: NSLayoutConstraint = NSLayoutConstraint(item: self.titleLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: rowLateralInset)
        let bottom: NSLayoutConstraint = NSLayoutConstraint(item: self.titleLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        let height: NSLayoutConstraint = NSLayoutConstraint(item: self.titleLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        
        self.addConstraints([top, left, bottom, height])
    }
}
