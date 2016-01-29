//
//  WeatherAgendaTableViewCell.swift
//  calendar
//
//  Created by Julien Levy on 29/01/2016.
//  Copyright © 2016 Julien. All rights reserved.
//

import UIKit

class WeatherAgendaTableViewCell: UITableViewCell {
    
    var weatherIcon: UIImageView = UIImageView()
    var temperatureLabel: UILabel = UILabel()
    var weatherTopConstraint: NSLayoutConstraint = NSLayoutConstraint()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.weatherTopConstraint.constant = temperatureRowVerticalInset
        
        self.temperatureLabel.textColor = UIColor.sunriseGrayTextColor()
        
        self.temperatureLabel.font = UIFont.systemFontOfSize(12)
        
        self.temperatureLabel.textAlignment = .Right
        
        self.weatherIcon.contentMode = UIViewContentMode.ScaleAspectFit
        
        self.temperatureLabel.hidden = true
        self.weatherIcon.hidden = true

        self.addSubview(self.weatherIcon)
        self.addSubview(self.temperatureLabel)
        
        self.setupConstraints()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setWeather(forecastTuple: (String, Int)) {
        if refToWeatherImageName[forecastTuple.0] != nil {
            self.weatherIcon.hidden = false
            self.weatherIcon.image = UIImage(named: refToWeatherImageName[forecastTuple.0]!)
        }
        
        self.temperatureLabel.hidden = false
        self.temperatureLabel.text = String(forecastTuple.1) + "°"
    }
    
    func setupConstraints() {
        
        self.temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        self.weatherTopConstraint = NSLayoutConstraint(item: self.temperatureLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: temperatureRowVerticalInset)
        let rightTemperature: NSLayoutConstraint = NSLayoutConstraint(item: self.temperatureLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -rowLateralInset)
        let temperatureWidth: NSLayoutConstraint = NSLayoutConstraint(item: self.temperatureLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 20)
        
        self.weatherIcon.translatesAutoresizingMaskIntoConstraints = false
        let centerWeather: NSLayoutConstraint = NSLayoutConstraint(item: self.weatherIcon, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.temperatureLabel, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        let rightWeather: NSLayoutConstraint = NSLayoutConstraint(item: self.weatherIcon, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.temperatureLabel, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: -rowLateralInset)
        let heightWeather: NSLayoutConstraint = NSLayoutConstraint(item: self.weatherIcon, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 20)
        let widthWeather: NSLayoutConstraint = NSLayoutConstraint(item: self.weatherIcon, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 20)
        
        self.addConstraints([self.weatherTopConstraint, rightTemperature, centerWeather, rightWeather, heightWeather, widthWeather])
    }
}
