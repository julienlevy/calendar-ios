//
//  DemoData.swift
//  calendar
//
//  Created by Julien Levy on 24/01/2016.
//  Copyright © 2016 Julien. All rights reserved.
//

import UIKit

let kPersonalCalendar = "kPersonalCalendar"
let kProfessionalCalendar = "kProfessionalCalendar"

//let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)

func demoEvents() -> [Event] {
    let secondsInHours: NSTimeInterval = 1.5 * 60 * 60
    let third: NSTimeInterval = 2 * 60 * 60
    let otherDay: NSTimeInterval = 48 * 60 * 60
    
    let julienLevy: Contact = Contact(contactFName: "Julien", contactLName: "Levy", contactEmail: "julienlevy6@gmail.com", contactImageName: "julienlevy")
    
    let firstEvent: Event = Event(eventTitle: "Techcrunch Interview", eventDate: NSDate(), eventDuration: 140, eventContainingCalendar: kPersonalCalendar, eventMembers: [julienLevy], eventLocationName: "Techcrunch London")

    let beforeEvent: Event = Event(eventTitle: "Coffee John", eventDate: firstEvent.date.dateByAddingTimeInterval(-secondsInHours/2), eventDuration: 40, eventContainingCalendar: kPersonalCalendar, eventLocationName: "The Department of Coffee & Social Affairs")
    let secondEvent: Event = Event(eventTitle: "Lunch Pierre", eventDate: firstEvent.date.dateByAddingTimeInterval(secondsInHours), eventDuration: 140, eventContainingCalendar: kProfessionalCalendar)
    let thirdEvent: Event = Event(eventTitle: "Drink John", eventDate: firstEvent.date.dateByAddingTimeInterval(third), eventDuration: 15, eventContainingCalendar: kPersonalCalendar)
    
    let otherDayEvent: Event = Event(eventTitle: "Concert", eventDate: firstEvent.date.dateByAddingTimeInterval(otherDay), eventDuration: 170, eventContainingCalendar: kPersonalCalendar)
    let fullDaysEvent: Event = Event(eventTitle: "Trip New-York", eventDate: firstEvent.date.dateByAddingTimeInterval(otherDay), eventAllDay: true, eventDuration: 2, eventContainingCalendar: kPersonalCalendar)
    
    return [firstEvent, beforeEvent, thirdEvent, secondEvent, otherDayEvent, fullDaysEvent]
}

func colorForEvent(calendar: String) -> UIColor? {
    if calendar == kProfessionalCalendar {
        return UIColor.greenColor()
    }
    return UIColor.blueColor()
}