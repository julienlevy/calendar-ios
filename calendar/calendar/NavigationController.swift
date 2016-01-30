//
//  NavigationController.swift
//  calendar
//
//  Created by Julien Levy on 30/01/2016.
//  Copyright © 2016 Julien. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    var invitesNavigationController: UINavigationController?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let navBar = self.navigationBar as? NavigationBar {
            navBar.iconButton.addTarget(self, action: Selector("openInvites"), forControlEvents: .TouchUpInside)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func openInvites() {        
        let storyboard =  UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        if let connectController = storyboard.instantiateViewControllerWithIdentifier("ConnectViewController") as? ConnectViewController {
            
            self.invitesNavigationController = UINavigationController(rootViewController: connectController)
            
            self.invitesNavigationController?.setNavigationBarHidden(true, animated: false)
            
            self.presentViewController(self.invitesNavigationController!, animated: true, completion: nil)
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
