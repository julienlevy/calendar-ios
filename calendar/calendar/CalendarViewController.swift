//
//  CalendarViewController.swift
//  calendar
//
//  Created by Julien Levy on 23/01/2016.
//  Copyright © 2016 Julien. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var collectionView: UICollectionView?
    var collectionViewLayout: UICollectionViewFlowLayout?
    var firstDate: NSDate?
    var lastDate: NSDate?
    var calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.lightGrayColor()
        
        let side: CGFloat = UIScreen.mainScreen().bounds.width/CGFloat(7) - 1
        print("Size should be " + String(side))
        collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout?.scrollDirection = UICollectionViewScrollDirection.Vertical
        collectionViewLayout?.minimumInteritemSpacing = 1.0
        collectionViewLayout?.minimumLineSpacing = 1.0
        collectionViewLayout?.itemSize = CGSize(width: side, height: side)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: collectionViewLayout!)
        collectionView?.backgroundColor = UIColor.clearColor()
        collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        self.view.addSubview(collectionView!)
        setCollectionViewConstraints()

        let offset = NSDateComponents()
        offset.month = -2
        firstDate = calendar.dateByAddingComponents(offset, toDate: NSDate(), options: NSCalendarOptions.MatchFirst)
        offset.month = 3
        lastDate = calendar.dateByAddingComponents(offset, toDate: NSDate(), options: NSCalendarOptions.MatchFirst)
        collectionView?.reloadData()
    }
    func setCollectionViewConstraints() {
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        let top: NSLayoutConstraint = NSLayoutConstraint(item: collectionView!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        let left: NSLayoutConstraint = NSLayoutConstraint(item: collectionView!, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let right: NSLayoutConstraint = NSLayoutConstraint(item: collectionView!, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        let bottom: NSLayoutConstraint = NSLayoutConstraint(item: collectionView!, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        
        self.view.addConstraints([top, left, right, bottom])
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
        if let cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) {
            cell.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.2)
            if firstDate != nil {
                let myComponents = NSDateComponents()
                myComponents.day = indexPath.item
                let cellDate = calendar.dateByAddingComponents(myComponents, toDate: firstDate!, options: NSCalendarOptions.MatchFirst)
                let day: Int = calendar.component(NSCalendarUnit.Day, fromDate: cellDate!)
                let month: Int = calendar.component(NSCalendarUnit.Month, fromDate: cellDate!)
                if cell.contentView.subviews.count == 0 {
                    let label = UILabel(frame: cell.bounds)
                    label.text = String(day) + "/" + String(month) // + "\n" + String(indexPath.section) + " " + String(indexPath.item)
                    label.numberOfLines = 0
                    label.textColor = UIColor.whiteColor()
                    cell.contentView.addSubview(label)
                }
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
