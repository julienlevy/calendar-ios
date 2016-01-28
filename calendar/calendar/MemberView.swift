//
//  MemberView.swift
//  calendar
//
//  Created by Julien Levy on 27/01/2016.
//  Copyright © 2016 Julien. All rights reserved.
//

import UIKit

class MembersView: UIView {
    let imageSpace: CGFloat = 4.0
    
    func setMembers(members: [Contact]?) {
        if members == nil {
            return
        }
        var previousView: UIImageView? = nil
        for contact in members! {
            let imageView = UIImageView(frame: CGRect(origin: CGPointZero, size: CGSize(width: 40, height: 40)))
            imageView.image = UIImage(named: contact.imageName)
            imageView.contentMode = .ScaleAspectFit
            self.addSubview(imageView)
            
            if previousView == nil {
                self.addConstraintToImageView(imageView, withViewToLeft: self, andAttribute: NSLayoutAttribute.Left)
            }
            else {
                self.addConstraintToImageView(imageView, withViewToLeft: previousView!, andAttribute: NSLayoutAttribute.Right)
            }
            previousView = imageView
        }
        if members!.count == 1 {
            let nameLabel = UILabel()
            nameLabel.text = members![0].firstName + " " + members![0].lastName
            nameLabel.textColor = UIColor.sunriseBlueColor()
            nameLabel.font = UIFont.systemFontOfSize(12)
            self.addSubview(nameLabel)
            if previousView != nil {
                self.addConstraintsToLabel(nameLabel, withViewToLeft: previousView!)
            }
        }
        
        self.setNeedsDisplay()
        self.layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
        
        for subview in subviews {
            if let imageView = subview as? UIImageView {
                imageView.layer.cornerRadius = imageView.frame.width/2
                imageView.clipsToBounds = true
            }
        }
    }
    
    func addConstraintToImageView(view: UIImageView, withViewToLeft viewToLeft: UIView, andAttribute attribute: NSLayoutAttribute) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let top: NSLayoutConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: rowVerticalSpaceWithin)
        let bottom: NSLayoutConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
        let height: NSLayoutConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 40)
        let width: NSLayoutConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 40)
        let left: NSLayoutConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: viewToLeft, attribute: attribute, multiplier: 1.0, constant: imageSpace)
        
        height.priority = 999
        self.addConstraints([top, bottom, height, width, left])
    }
    func addConstraintsToLabel(label: UILabel, withViewToLeft viewToLeft: UIView) {
        label.translatesAutoresizingMaskIntoConstraints = false
        let left: NSLayoutConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: viewToLeft, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: imageSpace)
        let center: NSLayoutConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: viewToLeft, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
        
        self.addConstraints([left, center])
    }
}
