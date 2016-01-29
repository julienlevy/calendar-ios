//
//  DemoData.swift
//  calendar
//
//  Created by Julien Levy on 24/01/2016.
//  Copyright © 2016 Julien. All rights reserved.
//

import UIKit
import CoreLocation

let kPersonalCalendar = "kPersonalCalendar"
let kProfessionalCalendar = "kProfessionalCalendar"

//let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)

func demoEvents() -> [Event] {
    let fifteenMin: NSTimeInterval = 15 * 60
    let oneHourAndAHalf: NSTimeInterval = 1.5 * 60 * 60
    let twoHours: NSTimeInterval = 2 * 60 * 60
    let twoDays: NSTimeInterval = 48 * 60 * 60
    
    let paris: CLLocation = CLLocation(latitude: 48.87164, longitude: 2.3519983)
    let london: CLLocation = CLLocation(latitude: 51.5287352, longitude: -0.3817819)
    
    let julienLevy: Contact = Contact(contactFName: "Julien", contactLName: "Levy", contactEmail: "julienlevy6@gmail.com", contactImageName: "julienlevy")
    let pierrevalade: Contact = Contact(contactFName: "Pierre", contactLName: "Valade", contactImageName: "pierrevalade")
    
    let firstEvent: Event = Event(eventTitle: "Techcrunch Interview", eventDate: NSDate().dateByAddingTimeInterval(fifteenMin), eventDuration: 140, eventContainingCalendar: kPersonalCalendar, eventMembers: [julienLevy], eventLocationName: "Techcrunch London", eventLocationCoordinate: london)

    let beforeEvent: Event = Event(eventTitle: "Coffee John", eventDate: firstEvent.date.dateByAddingTimeInterval(-oneHourAndAHalf/2), eventDuration: 40, eventContainingCalendar: kPersonalCalendar, eventLocationName: "The Department of Coffee & Social Affairs")
    let secondEvent: Event = Event(eventTitle: "Lunch Pierre", eventDate: firstEvent.date.dateByAddingTimeInterval(oneHourAndAHalf), eventDuration: 140, eventContainingCalendar: kProfessionalCalendar, eventMembers: [pierrevalade, julienLevy])
    let thirdEvent: Event = Event(eventTitle: "Drink John", eventDate: firstEvent.date.dateByAddingTimeInterval(twoHours), eventDuration: 15, eventContainingCalendar: kPersonalCalendar, eventLocationName: "The Brick and Mortar", eventLocationCoordinate: paris)
    
    let otherDayEvent: Event = Event(eventTitle: "Concert", eventDate: firstEvent.date.dateByAddingTimeInterval(twoDays), eventDuration: 170, eventContainingCalendar: kPersonalCalendar)
    let fullDaysEvent: Event = Event(eventTitle: "Trip New-York", eventDate: firstEvent.date.dateByAddingTimeInterval(twoDays), eventAllDay: true, eventDuration: 2, eventContainingCalendar: kPersonalCalendar)
    
    return [firstEvent, beforeEvent, thirdEvent, secondEvent, otherDayEvent, fullDaysEvent]
}

func colorForEvent(calendar: String) -> UIColor? {
    if calendar == kProfessionalCalendar {
        return UIColor(red: 161.0/255.0, green: 225.0/255.0, blue: 230.0/255.0, alpha: 1.0)
    }
    return UIColor(red: 112.0/255.0, green: 31.0/255.0, blue: 117.0/255.0, alpha: 1.0)
}