//
//  CalendarCircleViews.swift
//  calendar
//
//  Created by Julien Levy on 24/01/2016.
//  Copyright © 2016 Julien. All rights reserved.
//

import UIKit

class CircleView: UIView {
    
    init(color: UIColor?) {
        super.init(frame: CGRectZero)
        
        self.backgroundColor = color
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
        self.layer.cornerRadius = self.frame.width/2
    }
}