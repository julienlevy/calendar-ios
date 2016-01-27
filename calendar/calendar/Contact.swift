//
//  Contact.swift
//  calendar
//
//  Created by Julien Levy on 24/01/2016.
//  Copyright © 2016 Julien. All rights reserved.
//

import Foundation

class Contact {
    var firstName: String
    var lastName: String
    var email: String
    var imageName: String
    
    var company: String? //Should be a company object
    
    init(contactFName: String, contactLName: String, contactEmail: String = "example@example.com", contactImageName: String) {
        self.firstName = contactFName
        self.lastName = contactLName
        self.email = contactEmail
        self.imageName = contactImageName
    }
}