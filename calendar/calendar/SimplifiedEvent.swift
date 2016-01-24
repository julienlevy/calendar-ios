//
//  SimplifiedEvent.swift
//  calendar
//
//  Created by Julien Levy on 24/01/2016.
//  Copyright © 2016 Julien. All rights reserved.
//

import Foundation

class Event {
    var title: String
    var date: NSDate
    var duration: Int //in minutes
    var containingCalendar: String
    var description: String = ""
    
    var locationName: String?
    var locationCoordinate: (Float, Float)?
    var people: [Contact]?
    
    init(eventTitle: String, eventDate: NSDate, eventDuration: Int, eventContainingCalendar: String) {
        self.title = eventTitle
        self.date = eventDate
        self.duration = eventDuration
        self.containingCalendar = eventContainingCalendar
    }
}