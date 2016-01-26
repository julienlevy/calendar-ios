//
//  AgendaViewController.swift
//  calendar
//
//  Created by Julien Levy on 23/01/2016.
//  Copyright © 2016 Julien. All rights reserved.
//

import UIKit

let noEventCellIdentifier: String = "noEventCellIdentifier"
let weatherCellIdentifier: String = "weatherCellIdentifier"
let eventCellIdentifier: String = "eventCellIdentifier"

protocol AgendaDelegate {
    func agendaScrolledToDay(day: Int)
    func agendaWillBeginDragging()
}

class AgendaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var delegate: AgendaDelegate?
    
    var tableView: UITableView = UITableView()
    var userStartedScrolling: Bool = false
    
    var eventsByDays: [[Event]?] = [[Event]?]()
    var todayCells: [AnyObject] = [AnyObject]()
    var tomorrowCells: [AnyObject] = [AnyObject]()
    
    var firstDate: NSDate?
    var lastDate: NSDate?
    var calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    var dayFormatter: NSDateFormatter = NSDateFormatter()
    var timeFormatter: NSDateFormatter = NSDateFormatter()
    
    func initData(calendarFirstDate: NSDate, calendarLastDate: NSDate, savedEventsByDays: [[Event]?]) {
        self.firstDate = calendarFirstDate
        self.lastDate = calendarLastDate
        self.eventsByDays = savedEventsByDays
        
        self.setTodayAndTomorrowCellsOrder()
        self.tableView.reloadData()
    }
    func setTodayAndTomorrowCellsOrder() {
        if self.firstDate == nil {
            return
        }
        let todayIndex: Int = self.sectionForDate(NSDate())
        let timesDelimiters: [[String: Int]] = [["Morning": 6], ["Afternoon": 12], ["Evening": 18]]
        
        self.todayCells = self.orderEvents(self.eventsByDays[todayIndex], withDelimiters: timesDelimiters)
        self.tomorrowCells = self.orderEvents(self.eventsByDays[todayIndex + 1], withDelimiters: timesDelimiters)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        let dayFormat = NSDateFormatter.dateFormatFromTemplate("EEEE d MMMM", options: 0, locale: NSLocale(localeIdentifier: "en_US"))
        self.dayFormatter.dateFormat = dayFormat
        let hourFormat = NSDateFormatter.dateFormatFromTemplate("HHmm", options: 0, locale: NSLocale(localeIdentifier: "en_US"))
        self.timeFormatter.dateFormat = hourFormat
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.registerClass(NoEventAgendaCell.self, forCellReuseIdentifier: noEventCellIdentifier)
        self.tableView.registerClass(WeatherAgendaCell.self, forCellReuseIdentifier: weatherCellIdentifier)
        self.tableView.registerClass(EventAgendaCell.self, forCellReuseIdentifier: eventCellIdentifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = minimalRowHeight
        self.view.addSubview(self.tableView)
        setTableViewConstraints()
    }
    override func viewDidAppear(animated: Bool) {
        if firstDate == nil {
            return
        }
        let section: Int = self.sectionForDate(NSDate())
        self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: section), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
    }
    func setTableViewConstraints() {
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        let top: NSLayoutConstraint = NSLayoutConstraint(item: self.tableView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        let left: NSLayoutConstraint = NSLayoutConstraint(item: self.tableView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let right: NSLayoutConstraint = NSLayoutConstraint(item: self.tableView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        let bottom: NSLayoutConstraint = NSLayoutConstraint(item: self.tableView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        
        self.view.addConstraints([top, left, right, bottom])
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.firstDate == nil || self.lastDate == nil {
            return 1
        }
        return self.sectionForDate(self.lastDate!)
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: maybe refacto eventsByDay to be initialized with empty array and not optional arrays...
        let numberOfEvents: Int = (self.eventsByDays[section] != nil ? self.eventsByDays[section]!.count : 0)
        var additionalCells: Int = 0
        if self.firstDate != nil {
            let cellDate = dateForSection(section)
            if self.calendar.isDateInToday(cellDate!) || self.calendar.isDateInTomorrow(cellDate!) {
                //Adding 3 cells for the weather forecasts
                additionalCells = 3
            }
        }
        //Returning "No event" cell for days different than today or tomorrow
        return (numberOfEvents + additionalCells == 0 ? 1 : numberOfEvents + additionalCells)
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let rows: Int = tableView.numberOfRowsInSection(indexPath.section)
        //rows == 1 not to display No event for today or tomorrow
        if rows == 1 && self.eventsByDays[indexPath.section] == nil {
            if let cell = tableView.dequeueReusableCellWithIdentifier(noEventCellIdentifier) as? NoEventAgendaCell {
                return cell
            }
        }
        let cellDate = dateForSection(indexPath.section)
        if self.calendar.isDateInToday(cellDate!) || self.calendar.isDateInTomorrow(cellDate!) {
            let dayObject = (self.calendar.isDateInToday(cellDate!) ? self.todayCells[indexPath.item] : self.tomorrowCells[indexPath.item])
            
            if let event = dayObject as? Event {
                if let cell = tableView.dequeueReusableCellWithIdentifier(eventCellIdentifier) as? EventAgendaCell {
                    cell.titleLabel.text = event.title
                    cell.timeLabel.text = (event.allDay ? "ALL DAY" : self.timeFormatter.stringFromDate(event.date))
                    cell.durationLabel.text = (event.allDay ? "" : readableDurationFromMinutes(event.duration))
                    cell.eventTypeView.backgroundColor = colorForEvent(event.containingCalendar)
                    return cell
                }
            }
            else if let moment = dayObject as? String {
                if let cell = tableView.dequeueReusableCellWithIdentifier(weatherCellIdentifier) as? WeatherAgendaCell {
                    cell.label.text = moment
                    cell.weatherIcon.backgroundColor = UIColor.yellowColor()
                    return cell
                }
            }
        }
        if let cell = tableView.dequeueReusableCellWithIdentifier(eventCellIdentifier) as? EventAgendaCell {
            if self.eventsByDays[indexPath.section] != nil {
                if indexPath.row < self.eventsByDays[indexPath.section]!.count {
                    let event: Event = self.eventsByDays[indexPath.section]![indexPath.row]
                    
                    cell.titleLabel.text = event.title
                    cell.timeLabel.text = (event.allDay ? "ALL DAY" : self.timeFormatter.stringFromDate(event.date))
                    cell.durationLabel.text = (event.allDay ? "" : readableDurationFromMinutes(event.duration))
                    cell.eventTypeView.backgroundColor = colorForEvent(event.containingCalendar)
                }
            }
            return cell
        }
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("cell") {
            return cell
        }
        return UITableViewCell()
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Template Line Date"
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var prefix: String = ""
        var dayString: String = ""
        var isToday: Bool = false
        if self.firstDate != nil {
            let cellDate = dateForSection(section)
            dayString = dayFormatter.stringFromDate(cellDate!)
            if self.calendar.isDateInToday(cellDate!) {
                prefix = "Today • "
                isToday = true
            }
            else if self.calendar.isDateInTomorrow(cellDate!) {
                prefix = "Tomorrow • "
            }
            else if self.calendar.isDateInYesterday(cellDate!) {
                prefix = "Yesterday • "
            }
        }
        return DayHeaderViewAgenda(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: rowHeaderHeight), title: prefix + dayString, isToday: isToday)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if !self.userStartedScrolling {
            return
        }
        if let indexPaths = self.tableView.indexPathsForVisibleRows {
            if indexPaths.first == nil {
                return
            }
            self.delegate?.agendaScrolledToDay(indexPaths.first!.section)
        }
    }
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.delegate?.agendaWillBeginDragging()
        
        self.userStartedScrolling = true
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.userStartedScrolling = false
        }
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.userStartedScrolling = false
    }
    
    func dateForSection(section: Int) -> NSDate? {
        let dateComponents = NSDateComponents()
        dateComponents.day = section
        return self.calendar.dateByAddingComponents(dateComponents, toDate: self.firstDate!, options: NSCalendarOptions.MatchFirst)
    }
    func sectionForDate(date: NSDate) -> Int {
        return self.calendar.components(NSCalendarUnit.Day, fromDate: self.firstDate!, toDate: date, options: NSCalendarOptions.MatchFirst).day
    }
    func readableDurationFromMinutes(duration: Int) -> String {
        let hours = Int(duration / 60)
        let minutes = duration % 60

        //Prints 0m if the duration if null
        return (hours != 0 ? String(hours) + "h " : "") + (minutes != 0 || hours == 0 ? String(minutes) + "m" : "")
    }
    func orderEvents(events: [Event]?, withDelimiters delimiters: [[String: Int]]) -> [AnyObject] {
        var result: [AnyObject] = [AnyObject]()
        
        //Doing this allows to input nil array and return just the delimiters
        let countEvents: Int = (events == nil ? 0 : events!.count)
        
        var eventIndex: Int = 0
        var weatherIndex: Int = 0
        while eventIndex < countEvents || weatherIndex < delimiters.count {
            if eventIndex >= countEvents {
                result.append(delimiters[weatherIndex].keys.first!)
                weatherIndex++
                continue
            }
            if weatherIndex >= delimiters.count {
                result.append(events![eventIndex])
                eventIndex++
                continue
            }
            
            //At this point events can't be nil
            if events![eventIndex].allDay || self.calendar.component(NSCalendarUnit.Hour, fromDate: events![eventIndex].date) < delimiters[weatherIndex].values.first! {
                result.append(events![eventIndex])
                eventIndex++
            }
            else {
                result.append(delimiters[weatherIndex].keys.first!)
                weatherIndex++
            }
        }
        
        return result
    }
}
