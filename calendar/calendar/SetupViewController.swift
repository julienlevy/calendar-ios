//
//  SetupViewController.swift
//  calendar
//
//  Created by Julien Levy on 30/01/2016.
//  Copyright © 2016 Julien. All rights reserved.
//

import UIKit

let kNotification: String = "kNotification"
let kLocation: String = "kLocation"

class SetupViewController: UIViewController, UITableViewDataSource {
    @IBOutlet var loaderContainerView: UIView!
    @IBOutlet var loaderView: UIView!
    @IBOutlet var loaderWidthConstraint: NSLayoutConstraint!
    @IBOutlet var loadingConfirmation: UIImageView!
    
    @IBOutlet var authorizationsTableView: UITableView!
    @IBOutlet var doneButton: UIButton!

    let authorizations = [kNotification, kLocation]
    let cellDetails = [
        kNotification: [
            "title": "Notification",
            "detail": "We may set up alerts for events and invites.",
            "imageName": "notification",
            "target": "enableNotification:"
        ],
        kLocation: [
            "title": "Location",
            "detail": "Required to give you weather forecasts and commute prevision.",
            "imageName": "locationauth",
            "target": "enableLocation:"
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loaderContainerView.layer.cornerRadius = self.loaderContainerView.frame.height / 2.0
        self.loaderContainerView.clipsToBounds = true

        self.authorizationsTableView.estimatedRowHeight = 70
        self.authorizationsTableView.registerClass(AuthorizationCell.self, forCellReuseIdentifier: "authorizationCell")
        self.authorizationsTableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        self.loaderWidthConstraint.constant = 0
        self.loaderContainerView.layoutIfNeeded()
    }
    
    override func viewDidAppear(animated: Bool) {        
        self.loaderWidthConstraint.constant = self.loaderContainerView.bounds.width
        UIView.animateWithDuration(4, animations: {
                self.loaderContainerView.layoutIfNeeded()
            }, completion: { (value: Bool) in
                self.doneButton.enabled = true
                
                UIView.animateWithDuration(0.2, animations: {
                    self.doneButton.alpha = 1
                    self.loadingConfirmation.alpha = 1
                })
            })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.authorizations.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("authorizationCell") as? AuthorizationCell {
            let key = authorizations[indexPath.row]

            if cellDetails[key] != nil {
                cell.titleLabel.text = cellDetails[key]!["title"]
                cell.detailLabel.text = cellDetails[key]!["detail"]!
                cell.iconView.image = UIImage(named: cellDetails[key]!["imageName"]!)
                cell.enableButton.addTarget(self, action: Selector(cellDetails[key]!["target"]!), forControlEvents: .TouchUpInside)
                cell.layoutIfNeeded()
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func enableLocation(sender: UIButton) {
        if let cell = sender.superview as? AuthorizationCell {
            UIView.animateWithDuration(0.2, animations: {
                sender.alpha = 0
                }, completion: { (value: Bool) in
                    UIView.animateWithDuration(0.3, animations: {
                        cell.validateIcon.alpha = 1
                    })
                })
        }
    }
    func enableNotification(sender: UIButton) {
        if let cell = sender.superview as? AuthorizationCell {
            UIView.animateWithDuration(0.2, animations: {
                sender.alpha = 0
                }, completion: { (value: Bool) in
                    UIView.animateWithDuration(0.3, animations: {
                        cell.validateIcon.alpha = 1
                    })
            })
        }
    }

    @IBAction func endOnboarding(sender: UIButton) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
