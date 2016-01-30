//
//  EmailConnectViewController.swift
//  calendar
//
//  Created by Julien Levy on 30/01/2016.
//  Copyright © 2016 Julien. All rights reserved.
//

import UIKit

class EmailConnectViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var hiddenTextField: UITextField!
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmationTextField: UITextField!
    @IBOutlet var confirmationUnderline: UIView!

    
    @IBOutlet var pageTitleLabel: UILabel!
    @IBOutlet var confirmButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet var confirmButton: UIButton!
    
    let registeredEmails: [String] = ["registered@email.com", "pival@microsoft.com"]
    var emailIsRegistered: Bool = false
    
    var defaults: [String: String] = ["email": "Email", "password": "Password", "confirmation": "Password Confirmation"]
    
    let defaultTextColor: UIColor = UIColor.sunriseGrayTextColor()
    let modifiedTextColor: UIColor = UIColor.blackColor()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        
        self.hiddenTextField.becomeFirstResponder()
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmationTextField.delegate = self
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue {
            self.confirmButtonBottomConstraint.constant = keyboardFrame.height
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == self.emailTextField {
            self.passwordTextField.becomeFirstResponder()
            
            if self.registeredEmails.contains(textField.text!) {
                self.emailIsRegistered = true
                self.confirmationTextField.hidden = true
                self.confirmationUnderline.hidden = true
                self.pageTitleLabel.text = "Email - Login"
            }
            else {
                self.emailIsRegistered = false
                self.confirmationTextField.hidden = false
                self.confirmationUnderline.hidden = false
                self.pageTitleLabel.text = "Email - New account"
            }
        }
        else if textField == self.passwordTextField {
            if emailIsRegistered {
                self.performSegueWithIdentifier("emailToSetup", sender: self)
            }
            else {
                self.confirmationTextField.becomeFirstResponder()
            }
        } else if textField == self.confirmationTextField {
            self.performSegueWithIdentifier("emailToSetup", sender: self)
        }
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if self.defaults.values.contains(textField.text!) {
            textField.text = ""
        }
        textField.textColor = self.modifiedTextColor
        
        self.setSecureTextEntry(textField)
        
        if (textField == self.passwordTextField && self.emailIsRegistered) || textField == self.confirmationTextField {
            self.confirmButton.alpha = 1
        }
    }
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text == "" {
            textField.textColor = self.defaultTextColor
            textField.secureTextEntry = false
            
            self.setCorrespondingDefault(textField)
            
            self.confirmButton.alpha = 0.5
        }
    }
    func textFieldShouldClear(textField: UITextField) -> Bool {
        textField.textColor = self.defaultTextColor
        textField.secureTextEntry = false
        
        self.setCorrespondingDefault(textField)
        
        return true
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        print(textField.text)
        return true
    }
    
    func setCorrespondingDefault(textField: UITextField) {
        if textField == self.emailTextField {
            textField.text = self.defaults["email"]
        }
        else if textField == self.passwordTextField {
            textField.text = self.defaults["password"]
        }
        else if textField == self.confirmationTextField {
            textField.text = self.defaults["confirmation"]
        }
    }
    func setSecureTextEntry(textField: UITextField) {
        if textField == self.passwordTextField || textField == self.confirmationTextField{
            textField.secureTextEntry = true
        }
        else {
            textField.secureTextEntry = false
        }
    }
}
