//
//  AgendaCell.swift
//  calendar
//
//  Created by Julien Levy on 27/01/2016.
//  Copyright © 2016 Julien. All rights reserved.
//

import UIKit

class AgendaCell:  UITableViewCell {
    var isCurrent: Bool = false
    
    var currentView: TriangleView = TriangleView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.currentView.backgroundColor = UIColor.clearColor()
        self.currentView.hidden = !self.isCurrent
        
        self.addSubview(currentView)
        self.setUpConstraints()
        
        //To resize memberView and location view : sizeToFit() or clipsToBounds
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func showTriangleIfNeeded() {
        self.currentView.hidden = !self.isCurrent
    }
    func setUpConstraints() {
        self.currentView.translatesAutoresizingMaskIntoConstraints = false
        let topTriangle: NSLayoutConstraint = NSLayoutConstraint(item: self.currentView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: rowVerticalInset)
        let leftTriangle: NSLayoutConstraint = NSLayoutConstraint(item: self.currentView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let heightTriangle: NSLayoutConstraint = NSLayoutConstraint(item: self.currentView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 14)
        
        let triangleProportion: CGFloat = 0.6
        let widthProportion: NSLayoutConstraint = NSLayoutConstraint(item: self.currentView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.currentView, attribute: NSLayoutAttribute.Height, multiplier: triangleProportion, constant: 0)
        
        self.addConstraints([topTriangle, leftTriangle, heightTriangle, widthProportion])
    }
}
