//
//  AgendaDayHeaderView.swift
//  calendar
//
//  Created by Julien Levy on 24/01/2016.
//  Copyright © 2016 Julien. All rights reserved.
//

import UIKit

class AgendaDayHeaderView: UIView {
    var titleLabel: UILabel = UILabel()
    
    init(frame: CGRect, title: String, isToday: Bool) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.groupTableViewBackgroundColor()
        self.titleLabel.text = title
        self.titleLabel.textColor = (isToday ? UIColor.blueColor() : normalDayColor)
        self.titleLabel.font = UIFont.systemFontOfSize(14)
        self.titleLabel.frame = self.bounds
        self.addSubview(self.titleLabel)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
