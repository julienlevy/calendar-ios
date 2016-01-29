//
//  AgendaViewController.swift
//  calendar
//
//  Created by Julien Levy on 23/01/2016.
//  Copyright © 2016 Julien. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftOpenWeatherMapAPI
import SwiftyJSON

let noEventCellIdentifier: String = "noEventCellIdentifier"
let dayPeriodCellIdentifier: String = "dayPeriodCellIdentifier"
let eventCellIdentifier: String = "eventCellIdentifier"

protocol AgendaDelegate {
    func agendaScrolledToDay(day: Int)
    func agendaWillBeginDragging()
}

class AgendaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    var delegate: AgendaDelegate?
    
    var goToToday: ArrowButton = ArrowButton()
    var tableView: UITableView = UITableView()
    var userStartedScrolling: Bool = false
    
    var eventsByDays: [[Event]?] = [[Event]?]()
    var todayCells: [AnyObject] = [AnyObject]()
    var tomorrowCells: [AnyObject] = [AnyObject]()
    var currentEventIndex: Int = 0
    var nextEventIndex: Int = -1
    
    var firstDate: NSDate?
    var lastDate: NSDate?
    var calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    var dayFormatter: NSDateFormatter = NSDateFormatter()
    var timeFormatter: NSDateFormatter = NSDateFormatter()
    
    var weatherForecasts: [String: (String, Int)] = [String: (String, Int)]()
    // TODO: sort weather for events by location to limit API calls if several events are far from user but close together (very likely)
    var eventWeatherForecasts: [String: (String, Int)] = [String: (String, Int)]()
    
    let locationManager: CLLocationManager = CLLocationManager()
    var userLocation: CLLocation?
    
    // MARK: inits to call from parent view controller
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
        
        self.todayCells = self.orderEvents(self.eventsByDays[todayIndex], withDelimiters: dayPeriods)
        self.tomorrowCells = self.orderEvents(self.eventsByDays[todayIndex + 1], withDelimiters: dayPeriods)
        self.currentEventIndex = self.getCurrentEventIndex()
        self.nextEventIndex = self.getNextEventIndex()
    }
    
    // MARK: View Controller lifecycle and constraints
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
        self.tableView.registerClass(DayPeriodAgendaCell.self, forCellReuseIdentifier: dayPeriodCellIdentifier)
        self.tableView.registerClass(EventAgendaCell.self, forCellReuseIdentifier: eventCellIdentifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = minimalRowHeight
        
        self.goToToday.addTarget(self, action: Selector("scrollToNow"), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.goToToday)
        
        self.setTableViewConstraints()
        self.setTodayButtonConstraints()
        
        self.getUserLocationForWeather()
    }
    override func viewDidAppear(animated: Bool) {
        self.scrollToRowAtIndexPathAndDisplayArrowButton(NSIndexPath(forRow: self.currentEventIndex, inSection: self.sectionForDate(NSDate())), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    }
    func setTableViewConstraints() {
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        let top: NSLayoutConstraint = NSLayoutConstraint(item: self.tableView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        let left: NSLayoutConstraint = NSLayoutConstraint(item: self.tableView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let right: NSLayoutConstraint = NSLayoutConstraint(item: self.tableView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        let bottom: NSLayoutConstraint = NSLayoutConstraint(item: self.tableView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        
        self.view.addConstraints([top, left, right, bottom])
    }
    func setTodayButtonConstraints() {
        self.goToToday.translatesAutoresizingMaskIntoConstraints = false
        let left: NSLayoutConstraint = NSLayoutConstraint(item: self.goToToday, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 10)
        let bottom: NSLayoutConstraint = NSLayoutConstraint(item: self.goToToday, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -10)
        
        let width: NSLayoutConstraint = NSLayoutConstraint(item: self.goToToday, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 30)
        let height: NSLayoutConstraint = NSLayoutConstraint(item: self.goToToday, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 30)
        
        self.view.addConstraints([left, bottom, width, height])
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: table view datasource
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
        let cellDate: NSDate? = dateForSection(indexPath.section)
        let isToday: Bool  = self.calendar.isDateInToday(cellDate!)
        let isTomorrow: Bool = self.calendar.isDateInTomorrow(cellDate!)
        
        if isToday || isTomorrow {
            let dayObject: AnyObject = (isToday ? self.todayCells[indexPath.item] : self.tomorrowCells[indexPath.item])
            
            if let event = dayObject as? Event {
                if let cell = tableView.dequeueReusableCellWithIdentifier(eventCellIdentifier) as? EventAgendaCell {
                    
                    cell.setEvent(event,
                        formattedTime: self.timeFormatter.stringFromDate(event.date),
                        formattedDuration: readableDurationFromMinutes(event.duration),
                        eventIsCurrent: (isToday && indexPath.item == self.currentEventIndex),
                        soonWarning: ((isToday && indexPath.item == self.nextEventIndex) ? self.readableWarningIfSoonFromDate(event.date) : nil)
                    )
                    
                    return cell
                }
            }
            else if let moment = dayObject as? String {
                if let cell = tableView.dequeueReusableCellWithIdentifier(dayPeriodCellIdentifier) as? DayPeriodAgendaCell {
                    
                    cell.label.text = moment
                    cell.triangleCurrentView.hidden = !(isToday && indexPath.item == self.currentEventIndex)
                    self.setWeatherforMoment(cell, isToday: isToday, moment: moment)
                    
                    return cell
                }
            }
        }
        else { //Not Today or Tomorrow
            if let events = self.eventsByDays[indexPath.section] { // Has events
                if indexPath.row < events.count {
                    
                    let event: Event = events[indexPath.row]
                    if let cell = tableView.dequeueReusableCellWithIdentifier(eventCellIdentifier) as? EventAgendaCell {
                        
                        cell.setEvent(event,
                            formattedTime: self.timeFormatter.stringFromDate(event.date),
                            formattedDuration: readableDurationFromMinutes(event.duration)
                        )
                        return cell
                    }
                }
            }
            else { // No events
                if let cell = tableView.dequeueReusableCellWithIdentifier(noEventCellIdentifier) as? NoEventAgendaCell {
                    
                    return cell
                }
            }
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
        return DayHeaderViewAgenda(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: rowHeaderHeight), title: (prefix + dayString).uppercaseString, isToday: isToday)
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return dayHeaderViewHeight
    }
    
    // MARK: table view delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: scroll view delegate
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
        
        let offset = self.tableView.contentOffset
        let indexPath = self.tableView.indexPathForRowAtPoint(CGPoint(x: offset.x, y: offset.y + dayHeaderViewHeight))
        if indexPath!.row == self.currentEventIndex && indexPath!.section == self.sectionForDate(NSDate()) {
            self.hideArrowButton()
        }
        else {
            self.showArrowButton()
        }
       
    }
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let targetOffset: CGPoint = targetContentOffset.memory
        let targetIndexPath: NSIndexPath? = self.tableView.indexPathForRowAtPoint(targetOffset)
        if targetIndexPath == nil {
            return
        }
        let rect: CGRect = self.tableView.rectForRowAtIndexPath(targetIndexPath!)
        if fabsf(Float(targetOffset.y - rect.origin.y)) < fabsf(Float((rect.origin.y + rect.height) - targetOffset.y)) {
            targetContentOffset.memory.y = rect.origin.y - dayHeaderViewHeight
        }
        else {
            if targetIndexPath!.row == self.tableView.numberOfRowsInSection(targetIndexPath!.section) - 1 {
                targetContentOffset.memory.y = rect.origin.y + rect.height
            }
            else {
                targetContentOffset.memory.y = rect.origin.y + rect.height - dayHeaderViewHeight
            }
        }
    }
    
    // MARK: Scroll view utils
    func scrollToNow() {
        let section = self.sectionForDate(NSDate())
        self.scrollToRowAtIndexPathAndDisplayArrowButton(NSIndexPath(forRow: self.currentEventIndex, inSection: section), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        self.delegate?.agendaScrolledToDay(section)
    }
    func scrollToRowAtIndexPathAndDisplayArrowButton(indexPath: NSIndexPath, atScrollPosition: UITableViewScrollPosition, animated: Bool) {
        self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: atScrollPosition, animated: animated)
        if indexPath.row == self.currentEventIndex && indexPath.section == self.sectionForDate(NSDate()) {
            self.hideArrowButton()
        }
    }
    
    func showArrowButton() {
        UIView.animateWithDuration(0.3, animations: {
            self.goToToday.alpha = 1
        })
    }
    func hideArrowButton() {
        UIView.animateWithDuration(0.3, animations: {
            self.goToToday.alpha = 0
        })
    }
    
    // MARK: Weather API calls
    func getUserLocationForWeather() {
        print(CLLocationManager.authorizationStatus())
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            self.locationManager.requestLocation()
        }
    }
    func getWeatherForecastsAtUserCoordinate(coordinate: CLLocationCoordinate2D) {
        let weatherAPI = WAPIManager(apiKey: "21ae9c4b261318e5b053951b9a6c456e", temperatureFormat: .Celsius)
        
        weatherAPI.forecastWeatherByCoordinatesAsJson(coordinate, data: { (json) -> Void in
            
            let dict = json["list"]
            for i in 0..<json["list"].count {
                self.addWeatherAPIResultToLocalForecasts(dict[i])
            }
            weatherAPI.currentWeatherByCoordinatesAsJson(coordinate, data: { (json) -> Void in
                self.addWeatherAPIResultToLocalForecasts(json)
                
                print(self.weatherForecasts)
                self.reloadTodayAndTomorrowWeathers()
            })
        })
    }
    func addWeatherAPIResultToLocalForecasts(data: JSON) {
        let dt = data["dt"].double
        let unix = NSDate(timeIntervalSince1970: dt!)
        var key = ""
        key = (self.calendar.isDateInToday(unix) ? "today" : "tomorrow") + "_"
        for tuple in dayPeriods {
            let v = tuple.1
            let hour = self.calendar.component(.Hour, fromDate: unix)
            if hour >= v.0 && hour < v.1 {
                key += tuple.0
                if self.weatherForecasts[key] == nil {
                    let weatherImage: String? = data["weather"][0]["icon"].string
                    let temperature: Int? = data["main"]["temp"].int
                    if weatherImage != nil && temperature != nil {
                        self.weatherForecasts[key] = (weatherImage!, temperature!)
                    }
                }
                break
            }
        }
    }
    func getWeatherForEventCell(cell: EventAgendaCell, event: Event) {
        // Called only on cells that have a non nil locationCoordinate
        if self.userLocation == nil {
            return
        }
        
        if let location = event.locationCoordinate {
            // Returns distance in meters
            if location.distanceFromLocation(self.userLocation!) < 100000.0 {
                return
            }
            
            let weatherAPI = WAPIManager(apiKey: "21ae9c4b261318e5b053951b9a6c456e", temperatureFormat: .Celsius)
            
            print("Checking weather for event: " + event.title)
            weatherAPI.forecastWeatherByCoordinatesAsJson(location.coordinate, data: { (json) -> Void in
                let dict = json["list"]
                for i in 0..<json["list"].count {
                    let dt = dict[i]["dt"].double
                    let unix = NSDate(timeIntervalSince1970: dt!)
                    
                    if unix.dateByAddingTimeInterval(NSTimeInterval(4 * 60 * 60)).compare(event.date) != unix.compare(event.date) {
                        
                        let weatherImage: String? = dict[i]["weather"][0]["icon"].string
                        let temperature: Int? = dict[i]["main"]["temp"].int
                        if weatherImage != nil && temperature != nil {
                            self.eventWeatherForecasts[self.dictKeyFromIndexPath(self.tableView.indexPathForCell(cell)!)] = (weatherImage!, temperature!)
                            self.setWeatherForEvent(cell, event: event)
                            
                            break
                        }
                    }
                }
            })
        }
    }
    
    // MARK: CLLocationManager delegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.userLocation = location

            self.getWeatherForecastsAtUserCoordinate(location.coordinate)
            
            self.startGettingWeathersForTodayAndTomorrowEvents()
        }
    }
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Location error")
        print(error)
    }
    
    // MARK: Weather Utils
    func startGettingWeathersForTodayAndTomorrowEvents() {
        let todaySectionIndex: Int = self.sectionForDate(NSDate())
        for i in 0..<self.tableView.numberOfRowsInSection(todaySectionIndex) {
            if let event = self.todayCells[i] as? Event {
                if let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: todaySectionIndex)) as? EventAgendaCell {
                    
                    if event.locationCoordinate != nil {
                        
                        self.getWeatherForEventCell(cell, event: event)
                    }
                }
            }
        }
        for i in 0..<self.tableView.numberOfRowsInSection(todaySectionIndex + 1) {
            if let event = self.tomorrowCells[i] as? Event {
                if let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: todaySectionIndex + 1)) as? EventAgendaCell {
                    
                    if event.locationCoordinate != nil {
                        
                        self.getWeatherForEventCell(cell, event: event)
                    }
                }
            }
        }
    }
    func reloadTodayAndTomorrowWeathers() {
        
    }
    func setWeatherforMoment(cell: DayPeriodAgendaCell, isToday: Bool, moment: String) {
        cell.weatherIcon.hidden = true
        cell.temperatureLabel.hidden = true
        let key = (isToday ? "today" : "tomorrow") + "_" + moment
        if self.weatherForecasts[key] != nil {
            cell.setWeather(self.weatherForecasts[key]!)
        }
    }
    func setWeatherForEvent(cell: EventAgendaCell, event: Event) {
        let indexPath = self.tableView.indexPathForCell(cell)
        if indexPath == nil {
            return
        }
        if let forecast = self.eventWeatherForecasts[self.dictKeyFromIndexPath(indexPath!)] {
            
            cell.setWeather(forecast)
        }
    }
    
    // MARK: Date utils
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
    func readableWarningIfSoonFromDate(date: NSDate) -> String? {
        let minutes = self.calendar.components(NSCalendarUnit.Minute, fromDate: NSDate(), toDate: date, options: NSCalendarOptions.MatchFirst).minute
        if minutes <= 60 && minutes >= 0 {
            return "In \(minutes) min"
        }
        return nil
    }
    
    // MARK: Events utils
    func orderEvents(events: [Event]?, withDelimiters delimiters: [(String, (Int, Int))]) -> [AnyObject] {
        var result: [AnyObject] = [AnyObject]()
        
        //Doing this allows to input nil array and return just the delimiters
        let countEvents: Int = (events == nil ? 0 : events!.count)
        
        var eventIndex: Int = 0
        var weatherIndex: Int = 0
        while eventIndex < countEvents || weatherIndex < delimiters.count {
            if eventIndex >= countEvents {
                result.append(delimiters[weatherIndex].0)
                weatherIndex++
                continue
            }
            if weatherIndex >= delimiters.count {
                result.append(events![eventIndex])
                eventIndex++
                continue
            }
            
            //At this point events can't be nil
            if events![eventIndex].allDay || self.calendar.component(NSCalendarUnit.Hour, fromDate: events![eventIndex].date) < delimiters[weatherIndex].1.0 {
                result.append(events![eventIndex])
                eventIndex++
            }
            else {
                result.append(delimiters[weatherIndex].0)
                weatherIndex++
            }
        }
        
        return result
    }
    func getCurrentEventIndex() -> Int {
        for i in 0..<self.todayCells.count {
            if let event = self.todayCells[i] as? Event {
                if event.allDay {
                    continue
                }
                //First event comprising current time
                let durationTimeInterval: NSTimeInterval = NSTimeInterval(event.duration * 60)
                if event.date.compare(NSDate()) != (event.date.dateByAddingTimeInterval(durationTimeInterval).compare(NSDate())) {
                    return i
                }
                let twoHoursTimeInterval: NSTimeInterval = NSTimeInterval(2 * 60 * 60)
                if NSDate().dateByAddingTimeInterval(twoHoursTimeInterval).compare(event.date) != NSDate().compare(event.date) {
                    return i
                }
            }
        }
        //In case we haven't found a matching event
        let hour: Int = self.calendar.component(NSCalendarUnit.Hour, fromDate: NSDate())
        for i in 0..<self.todayCells.count {
            if let period = self.todayCells[i] as? String {
                for tuple in dayPeriods {
                    // Return index of period if the time is before the end of the period (morning will have matched before afternoon anyway)
                    if tuple.0 == period && hour < tuple.1.1 {
                        return i
                    }
                }
            }
        }
        return 0
    }
    func getNextEventIndex() -> Int {
        for i in 0..<self.todayCells.count {
            if let event = self.todayCells[i] as? Event {
                if event.allDay {
                    continue
                }
                //First event after current time
                if NSDate().compare(event.date) == NSComparisonResult.OrderedAscending {
                    return i
                }
            }
        }
        //So that it will never match an Index Path
        return -1
    }
    func dictKeyFromIndexPath(indexPath: NSIndexPath) -> String {
        return String(indexPath.row) + "_" + String(indexPath.section)
    }
}
