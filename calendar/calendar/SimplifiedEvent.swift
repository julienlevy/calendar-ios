//
//  SimplifiedEvent.swift
//  calendar
//
//  Created by Julien Levy on 24/01/2016.
//  Copyright © 2016 Julien. All rights reserved.
//

import Foundation
import CoreLocation

class Event {
    var title: String
    var date: NSDate
    var allDay: Bool
    var duration: Int //in minutes or days if the event is all day
    var containingCalendar: String
    var description: String = ""

    var locationName: String?
    var locationCoordinate: CLLocation?
    var city: String // Should geocode coord instead!

    var members: [Contact]?
    
    init(eventTitle: String, eventDate: NSDate, eventAllDay: Bool = false, eventDuration: Int, eventContainingCalendar: String, eventDescription: String = "", eventMembers: [Contact]? = nil, eventLocationName: String? = nil, eventLocationCoordinate: CLLocation? = nil, eventCity: String = "") {
        self.title = eventTitle
        self.date = eventDate
        self.allDay = eventAllDay
        self.duration = eventDuration
        self.containingCalendar = eventContainingCalendar
        self.description = eventDescription
        self.members = eventMembers
        self.locationName = eventLocationName
        self.locationCoordinate = eventLocationCoordinate
        self.city = eventCity
    }
}