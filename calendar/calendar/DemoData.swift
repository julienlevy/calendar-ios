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

let firstEvent: Event = Event(eventTitle: "First event", eventDate: NSDate(), eventDuration: 140, eventContainingCalendar: kPersonalCalendar)
//let secondEvent: Event = calendar?.dateByAddingComponents(hourOffset, toDate: firstEvent, options: NSCalendarOptions.MatchFirst)
