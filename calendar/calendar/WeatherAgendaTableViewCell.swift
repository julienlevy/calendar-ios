//
//  WeatherAgendaTableViewCell.swift
//  calendar
//
//  Created by Julien Levy on 29/01/2016.
//  Copyright © 2016 Julien. All rights reserved.
//

import UIKit

class WeatherAgendaTableViewCell: UITableViewCell {

    var cityLabel: UILabel = UILabel()
    var weatherIcon: UIImageView = UIImageView()
    var temperatureLabel: UILabel = UILabel()
    var weatherTopConstraint: NSLayoutConstraint = NSLayoutConstraint() //Necessary to have different insets for moment and event cells

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.cityLabel.textColor = UIColor.sunriseGrayTextColor()
        self.temperatureLabel.textColor = UIColor.sunriseGrayTextColor()
        
        self.cityLabel.font = UIFont.systemFontOfSize(12)
        self.temperatureLabel.font = UIFont.systemFontOfSize(12)
        
        self.cityLabel.textAlignment = .Right
        self.temperatureLabel.textAlignment = .Right
        
        self.weatherIcon.contentMode = UIViewContentMode.ScaleAspectFit
        
        self.cityLabel.hidden = true
        self.temperatureLabel.hidden = true
        self.weatherIcon.hidden = true

        self.addSubview(self.cityLabel)
        self.addSubview(self.weatherIcon)
        self.addSubview(self.temperatureLabel)
        
        self.setupConstraints()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setWeather(forecastTuple: (String, Int), cityName: String) {
        if refToWeatherImageName[forecastTuple.0] != nil {
            self.weatherIcon.hidden = false
            self.weatherIcon.image = UIImage(named: refToWeatherImageName[forecastTuple.0]!)
        }
        
        self.temperatureLabel.hidden = false
        self.temperatureLabel.text = String(forecastTuple.1) + "°"
        
        self.cityLabel.hidden = false
        self.cityLabel.text = cityName
        
        self.layoutIfNeeded()
    }
    
    func setupConstraints() {
        self.cityLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        self.weatherTopConstraint = NSLayoutConstraint(item: self.cityLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: temperatureRowVerticalInset - cityNameToWeatherIconSpace)
        let rightCity: NSLayoutConstraint = NSLayoutConstraint(item: self.cityLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -rowLateralInset)
        
        let topTemp: NSLayoutConstraint = NSLayoutConstraint(item: self.temperatureLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.cityLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 4)
//        self.weatherTopConstraint = NSLayoutConstraint(item: self.temperatureLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: temperatureRowVerticalInset)
        let rightTemperature: NSLayoutConstraint = NSLayoutConstraint(item: self.temperatureLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -rowLateralInset)
        
        self.weatherIcon.translatesAutoresizingMaskIntoConstraints = false
        let centerWeather: NSLayoutConstraint = NSLayoutConstraint(item: self.weatherIcon, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.temperatureLabel, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        let rightWeather: NSLayoutConstraint = NSLayoutConstraint(item: self.weatherIcon, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.temperatureLabel, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: -4)
        let heightWeather: NSLayoutConstraint = NSLayoutConstraint(item: self.weatherIcon, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 20)
        let widthWeather: NSLayoutConstraint = NSLayoutConstraint(item: self.weatherIcon, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 20)
        
        self.addConstraints([self.weatherTopConstraint, rightCity, topTemp, rightTemperature, centerWeather, rightWeather, heightWeather, widthWeather])
    }
}
