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
    let twoDays: NSTimeInterval = 48 * 60 * 60
    let threeDays: NSTimeInterval = 96 * 60 * 60
    
    let paris: CLLocation = CLLocation(latitude: 48.87164, longitude: 2.3519983)
    let london: CLLocation = CLLocation(latitude: 51.5287352, longitude: -0.3817819)
    
    let julienLevy: Contact = Contact(contactFName: "Julien", contactLName: "Levy", contactEmail: "julienlevy6@gmail.com", contactImageName: "julienlevy")
    let pierrevalade: Contact = Contact(contactFName: "Pierre", contactLName: "Valade", contactImageName: "pierrevalade")
    let joeydong: Contact = Contact(contactFName: "Joey", contactLName: "Dong", contactImageName: "joeydong")
    let romaindillet: Contact = Contact(contactFName: "Romain", contactLName: "Dillet", contactImageName: "romaindillet")
    
    let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    let date: NSDate = NSDate()
    let tomorrow: NSDate = date.dateByAddingTimeInterval(24.0*3600.0)
    


    let todayEvent: Event = Event(eventTitle: "Coffee John", eventDate: calendar.dateBySettingHour(8, minute: 0, second: 12, ofDate: date, options: NSCalendarOptions.MatchFirst)!, eventDuration: 30, eventContainingCalendar: kPersonalCalendar, eventLocationName: "The Department of Coffee & Social Affairs")
    let nowEvent: Event = Event(eventTitle: "Recruitment Meeting", eventDate: date.dateByAddingTimeInterval(-oneHourAndAHalf/2), eventDuration: 40, eventContainingCalendar: kProfessionalCalendar, eventLocationName: "East Meeting Room")
    let nextEvent: Event = Event(eventTitle: "Growth Meeting", eventDate: date.dateByAddingTimeInterval(fifteenMin), eventDuration: 75, eventContainingCalendar: kProfessionalCalendar, eventLocationName: "Lower Meeting Room")
    
    let tomorrowMorningLondon: Event = Event(eventTitle: "Techcrunch Interview", eventDate: calendar.dateBySettingHour(8, minute: 0, second: 12, ofDate: date, options: NSCalendarOptions.MatchFirst)!
        , eventDuration: 90, eventContainingCalendar: kProfessionalCalendar, eventMembers: [romaindillet], eventLocationName: "Techcrunch London", eventLocationCoordinate: london)
    
    let trainEvent: Event = Event(eventTitle: "London - Paris", eventDate: calendar.dateBySettingHour(10, minute: 30, second: 12, ofDate: tomorrow, options: NSCalendarOptions.MatchFirst)!
        , eventDuration: 60, eventContainingCalendar: kPersonalCalendar, eventMembers: [romaindillet], eventLocationName: "St Pancras", eventLocationCoordinate: london)
    
    let lunchParis: Event = Event(eventTitle: "Lunch Pierre", eventDate: calendar.dateBySettingHour(13, minute: 30, second: 12, ofDate: tomorrow, options: NSCalendarOptions.MatchFirst)!, eventDuration: 45, eventContainingCalendar: kProfessionalCalendar, eventMembers: [pierrevalade], eventLocationName: "Healthy Burgers Café", eventLocationCoordinate: paris)
    
    let eveningParis: Event = Event(eventTitle: "Team Drinks", eventDate: calendar.dateBySettingHour(19, minute: 0, second: 12, ofDate: tomorrow, options: NSCalendarOptions.MatchFirst)!, eventDuration: 15, eventContainingCalendar: kProfessionalCalendar, eventMembers: [pierrevalade, joeydong], eventLocationName: "The Brick and Mortar, Paris", eventLocationCoordinate: paris)
    
    let otherDayEvent: Event = Event(eventTitle: "Concert", eventDate: calendar.dateBySettingHour(19, minute: 0, second: 12, ofDate: date.dateByAddingTimeInterval(twoDays), options: NSCalendarOptions.MatchFirst)!, eventDuration: 170, eventContainingCalendar: kPersonalCalendar)
    
    let fullDaysEvent: Event = Event(eventTitle: "Day Off", eventDate: date.dateByAddingTimeInterval(twoDays), eventAllDay: true, eventDuration: 1, eventContainingCalendar: kProfessionalCalendar)
    
    //CV events
    let pontsContact: Contact = Contact(contactFName: "Ecole", contactLName: "des Ponts", contactImageName: "enpc")
    let theodoContact: Contact = Contact(contactFName: "Theodo", contactLName: "UK", contactImageName: "theodo")
    let dscribeContact: Contact = Contact(contactFName: "Dscribe", contactLName: "Keyboard", contactImageName: "Dscribe")
    let sunriseContact: Contact = Contact(contactFName: "Sunrise", contactLName: " ", contactImageName: "sunrise")
    
    let resume: Event = Event(eventTitle: "A few things about me", eventDate: calendar.dateBySettingHour(8, minute: 0, second: 12, ofDate: date.dateByAddingTimeInterval(threeDays), options: NSCalendarOptions.MatchFirst)!, eventDuration: 90, eventContainingCalendar: kPersonalCalendar, eventMembers: [julienLevy], eventLocationName: "Just a few")
    let education: Event = Event(eventTitle: "Computer Science and Innovation", eventDate: resume.date.dateByAddingTimeInterval(fifteenMin), eventDuration: 90, eventContainingCalendar: kPersonalCalendar, eventMembers: [pontsContact], eventLocationName: "2013 - 2017")
    let theodo: Event = Event(eventTitle: "Agile Developer", eventDate: education.date.dateByAddingTimeInterval(fifteenMin), eventDuration: 90, eventContainingCalendar: kPersonalCalendar, eventMembers: [theodoContact], eventLocationName: "July 15 - Jan 16")
    let dscribeEvent: Event = Event(eventTitle: "Emoji search iOS keyboard", eventDate: theodo.date.dateByAddingTimeInterval(fifteenMin), eventDuration: 90, eventContainingCalendar: kPersonalCalendar, eventMembers: [dscribeContact], eventLocationName: "Just Launched")
    let now: Event = Event(eventTitle: "iOS engineer intern  🙏", eventDate: dscribeEvent.date.dateByAddingTimeInterval(fifteenMin), eventDuration: 140, eventContainingCalendar: kPersonalCalendar, eventMembers: [sunriseContact], eventLocationName: "Now - August")
    
    return [tomorrowMorningLondon, todayEvent, eveningParis, lunchParis, otherDayEvent, fullDaysEvent, nowEvent, nextEvent, trainEvent, resume, education, theodo, dscribeEvent, now]
}

func colorForEvent(calendar: String) -> UIColor? {
    if calendar == kProfessionalCalendar {
        return UIColor(red: 161.0/255.0, green: 225.0/255.0, blue: 230.0/255.0, alpha: 1.0)
    }
    return UIColor(red: 112.0/255.0, green: 31.0/255.0, blue: 117.0/255.0, alpha: 1.0)
}