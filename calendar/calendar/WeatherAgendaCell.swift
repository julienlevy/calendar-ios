//
//  WeatherAgendaCell
//  calendar
//
//  Created by Julien Levy on 24/01/2016.
//  Copyright © 2016 Julien. All rights reserved.
//

import UIKit

class WeatherAgendaCell: AgendaCell {
    var label: UILabel = UILabel()
    var weatherIcon: UIView = UIView()
    var temperatureLabel: UILabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.label.text = "Morning"
        self.temperatureLabel.text = "0°"
        
        self.label.textColor = UIColor.sunriseSpecialColor()
        self.temperatureLabel.textColor = UIColor.sunriseGrayTextColor()
        
        self.label.font = UIFont.systemFontOfSize(12)
        self.temperatureLabel.font = UIFont.systemFontOfSize(12)
        
        self.weatherIcon.backgroundColor = UIColor.magentaColor()
        
        self.addSubview(self.label)
        self.addSubview(self.weatherIcon)
        self.addSubview(self.temperatureLabel)
        
        self.setupConstraints()        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupConstraints() {
        self.label.translatesAutoresizingMaskIntoConstraints = false
        let top: NSLayoutConstraint = NSLayoutConstraint(item: self.label, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: temperatureRowVerticalInset)
        let left: NSLayoutConstraint = NSLayoutConstraint(item: self.label, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: rowLateralInset)
        let bottom: NSLayoutConstraint = NSLayoutConstraint(item: self.label, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -temperatureRowVerticalInset)
        
        
        self.temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        let centerTemperature: NSLayoutConstraint = NSLayoutConstraint(item: self.temperatureLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.label, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        let rightTemperature: NSLayoutConstraint = NSLayoutConstraint(item: self.temperatureLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -rowLateralInset)
        
        
        self.weatherIcon.translatesAutoresizingMaskIntoConstraints = false
        let centerWeather: NSLayoutConstraint = NSLayoutConstraint(item: self.weatherIcon, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.label, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        let rightWeather: NSLayoutConstraint = NSLayoutConstraint(item: self.weatherIcon, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.temperatureLabel, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: -rowLateralInset)
        let heightWeather: NSLayoutConstraint = NSLayoutConstraint(item: self.weatherIcon, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 20)
        let widthWeather: NSLayoutConstraint = NSLayoutConstraint(item: self.weatherIcon, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 20)
        
        self.addConstraints([top, left, bottom, centerTemperature, rightTemperature, centerWeather, rightWeather, heightWeather, widthWeather])
    }
}
