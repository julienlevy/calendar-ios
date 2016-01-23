//
//  CalendarViewController.swift
//  calendar
//
//  Created by Julien Levy on 23/01/2016.
//  Copyright © 2016 Julien. All rights reserved.
//

import UIKit

let calendarCellIdentifier: String = "calendarCell"

class CalendarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var collectionView: UICollectionView?
    var collectionViewLayout: UICollectionViewFlowLayout?
    var itemSide: CGFloat = 0
    var minimumInteritemSpacing: CGFloat = 0
    
    var firstDate: NSDate?
    var lastDate: NSDate?
    var calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    let monthFormatter: NSDateFormatter = NSDateFormatter()
    
    var dayHeader: UIView = UIView()
    var headerColor: UIColor = UIColor.lightGrayColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.lightGrayColor()
        
        monthFormatter.dateFormat = "MMM"
        self.setDatesLimits()
        
        itemSide = UIScreen.mainScreen().bounds.width/CGFloat(7) - 1
        minimumInteritemSpacing = 1.0
        print("Size should be " + String(itemSide))
        collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout?.scrollDirection = UICollectionViewScrollDirection.Vertical
        collectionViewLayout?.minimumInteritemSpacing = minimumInteritemSpacing
        collectionViewLayout?.minimumLineSpacing = minimumInteritemSpacing
        collectionViewLayout?.itemSize = CGSize(width: itemSide, height: itemSide)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: collectionViewLayout!)
        collectionView?.backgroundColor = UIColor.clearColor()
        collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView?.registerClass(CalendarViewCell.self, forCellWithReuseIdentifier: calendarCellIdentifier)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        dayHeader.backgroundColor = headerColor
        self.view.addSubview(dayHeader)
        self.view.addSubview(collectionView!)
        setCollectionViewConstraints()
        setDayViewConstraints()
        
        setUpDaysOfHeader()
    }
    override func viewDidAppear(animated: Bool) {
        let index: Int = calendar.components(NSCalendarUnit.Day, fromDate: firstDate!, toDate: NSDate(), options: NSCalendarOptions.MatchFirst).day
        collectionView?.scrollToItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.Top, animated: false)
    }
    func setCollectionViewConstraints() {
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        let top: NSLayoutConstraint = NSLayoutConstraint(item: collectionView!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: dayHeader, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        let left: NSLayoutConstraint = NSLayoutConstraint(item: collectionView!, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let right: NSLayoutConstraint = NSLayoutConstraint(item: collectionView!, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        let bottom: NSLayoutConstraint = NSLayoutConstraint(item: collectionView!, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        
        self.view.addConstraints([top, left, right, bottom])
    }
    func setDayViewConstraints() {
        dayHeader.translatesAutoresizingMaskIntoConstraints = false
        let top: NSLayoutConstraint = NSLayoutConstraint(item: dayHeader, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: UIApplication.sharedApplication().statusBarFrame.height)
        let left: NSLayoutConstraint = NSLayoutConstraint(item: dayHeader, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let right: NSLayoutConstraint = NSLayoutConstraint(item: dayHeader, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        let height: NSLayoutConstraint = NSLayoutConstraint(item: dayHeader, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 20)
        
        self.view.addConstraints([top, left, right, height])
    }
    func setUpDaysOfHeader() {
        //Remove 1 to count from 0
        var firstWeekDay = calendar.component(.Weekday, fromDate: firstDate!) - 1
        let symbols = calendar.veryShortWeekdaySymbols
        for i in 0...(symbols.count-1) {
            if firstWeekDay + i >= symbols.count {
                firstWeekDay -= symbols.count
            }
            let label = UILabel(frame: CGRectMake(CGFloat(i) * itemSide + CGFloat(i-1) * minimumInteritemSpacing, 0, itemSide, 20))
            label.text = symbols[firstWeekDay + i]
            label.textAlignment = .Center
            label.textColor = UIColor.blackColor()
            dayHeader.addSubview(label)
        }
    }
    
    func setDatesLimits() {
        //Going 3 months before now
        let monthOffset = NSDateComponents()
        monthOffset.month = -3
        let before = calendar.dateByAddingComponents(monthOffset, toDate: NSDate(), options: NSCalendarOptions.MatchFirst)
        //Looking for first sunday after this date
        let sundayComp = NSDateComponents()
        sundayComp.weekday = 1
        firstDate = calendar.nextDateAfterDate(before!, matchingComponents: sundayComp, options: NSCalendarOptions.MatchPreviousTimePreservingSmallerUnits)
        monthOffset.month = 3
        lastDate = calendar.dateByAddingComponents(monthOffset, toDate: NSDate(), options: NSCalendarOptions.MatchFirst)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if firstDate == nil || lastDate == nil {
            return 0
        }
        //nil doesnt work for the NSCalendarOptions
        return calendar.components(NSCalendarUnit.Day, fromDate: firstDate!, toDate: lastDate!, options: NSCalendarOptions.MatchFirst).day
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell: CalendarViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(calendarCellIdentifier, forIndexPath: indexPath) as? CalendarViewCell {
            if firstDate != nil {
                let dateComponents = NSDateComponents()
                dateComponents.day = indexPath.item
                let cellDate = calendar.dateByAddingComponents(dateComponents, toDate: firstDate!, options: NSCalendarOptions.MatchFirst)
                let day: Int = calendar.component(NSCalendarUnit.Day, fromDate: cellDate!)
                let month: String = monthFormatter.stringFromDate(cellDate!)
                let isToday: Bool = calendar.isDateInToday(cellDate!)
                let isPast: Bool = cellDate!.timeIntervalSinceNow.isSignMinus
                
                cell.setCellInfo(day, month: month, past: isPast, today: isToday)
            }
            return cell
        }

        let cell = UICollectionViewCell()
        cell.backgroundColor = UIColor.redColor()
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
