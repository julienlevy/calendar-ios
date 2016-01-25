//
//  CalendarViewController.swift
//  calendar
//
//  Created by Julien Levy on 23/01/2016.
//  Copyright © 2016 Julien. All rights reserved.
//

import UIKit

let calendarCellIdentifier: String = "calendarCell"

protocol CalendarDelegate {
    func calendarSelectedDayFromFirst(day: Int)
}

class CalendarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var delegate: CalendarDelegate?
    
    var collectionView: UICollectionView?
    var itemSide: CGFloat = 0
    var minimumInteritemSpacing: CGFloat = 0
    var currentSelectedCell: CalendarViewCell?
    
    var firstDate: NSDate?
    var lastDate: NSDate?
    var calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    let monthFormatter: NSDateFormatter = NSDateFormatter()
    
    var dayHeader: UIView = UIView()
    var headerColor: UIColor = UIColor.lightGrayColor()
    
    func initData(calendarFirstDate: NSDate, calendarLastDate: NSDate) {
        self.firstDate = calendarFirstDate
        self.lastDate = calendarLastDate
        self.collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.lightGrayColor()
        
        self.monthFormatter.dateFormat = "MMM"
        
        self.itemSide = UIScreen.mainScreen().bounds.width/CGFloat(7) - 1
        self.minimumInteritemSpacing = 1.0
        let collectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = UICollectionViewScrollDirection.Vertical
        collectionViewLayout.minimumInteritemSpacing = self.minimumInteritemSpacing
        collectionViewLayout.minimumLineSpacing = self.minimumInteritemSpacing
        collectionViewLayout.itemSize = CGSize(width: self.itemSide, height: self.itemSide)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: collectionViewLayout)
        self.collectionView?.backgroundColor = UIColor.clearColor()
        self.collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.collectionView?.registerClass(CalendarViewCell.self, forCellWithReuseIdentifier: calendarCellIdentifier)
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.collectionView?.allowsSelection = true
        
        self.dayHeader.backgroundColor = self.headerColor
        self.view.addSubview(self.dayHeader)
        self.view.addSubview(collectionView!)
        self.setCollectionViewConstraints()
        self.setDayHeaderConstraints()
        
        self.setUpDaysOfHeader()
    }
    override func viewDidAppear(animated: Bool) {
        if firstDate == nil {
            return
        }
        let index: Int = self.calendar.components(NSCalendarUnit.Day, fromDate: self.firstDate!, toDate: NSDate(), options: NSCalendarOptions.MatchFirst).day
        self.selectAndDisplayItemInCollectionViewAtIndexPath(NSIndexPath(forItem: index, inSection: 0), animated: false, scrollPosition: UICollectionViewScrollPosition.Top)
    }
    func setCollectionViewConstraints() {
        self.collectionView?.translatesAutoresizingMaskIntoConstraints = false
        let top: NSLayoutConstraint = NSLayoutConstraint(item: collectionView!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.dayHeader, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        let left: NSLayoutConstraint = NSLayoutConstraint(item: collectionView!, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let right: NSLayoutConstraint = NSLayoutConstraint(item: collectionView!, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        let bottom: NSLayoutConstraint = NSLayoutConstraint(item: collectionView!, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        
        self.view.addConstraints([top, left, right, bottom])
    }
    func setDayHeaderConstraints() {
        self.dayHeader.translatesAutoresizingMaskIntoConstraints = false
        let top: NSLayoutConstraint = NSLayoutConstraint(item: self.dayHeader, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: UIApplication.sharedApplication().statusBarFrame.height)
        let left: NSLayoutConstraint = NSLayoutConstraint(item: self.dayHeader, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let right: NSLayoutConstraint = NSLayoutConstraint(item: self.dayHeader, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        let height: NSLayoutConstraint = NSLayoutConstraint(item: self.dayHeader, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 20)
        
        self.view.addConstraints([top, left, right, height])
    }
    func setUpDaysOfHeader() {
        //Remove 1 to count from 0
        //TODO replace with normal order
        let symbols = self.calendar.veryShortWeekdaySymbols
        for i in 0...(symbols.count-1) {
            let label = UILabel(frame: CGRectMake(CGFloat(i) * itemSide + CGFloat(i-1) * minimumInteritemSpacing, 0, itemSide, 20))
            label.text = symbols[i]
            label.textAlignment = .Center
            label.textColor = UIColor.blackColor()
            self.dayHeader.addSubview(label)
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.firstDate == nil || self.lastDate == nil {
            return 0
        }
        //nil doesn't work for the NSCalendarOptions
        return self.calendar.components(NSCalendarUnit.Day, fromDate: self.firstDate!, toDate: self.lastDate!, options: NSCalendarOptions.MatchFirst).day
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell: CalendarViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(calendarCellIdentifier, forIndexPath: indexPath) as? CalendarViewCell {
            if self.firstDate != nil {
                let dateComponents = NSDateComponents()
                dateComponents.day = indexPath.item
                let cellDate = self.calendar.dateByAddingComponents(dateComponents, toDate: self.firstDate!, options: NSCalendarOptions.MatchFirst)
                let day: Int = self.calendar.component(NSCalendarUnit.Day, fromDate: cellDate!)
                let month: String = self.monthFormatter.stringFromDate(cellDate!)
                let isToday: Bool = self.calendar.isDateInToday(cellDate!)
                let isPast: Bool = cellDate!.timeIntervalSinceNow.isSignMinus
                
                cell.setCellInfo(day, month: month, past: isPast, today: isToday)
            }
            return cell
        }

        let cell = UICollectionViewCell()
        cell.backgroundColor = UIColor.redColor()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("Selected item")
        let cell = self.collectionView?.cellForItemAtIndexPath(indexPath) as? CalendarViewCell
        cell?.reloadDisplay()
        self.currentSelectedCell = cell
        self.delegate?.calendarSelectedDayFromFirst(indexPath.item)
    }
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        (self.collectionView?.cellForItemAtIndexPath(indexPath) as? CalendarViewCell)?.reloadDisplay()
    }
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        (self.collectionView?.cellForItemAtIndexPath(indexPath) as? CalendarViewCell)?.reloadDisplay()
    }
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        (self.collectionView?.cellForItemAtIndexPath(indexPath) as? CalendarViewCell)?.reloadDisplay()
    }
    
    func selectAndDisplayItemInCollectionViewAtIndexPath(indexPath: NSIndexPath?, animated: Bool, scrollPosition: UICollectionViewScrollPosition) {
        //Selecting new cell, unselects currently selected cell but doesn't triggger UICollectionView delegate functions
        self.collectionView?.selectItemAtIndexPath(indexPath, animated: animated, scrollPosition: scrollPosition)
        self.currentSelectedCell?.reloadDisplay()
        if indexPath == nil {
            return
        }
        //Necessary to do the scrolling independantly because .None doesnt scroll in select but scrolls minimally in scroll function
        self.collectionView?.scrollToItemAtIndexPath(indexPath!, atScrollPosition: scrollPosition, animated: animated)
        let cell = self.collectionView?.cellForItemAtIndexPath(indexPath!) as? CalendarViewCell
        cell?.reloadDisplay()
        self.currentSelectedCell = cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
