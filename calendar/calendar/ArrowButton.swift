//
//  ArrowButton.swift
//  calendar
//
//  Created by Julien Levy on 29/01/2016.
//  Copyright © 2016 Julien. All rights reserved.
//

import UIKit

class ArrowButton: UIButton {
    let iconView: UIImageView
    
    init() {
        self.iconView = UIImageView(image: UIImage(named: "RightArrow"))
        super.init(frame: CGRectZero)
        
        self.backgroundColor = UIColor.sunriseSpecialColor()
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.sunriseDarkSpecialColor().CGColor
        
        self.iconView.contentMode = .ScaleAspectFit
        
        self.addSubview(self.iconView)
        self.setupConstraints()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layoutIfNeeded()
        self.layer.cornerRadius = self.frame.width/2
    }
    
    func setupConstraints() {
        self.iconView.translatesAutoresizingMaskIntoConstraints = false
        let height: NSLayoutConstraint = NSLayoutConstraint(item: self.iconView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 15)
        let width: NSLayoutConstraint = NSLayoutConstraint(item: self.iconView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 15)
        let centerX: NSLayoutConstraint = NSLayoutConstraint(item: self.iconView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0)
        let centerY: NSLayoutConstraint = NSLayoutConstraint(item: self.iconView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
        
        self.addConstraints([height, width, centerX, centerY])
    }
}
