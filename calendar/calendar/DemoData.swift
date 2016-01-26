//
//  DemoData.swift
//  calendar
//
//  Created by Julien Levy on 24/01/2016.
//  Copyright © 2016 Julien. All rights reserved.
//

import Foundation

let kPersonalCalendar = "kPersonalCalendar"

//let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
let secondsInHours: NSTimeInterval = 1.5 * 60 * 60
let third: NSTimeInterval = 2 * 60 * 60
let otherDay: NSTimeInterval = 48 * 60 * 60

let firstEvent: Event = Event(eventTitle: "First event", eventDate: NSDate(), eventDuration: 140, eventContainingCalendar: kPersonalCalendar)
let secondEvent: Event = Event(eventTitle: "Second event", eventDate: firstEvent.date.dateByAddingTimeInterval(secondsInHours), eventDuration: 140, eventContainingCalendar: kPersonalCalendar)
let thirdEvent: Event = Event(eventTitle: "Third event", eventDate: firstEvent.date.dateByAddingTimeInterval(third), eventDuration: 15, eventContainingCalendar: kPersonalCalendar)

let otherDayEvent: Event = Event(eventTitle: "Other day event", eventDate: firstEvent.date.dateByAddingTimeInterval(otherDay), eventDuration: 170, eventContainingCalendar: kPersonalCalendar)
