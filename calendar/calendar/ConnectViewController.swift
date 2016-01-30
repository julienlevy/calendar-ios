//
//  ConnectViewController.swift
//  calendar
//
//  Created by Julien Levy on 30/01/2016.
//  Copyright © 2016 Julien. All rights reserved.
//

import UIKit

class ConnectViewController: UIViewController {
    @IBOutlet var facebookButton: UIButton!
    @IBOutlet var googleButton: UIButton!
    @IBOutlet var emailButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.facebookButton.layer.cornerRadius = 5.0
        self.googleButton.layer.cornerRadius = 5.0
        self.emailButton.layer.cornerRadius = 5.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
