//
//  NavigationBar.swift
//  calendar
//
//  Created by Julien Levy on 29/01/2016.
//  Copyright © 2016 Julien. All rights reserved.
//

import UIKit

class NavigationBar: UINavigationBar {
    let iconButton: UIButton = UIButton()
    let dayHeaderView: UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initialize()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initialize()
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        let normal: CGSize = super.sizeThatFits(size)
        
        return CGSize(width: normal.width, height: normal.height + dayHeaderViewHeight)
    }
    override func layoutSubviews() {
        self.iconButton.frame = CGRect(origin: CGPointZero, size: CGSize(width: 24, height: 24))
        self.iconButton.center = self.center
        self.iconButton.frame.origin.y = 10
        
        self.dayHeaderView.frame = CGRectMake(0, self.bounds.height - dayHeaderViewHeight, self.bounds.width, dayHeaderViewHeight)
    }
    
    func initialize() {
        self.iconButton.setBackgroundImage(UIImage(named: "sunrise"), forState: .Normal)
        self.iconButton.imageView?.contentMode = .ScaleAspectFit
        
        self.addSubview(self.iconButton)
        self.addSubview(self.dayHeaderView)
        
        self.setupDaysOfHeaderView()
    }
    func setupDaysOfHeaderView() {
        let itemSide: CGFloat = UIScreen.mainScreen().bounds.width / 7
        
        let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        var symbols: [String] = calendar.veryShortWeekdaySymbols
        
        //Starting week on monday instead of default sunday
        let sunday: String = symbols.removeFirst()
        symbols.append(sunday)
        for i in 0...(symbols.count-1) {
            let label = UILabel(frame: CGRectMake(CGFloat(i) * itemSide, 0, CGFloat(itemSide), 20))
            label.text = symbols[i]
            label.textAlignment = .Center
            //Weekend is gray
            label.textColor = (5 - i > 0 ? UIColor.blackColor() : UIColor.sunriseGrayTextColor())
            label.font = UIFont.systemFontOfSize(12.0)
            self.dayHeaderView.addSubview(label)
        }
    }
    func setupConstraints() {
        print(self.isMemberOfClass(UIView))
        print(self.isKindOfClass(UIView))
        
        self.iconButton.translatesAutoresizingMaskIntoConstraints = false
        let topIcon = NSLayoutConstraint(item: self.iconButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        let centerIcon: NSLayoutConstraint = NSLayoutConstraint(item: self.iconButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        let height: NSLayoutConstraint = NSLayoutConstraint(item: self.iconButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 20)
        let width: NSLayoutConstraint = NSLayoutConstraint(item: self.iconButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 20)
        
        self.dayHeaderView.translatesAutoresizingMaskIntoConstraints = false
        let bottomHeader = NSLayoutConstraint(item: self.dayHeaderView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        let leftHeader: NSLayoutConstraint = NSLayoutConstraint(item: self.dayHeaderView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let rightHeader: NSLayoutConstraint = NSLayoutConstraint(item: self.dayHeaderView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0)
        let heightHeader: NSLayoutConstraint = NSLayoutConstraint(item: self.dayHeaderView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: dayHeaderViewHeight)
        
        self.addConstraints([topIcon, centerIcon, height, width, bottomHeader, leftHeader, rightHeader, heightHeader])
    }

}
