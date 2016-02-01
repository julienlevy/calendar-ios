//
//  AuthorizationCell.swift
//  calendar
//
//  Created by Julien Levy on 30/01/2016.
//  Copyright © 2016 Julien. All rights reserved.
//

import UIKit

class AuthorizationCell: UITableViewCell {
    
    let iconView: UIImageView = UIImageView()
    let titleLabel: UILabel = UILabel()
    let detailLabel: UILabel = UILabel()
    
    let enableButton: UIButton = UIButton()
    
    let validateIcon: UIImageView = UIImageView()
    
    let separatorView: UIView = UIView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.enableButton.setTitle("Enable", forState: .Normal)
        self.enableButton.setTitleColor(UIColor.sunriseSpecialColor(), forState: .Normal)
        self.enableButton.titleLabel?.font = UIFont.systemFontOfSize(12.0)
        
        self.titleLabel.text = "Title"
        
        self.detailLabel.text = "Detail"
        self.detailLabel.font = UIFont.systemFontOfSize(12.0)
        self.detailLabel.textColor = UIColor.sunriseGrayTextColor()
        self.detailLabel.numberOfLines = 0
        
        self.validateIcon.image = UIImage(named: "red-done")
        self.validateIcon.alpha = 0
        
        self.separatorView.backgroundColor = UIColor.sunriseGrayTextColor()

        self.addSubview(self.iconView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.detailLabel)
        self.addSubview(self.enableButton)
        self.addSubview(self.validateIcon)
        self.addSubview(self.separatorView)
        
        self.setupConstraints()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.enableButton.layer.borderWidth = 1.0
        self.enableButton.layer.borderColor = self.tintColor.CGColor
        self.enableButton.layer.cornerRadius = 2.0
    }
    
    func setupConstraints() {
        let verticalInset: CGFloat = 10
        let lateralInset: CGFloat = 20
        self.iconView.translatesAutoresizingMaskIntoConstraints = false
        let topIcon: NSLayoutConstraint  = NSLayoutConstraint(item: self.iconView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: verticalInset)
        let leftIcon: NSLayoutConstraint = NSLayoutConstraint(item: self.iconView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: lateralInset)
        let iconHeight: NSLayoutConstraint = NSLayoutConstraint(item: self.iconView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 30)
        let iconWidth: NSLayoutConstraint = NSLayoutConstraint(item: self.iconView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 30)
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let topTitle = NSLayoutConstraint(item: self.titleLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: verticalInset)
        let leftTitle: NSLayoutConstraint = NSLayoutConstraint(item: self.titleLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.iconView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 10)
        
        self.detailLabel.translatesAutoresizingMaskIntoConstraints = false
        let topDetail: NSLayoutConstraint = NSLayoutConstraint(item: self.detailLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.titleLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 2)
        let leftDetail: NSLayoutConstraint = NSLayoutConstraint(item: self.detailLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.titleLabel, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let detailRight: NSLayoutConstraint = NSLayoutConstraint(item: self.detailLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.enableButton, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: -10)
        
        self.enableButton.translatesAutoresizingMaskIntoConstraints = false
        let centerEnable: NSLayoutConstraint = NSLayoutConstraint(item: self.enableButton, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        let rightEnable: NSLayoutConstraint = NSLayoutConstraint(item: self.enableButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -lateralInset)
        let heightEnable: NSLayoutConstraint = NSLayoutConstraint(item: self.enableButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 30)
        let widthEnable: NSLayoutConstraint = NSLayoutConstraint(item: self.enableButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 60)
        
        self.validateIcon.translatesAutoresizingMaskIntoConstraints = false
        let centerValidate: NSLayoutConstraint = NSLayoutConstraint(item: self.validateIcon, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        let rightValidate: NSLayoutConstraint = NSLayoutConstraint(item: self.validateIcon, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -lateralInset)
        let heightValidate: NSLayoutConstraint = NSLayoutConstraint(item: self.validateIcon, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 30)
        let widthValidate: NSLayoutConstraint = NSLayoutConstraint(item: self.validateIcon, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 30)
        
        //Setting bottom as equal to max of 2 views that can be at bottom
        let bottomDetail: NSLayoutConstraint = NSLayoutConstraint(item: self.detailLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.LessThanOrEqual, toItem: self.separatorView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: -verticalInset)
        let bottomIcon: NSLayoutConstraint = NSLayoutConstraint(item: self.iconView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.LessThanOrEqual, toItem: self.separatorView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: -verticalInset)
        
        self.separatorView.translatesAutoresizingMaskIntoConstraints = false
        let separatorHeight: NSLayoutConstraint = NSLayoutConstraint(item: self.separatorView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 1)
        let separatorLeft: NSLayoutConstraint = NSLayoutConstraint(item: self.separatorView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: lateralInset)
        let separatorRight: NSLayoutConstraint = NSLayoutConstraint(item: self.separatorView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        let separatorBottom: NSLayoutConstraint = NSLayoutConstraint(item: self.separatorView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        
        for constraint in [topIcon, leftIcon, iconHeight, iconWidth, topTitle, leftTitle, topDetail, leftDetail, detailRight, centerEnable, rightEnable, heightEnable, widthEnable, centerValidate, rightValidate, heightValidate, widthValidate, bottomDetail, bottomIcon, separatorHeight, separatorLeft, separatorRight, separatorBottom] {
            constraint.priority = 990
        }
        
        self.addConstraints([topIcon, leftIcon, iconHeight, iconWidth, topTitle, leftTitle, topDetail, leftDetail, detailRight, centerEnable, rightEnable, heightEnable, widthEnable, centerValidate, rightValidate, heightValidate, widthValidate, bottomDetail, bottomIcon, separatorHeight, separatorLeft, separatorRight, separatorBottom])
    }
}
