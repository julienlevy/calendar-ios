//
//  MainPageViewController.swift
//  calendar
//
//  Created by Julien Levy on 23/01/2016.
//  Copyright © 2016 Julien. All rights reserved.
//

import UIKit

class MainPageViewController: UIViewController {
    var calendarViewController: CalendarViewController?
    var agendaViewController: AgendaViewController?
    
    var firstDate: NSDate?
    var lastDate: NSDate?
    var calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    
    var eventsByDays: [[Event]?] = [[Event]?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setDatesLimits()
        self.orderEventsByDay()
        
        self.calendarViewController = CalendarViewController()
        self.agendaViewController = AgendaViewController()
        
        if self.firstDate != nil && self.lastDate != nil {
            self.calendarViewController?.initData(self.firstDate!, calendarLastDate: self.lastDate!)
            self.agendaViewController?.initData(self.firstDate!, calendarLastDate: self.lastDate!, savedEventsByDays: self.eventsByDays)
        }
        
        self.view.addSubview(calendarViewController!.view)
        self.view.addSubview(agendaViewController!.view)
        
        self.addChildViewController(calendarViewController!)
        self.addChildViewController(agendaViewController!)
        
        self.calendarViewController?.didMoveToParentViewController(self)
        self.agendaViewController?.didMoveToParentViewController(self)
        
        self.setCalendarLayoutConstraints()
        self.setAgendaLayoutConstraints()
        
    }
    
    func setDatesLimits() {
        //Going 3 months before now & then getting for first sunday after this date
        let monthOffset = NSDateComponents()
        monthOffset.month = -3
        let before = self.calendar.dateByAddingComponents(monthOffset, toDate: NSDate(), options: NSCalendarOptions.MatchFirst)
        let sundayComp = NSDateComponents()
        sundayComp.weekday = 1
        self.firstDate = self.calendar.nextDateAfterDate(before!, matchingComponents: sundayComp, options: NSCalendarOptions.MatchPreviousTimePreservingSmallerUnits)
        
        //Last date anyday 3 months from now
        monthOffset.month = 3
        self.lastDate = self.calendar.dateByAddingComponents(monthOffset, toDate: NSDate(), options: NSCalendarOptions.MatchFirst)
    }
    func orderEventsByDay() {
        let numberOfDays = self.calendar.components(NSCalendarUnit.Day, fromDate: self.firstDate!, toDate: self.lastDate!, options: NSCalendarOptions.MatchFirst).day
        let savedEvents: [Event] = [firstEvent] //Should get events from local database and API check
        
        self.eventsByDays = [[Event]?](count: numberOfDays, repeatedValue: nil)
        for event in savedEvents {
            let dayIndex = self.calendar.components(NSCalendarUnit.Day, fromDate: self.firstDate!, toDate: event.date, options: NSCalendarOptions.MatchFirst).day
            if self.eventsByDays[dayIndex] == nil {
                self.eventsByDays[dayIndex] = [Event]()
            }
            self.eventsByDays[dayIndex]?.append(event)
        }
    }
    
    func setCalendarLayoutConstraints() {
        self.calendarViewController?.view.translatesAutoresizingMaskIntoConstraints = false
        let top: NSLayoutConstraint = NSLayoutConstraint(item: self.calendarViewController!.view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.TopMargin, multiplier: 1, constant: 0)
        let left: NSLayoutConstraint = NSLayoutConstraint(item: self.calendarViewController!.view, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let right: NSLayoutConstraint = NSLayoutConstraint(item: self.calendarViewController!.view, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        let height: NSLayoutConstraint = NSLayoutConstraint(item: self.calendarViewController!.view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 300)
        
        self.view.addConstraints([top, left, right, height])
    }
    func setAgendaLayoutConstraints() {
        self.agendaViewController?.view.translatesAutoresizingMaskIntoConstraints = false
        let top: NSLayoutConstraint = NSLayoutConstraint(item: self.agendaViewController!.view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.calendarViewController!.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        let left: NSLayoutConstraint = NSLayoutConstraint(item: self.agendaViewController!.view, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let right: NSLayoutConstraint = NSLayoutConstraint(item: self.agendaViewController!.view, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        let bottom: NSLayoutConstraint = NSLayoutConstraint(item: self.agendaViewController!.view, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        
        self.view.addConstraints([top, left, right, bottom])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}