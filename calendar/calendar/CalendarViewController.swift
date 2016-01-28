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
    func calendarWillBeginDragging()
}

class CalendarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var delegate: CalendarDelegate?
    
    var collectionView: UICollectionView?
    var itemSide: CGFloat = 0
    var missingPixelsWithDivision: Int = 0
    var currentSelectedCell: CalendarViewCell?
    
    var eventsByDays: [[Event]?] = [[Event]?]()
    
    var firstDate: NSDate?
    var lastDate: NSDate?
    var calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    let shortMonthFormatter: NSDateFormatter = NSDateFormatter()
    let longMonthFormatter: NSDateFormatter = NSDateFormatter()
    
    var overlayView: UIView = UIView()
    var overlayHeightConstraint: NSLayoutConstraint = NSLayoutConstraint()
    var alreadyAddedMonths: [String] = [String]()
    
    var dayHeader: UIView = UIView()
    
    func initData(calendarFirstDate: NSDate, calendarLastDate: NSDate, savedEventsByDays: [[Event]?]) {
        self.firstDate = calendarFirstDate
        self.lastDate = calendarLastDate
        self.eventsByDays = savedEventsByDays
        
        self.collectionView?.reloadData()
    }
    
    // MARK: View controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.sunriseDefaultGrayBackgrund()
        
        self.shortMonthFormatter.dateFormat = "MMM"
        self.longMonthFormatter.dateFormat = "MMMM"
        
        let screen = UIScreen.mainScreen().bounds.width
        self.itemSide = CGFloat(Int(screen / 7.0))
        self.missingPixelsWithDivision = Int(screen - CGFloat(Int(screen/7.0) * 7))
        
        let collectionViewLayout: CalendarViewFlowLayout = CalendarViewFlowLayout()
        collectionViewLayout.scrollDirection = UICollectionViewScrollDirection.Vertical
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.minimumLineSpacing = 0.5
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: collectionViewLayout)
        self.collectionView?.backgroundColor = UIColor.clearColor()
        self.collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.collectionView?.registerClass(CalendarViewCell.self, forCellWithReuseIdentifier: calendarCellIdentifier)
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.collectionView?.allowsSelection = true
        
        self.dayHeader.backgroundColor = UIColor.sunriseDefaultGrayBackgrund()
        self.overlayView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
        
        self.overlayView.alpha = 0
        
        self.view.addSubview(self.dayHeader)
        self.view.addSubview(self.collectionView!)
        self.collectionView?.addSubview(self.overlayView)
        
        self.setCollectionViewConstraints()
        self.setDayHeaderConstraints()
        self.setOverlayConstraints()
        
        self.setUpDaysOfHeader()
    }
    override func viewDidAppear(animated: Bool) {
        if firstDate == nil {
            return
        }
        let index: Int = self.calendar.components(NSCalendarUnit.Day, fromDate: self.firstDate!, toDate: NSDate(), options: NSCalendarOptions.MatchFirst).day
        self.selectAndDisplayItemInCollectionViewAtIndexPath(NSIndexPath(forItem: index, inSection: 0), animated: false, scrollPosition: UICollectionViewScrollPosition.Top)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Subviews setups
    func setCollectionViewConstraints() {
        self.collectionView?.translatesAutoresizingMaskIntoConstraints = false
        let top: NSLayoutConstraint = NSLayoutConstraint(item: self.collectionView!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.dayHeader, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        let left: NSLayoutConstraint = NSLayoutConstraint(item: self.collectionView!, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let right: NSLayoutConstraint = NSLayoutConstraint(item: self.collectionView!, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        let bottom: NSLayoutConstraint = NSLayoutConstraint(item: self.collectionView!, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        
        self.view.addConstraints([top, left, right, bottom])
    }
    func setDayHeaderConstraints() {
        self.dayHeader.translatesAutoresizingMaskIntoConstraints = false
        let top: NSLayoutConstraint = NSLayoutConstraint(item: self.dayHeader, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        let left: NSLayoutConstraint = NSLayoutConstraint(item: self.dayHeader, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let right: NSLayoutConstraint = NSLayoutConstraint(item: self.dayHeader, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        let height: NSLayoutConstraint = NSLayoutConstraint(item: self.dayHeader, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: dayHeaderViewHeight)
        
        self.view.addConstraints([top, left, right, height])
    }
    func setOverlayConstraints() {
        self.overlayView.translatesAutoresizingMaskIntoConstraints = false
        let top: NSLayoutConstraint = NSLayoutConstraint(item: self.overlayView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.overlayView.superview, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        let left: NSLayoutConstraint = NSLayoutConstraint(item: self.overlayView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.overlayView.superview, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let right: NSLayoutConstraint = NSLayoutConstraint(item: self.overlayView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.overlayView.superview, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        overlayHeightConstraint = NSLayoutConstraint(item: self.overlayView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 0)
        
        self.collectionView!.addConstraints([top, left, right, overlayHeightConstraint])
    }
    func setUpDaysOfHeader() {
        var symbols = self.calendar.veryShortWeekdaySymbols
        //Starting week on monday instead of default sunday
        let sunday: String = symbols.removeFirst()
        symbols.append(sunday)
        for i in 0...(symbols.count-1) {
            let label = UILabel(frame: CGRectMake(CGFloat(i) * itemSide, 0, CGFloat(itemSide), 20))
            label.text = symbols[i]
            label.textAlignment = .Center
            //Weekend is gray
            label.textColor = (5 - i > 0 ? UIColor.blackColor() : UIColor.sunriseGrayTextColor())
            label.font = UIFont.systemFontOfSize(12.0)
            self.dayHeader.addSubview(label)
        }
    }
    func addMonthLabel(month: String, onRowOfCell: UICollectionViewCell) {
        if self.alreadyAddedMonths.contains(month) {
            return
        }
        let label: UILabel = UILabel()
        label.text = month
        label.font = UIFont.systemFontOfSize(20)
        label.textAlignment = .Center
        label.frame = CGRectMake(0, onRowOfCell.frame.origin.y, self.view.bounds.width, onRowOfCell.frame.height)
        self.overlayView.addSubview(label)
    }
    func hideOverlay(hidden: Bool) {
        UIView.animateWithDuration(0.3, animations: {
            self.overlayView.alpha = (hidden ? 0 : 1)
        })
    }
    
    // MARK: Collection view layout delegate
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if self.collectionView == nil {
            return CGSizeZero
        }
        let indexInRow = indexPath.item % 7
        
        //Only integer width and adds 1 pixel to first in row according to missing pixels by division so that the sum reaches the end of the line perfectly
        return CGSize(width: self.itemSide + (self.missingPixelsWithDivision - indexInRow > 0 ? 1 : 0), height: self.itemSide)
    }
    
    // MARK: Collection view datasource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.firstDate == nil || self.lastDate == nil {
            return 0
        }
        return self.calendar.components(NSCalendarUnit.Day, fromDate: self.firstDate!, toDate: self.lastDate!, options: NSCalendarOptions.MatchFirst).day
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell: CalendarViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(calendarCellIdentifier, forIndexPath: indexPath) as? CalendarViewCell {
            if self.firstDate != nil {
                let dateComponents = NSDateComponents()
                dateComponents.day = indexPath.item
                let cellDate = self.calendar.dateByAddingComponents(dateComponents, toDate: self.firstDate!, options: NSCalendarOptions.MatchFirst)
                let day: Int = self.calendar.component(NSCalendarUnit.Day, fromDate: cellDate!)
                var nbEvents: Int? = self.eventsByDays[indexPath.item]?.count
                if nbEvents == nil {
                    nbEvents = 0
                }
                
                cell.setCellInfo(day,
                    month: self.shortMonthFormatter.stringFromDate(cellDate!),
                    past: cellDate!.timeIntervalSinceNow.isSignMinus,
                    today: self.calendar.isDateInToday(cellDate!),
                    events: nbEvents!)
                
                if day == 15 {
                    self.addMonthLabel(self.longMonthFormatter.stringFromDate(cellDate!), onRowOfCell: cell)
                }
            }
            return cell
        }

        let cell = UICollectionViewCell()
        cell.backgroundColor = UIColor.redColor()
        return cell
    }
    
    // MARK: Collection view delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
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
    
    // MARK: scroll view delegate
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        overlayHeightConstraint.constant = (self.collectionView?.contentSize.height)!
        self.collectionView?.layoutIfNeeded()
        self.hideOverlay(false)
        
        self.delegate?.calendarWillBeginDragging()
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.hideOverlay(true)
        }
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.hideOverlay(true)
    }
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // TODO: to implement to always scroll to full cell?
    }
    
    // MARK: collection view utils
    func selectAndDisplayItemInCollectionViewAtIndexPath(indexPath: NSIndexPath?, animated: Bool, scrollPosition: UICollectionViewScrollPosition) {
        //Selecting new cell, unselects currently selected cell but doesn't triggger UICollectionView delegate functions
        self.collectionView?.selectItemAtIndexPath(indexPath, animated: animated, scrollPosition: scrollPosition)
        self.currentSelectedCell?.reloadDisplay()
        if indexPath == nil {
            print("indexPath is nil")
            return
        }
        //Necessary to do the scrolling independantly because .None doesnt scroll in select but scrolls minimally in scroll function
        self.collectionView?.scrollToItemAtIndexPath(indexPath!, atScrollPosition: scrollPosition, animated: animated)
        
        var cell: CalendarViewCell? = (self.collectionView?.cellForItemAtIndexPath(indexPath!)) as? CalendarViewCell
        
        //Following is necessary to ensure that the cell is not nil because cellForRow return nil if cell is not on display (for first selection for example)
        if cell ==  nil {
            self.collectionView?.layoutIfNeeded()
            self.collectionView?.selectItemAtIndexPath(indexPath, animated: animated, scrollPosition: scrollPosition)
            cell = (self.collectionView?.cellForItemAtIndexPath(indexPath!)) as? CalendarViewCell
        }
        if cell == nil {
            self.collectionView?.layoutIfNeeded()
            self.collectionView?.reloadData()
            self.collectionView?.selectItemAtIndexPath(indexPath, animated: animated, scrollPosition: scrollPosition)
            cell = (self.collectionView?.cellForItemAtIndexPath(indexPath!)) as? CalendarViewCell
        }
        
        self.currentSelectedCell = cell
    }
    
}
