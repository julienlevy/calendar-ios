//
//  MainPageViewController.swift
//  calendar
//
//  Created by Julien Levy on 23/01/2016.
//  Copyright © 2016 Julien. All rights reserved.
//

import UIKit

let kEventColor = "kEventColor"

class MainPageViewController: UIViewController, CalendarDelegate, AgendaDelegate {
    var calendarViewController: CalendarViewController?
    var agendaViewController: AgendaViewController?
    var calendarCellSide: CGFloat = 0
    var calendarHeightConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    var firstDate: NSDate?
    var lastDate: NSDate?
    var calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    
    var eventsByDays: [[Event]?] = [[Event]?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setDatesLimits()
        self.orderEventsByDay()
        let screen = UIScreen.mainScreen().bounds.width
        self.calendarCellSide = screen / 7.0
        
        self.calendarViewController = CalendarViewController()
        self.agendaViewController = AgendaViewController()
        
        if self.firstDate != nil && self.lastDate != nil {
            self.calendarViewController?.initData(self.firstDate!, calendarLastDate: self.lastDate!, savedEventsByDays: self.eventsByDays)
            self.agendaViewController?.initData(self.firstDate!, calendarLastDate: self.lastDate!, savedEventsByDays: self.eventsByDays)
        }
        
        calendarViewController?.delegate = self
        agendaViewController?.delegate = self
        
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
        monthOffset.month = 6
        self.lastDate = self.calendar.dateByAddingComponents(monthOffset, toDate: NSDate(), options: NSCalendarOptions.MatchFirst)
    }
    func orderEventsByDay() {
        let numberOfDays = self.calendar.components(NSCalendarUnit.Day, fromDate: self.firstDate!, toDate: self.lastDate!, options: NSCalendarOptions.MatchFirst).day
        let savedEvents: [Event] = demoEvents() //Should get events from local database and API check
        
        self.eventsByDays = [[Event]?](count: numberOfDays, repeatedValue: nil)
        for event in savedEvents {
            let dayIndex = self.calendar.components(NSCalendarUnit.Day, fromDate: self.firstDate!, toDate: event.date, options: NSCalendarOptions.MatchFirst).day
            if self.eventsByDays[dayIndex] == nil {
                self.eventsByDays[dayIndex] = [Event]()
            }
            self.eventsByDays[dayIndex]?.append(event)
        }
        for i in 0..<numberOfDays {
            if self.eventsByDays[i] != nil {
                //Sorting All Day events first in array
                self.eventsByDays[i] = self.eventsByDays[i]!.sort( {
                    if $0.allDay {
                        return true
                    }
                    if $1.allDay {
                        return false
                    }
                    return $0.date.compare($1.date) == NSComparisonResult.OrderedAscending
                })
            }
        }
    }
    
    func setCalendarLayoutConstraints() {
        self.calendarViewController?.view.translatesAutoresizingMaskIntoConstraints = false
        let top: NSLayoutConstraint = NSLayoutConstraint(item: self.calendarViewController!.view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.TopMargin, multiplier: 1, constant: UIApplication.sharedApplication().statusBarFrame.height)
        let left: NSLayoutConstraint = NSLayoutConstraint(item: self.calendarViewController!.view, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let right: NSLayoutConstraint = NSLayoutConstraint(item: self.calendarViewController!.view, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        calendarHeightConstraint = NSLayoutConstraint(item: self.calendarViewController!.view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 5 * self.calendarCellSide + dayHeaderViewHeight)
        
        self.view.addConstraints([top, left, right, calendarHeightConstraint])
    }
    func setAgendaLayoutConstraints() {
        self.agendaViewController?.view.translatesAutoresizingMaskIntoConstraints = false
        let top: NSLayoutConstraint = NSLayoutConstraint(item: self.agendaViewController!.view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.calendarViewController!.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        let left: NSLayoutConstraint = NSLayoutConstraint(item: self.agendaViewController!.view, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let right: NSLayoutConstraint = NSLayoutConstraint(item: self.agendaViewController!.view, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        let bottom: NSLayoutConstraint = NSLayoutConstraint(item: self.agendaViewController!.view, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        
        self.view.addConstraints([top, left, right, bottom])
    }
    
    // MARK: Agenda & Calendar Delegates
    func calendarSelectedDayFromFirst(day: Int) {
        self.agendaViewController?.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: day), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    }
    func agendaScrolledToDay(day: Int) {
        self.calendarViewController?.selectAndDisplayItemInCollectionViewAtIndexPath(NSIndexPath(forItem: day, inSection: 0), animated: true, scrollPosition: UICollectionViewScrollPosition.None)
    }
    func calendarWillBeginDragging() {
        calendarHeightConstraint.constant = 5 * self.calendarCellSide + dayHeaderViewHeight
        UIView.animateWithDuration(0.2, animations: {
            self.view.layoutIfNeeded()
        })
    }
    func agendaWillBeginDragging() {
        calendarHeightConstraint.constant = 2 * self.calendarCellSide + dayHeaderViewHeight
        UIView.animateWithDuration(0.2, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}