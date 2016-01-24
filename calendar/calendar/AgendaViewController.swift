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

class AgendaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tableView: UITableView = UITableView()
    
    var firstDate: NSDate?
    var lastDate: NSDate?
    var calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    var dayFormatter: NSDateFormatter = NSDateFormatter()
    
    func initData(calendarFirstDate: NSDate, calendarLastDate: NSDate) {
        self.firstDate = calendarFirstDate
        self.lastDate = calendarLastDate
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        let format = NSDateFormatter.dateFormatFromTemplate("EEEE d MMMM", options: 0, locale: NSLocale(localeIdentifier: "en_US"))
        dayFormatter.dateFormat = format
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.registerClass(NoEventAgendaCell.self, forCellReuseIdentifier: noEventCellIdentifier)
        self.tableView.registerClass(WeatherAgendaCell.self, forCellReuseIdentifier: weatherCellIdentifier)
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
        let section: Int = self.calendar.components(NSCalendarUnit.Day, fromDate: self.firstDate!, toDate: NSDate(), options: NSCalendarOptions.MatchFirst).day
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
        return self.calendar.components(NSCalendarUnit.Day, fromDate: self.firstDate!, toDate: self.lastDate!, options: NSCalendarOptions.MatchFirst).day
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfEvents: Int = 0
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
        if rows == 1 {
            if let cell = tableView.dequeueReusableCellWithIdentifier(noEventCellIdentifier) as? NoEventAgendaCell {
                return cell
            }
        }
        let cellDate = dateForSection(indexPath.section)
        if self.calendar.isDateInToday(cellDate!) || self.calendar.isDateInTomorrow(cellDate!) {
            if let cell = tableView.dequeueReusableCellWithIdentifier(weatherCellIdentifier) as? WeatherAgendaCell {
                cell.label.text = ["Morning", "Afternoon", "Evening"][indexPath.row]
                cell.weatherIcon.backgroundColor = UIColor.yellowColor()
                return cell
            }
        }
        if let cell = tableView.dequeueReusableCellWithIdentifier("cell") {
            return cell
        }
        return UITableViewCell()
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var prefix: String = ""
        var dayString: String = ""
        if self.firstDate != nil {
            let cellDate = dateForSection(section)
            dayString = dayFormatter.stringFromDate(cellDate!)
            if self.calendar.isDateInToday(cellDate!) {
                prefix = "Today • "
            }
            else if self.calendar.isDateInTomorrow(cellDate!) {
                prefix = "Tomorrow • "
            }
            else if self.calendar.isDateInYesterday(cellDate!) {
                prefix = "Yesterday • "
            }
        }
        return prefix + dayString
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
    
    func dateForSection(section: Int) -> NSDate? {
        let dateComponents = NSDateComponents()
        dateComponents.day = section
        return self.calendar.dateByAddingComponents(dateComponents, toDate: self.firstDate!, options: NSCalendarOptions.MatchFirst)
    }
}
