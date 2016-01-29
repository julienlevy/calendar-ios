//
//  DayPeriodAgendaCell
//  calendar
//
//  Created by Julien Levy on 24/01/2016.
//  Copyright © 2016 Julien. All rights reserved.
//

import UIKit

class DayPeriodAgendaCell: WeatherAgendaTableViewCell {
    var triangleCurrentView: TriangleView = TriangleView()
    var label: UILabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.label.textColor = UIColor.sunriseSpecialColor()
        
        self.label.font = UIFont.systemFontOfSize(12)

        self.triangleCurrentView.hidden = true
        
        self.triangleCurrentView.backgroundColor = UIColor.clearColor()
        
        self.addSubview(self.triangleCurrentView)
        self.addSubview(self.label)
        
        self.setupPeriodConstraints()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPeriodConstraints() {
        self.label.translatesAutoresizingMaskIntoConstraints = false
        let top: NSLayoutConstraint = NSLayoutConstraint(item: self.label, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: temperatureRowVerticalInset)
        let left: NSLayoutConstraint = NSLayoutConstraint(item: self.label, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: rowLateralInset)
        let bottom: NSLayoutConstraint = NSLayoutConstraint(item: self.label, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -temperatureRowVerticalInset)
        
        self.triangleCurrentView.translatesAutoresizingMaskIntoConstraints = false
        let topTriangle: NSLayoutConstraint = NSLayoutConstraint(item: self.triangleCurrentView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.label, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        let leftTriangle: NSLayoutConstraint = NSLayoutConstraint(item: self.triangleCurrentView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let heightTriangle: NSLayoutConstraint = NSLayoutConstraint(item: self.triangleCurrentView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 14)
        let triangleProportion: CGFloat = 0.6
        let widthProportion: NSLayoutConstraint = NSLayoutConstraint(item: self.triangleCurrentView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.triangleCurrentView, attribute: NSLayoutAttribute.Height, multiplier: triangleProportion, constant: 0)
        
        self.addConstraints([top, left, bottom, topTriangle, leftTriangle, heightTriangle, widthProportion])
    }
}
