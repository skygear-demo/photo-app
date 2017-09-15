//
//  FirstViewController.swift
//  photo-app
//
//  Created by David Ng on 14/9/2017.
//  Copyright © 2017 Skygear. All rights reserved.
//

import UIKit
import SKYKit

class FirstViewController: UIViewController {
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    @IBOutlet var loggedInLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.refreshView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func signupDidPress(_ sender: AnyObject) {
        signup()
    }
    
    @IBAction func loginDidPress(_ sender: AnyObject) {
        login()
    }
    
    @IBAction func logoutDidPress(_ sender: AnyObject) {
        logout()
    }
    
    func refreshView() {
        if (SKYContainer.default().auth.currentUser != nil) {
            loggedInLabel.text = "Logged in as \(SKYContainer.default().auth.currentUser?.object(forKey: "username") as! String)"
        } else {
             loggedInLabel.text = "Please login to proceed."
        }
    }
    
    func signup() {
        let name: String = self.usernameField.text!
        let password: String = self.passwordField.text!
        
        SKYContainer.default().auth.signup(withUsername: name, password: password) { (user, error) in
            if (error != nil) {
                NSLog(error.debugDescription)
                self.showAlert(title:"Cannot signup", message:"Please try again", actionText:"OK")
                return
            }
            print("Signed up as: \(user)")
            self.refreshView()
        }
    }
    
    func login() {
        let name: String = self.usernameField.text!
        let password: String = self.passwordField.text!
        
        SKYContainer.default().auth.login(withUsername: name, password: password) { (user, error) in
            if (error != nil) {
                NSLog(error.debugDescription)
                self.showAlert(title:"Cannot login", message:"Please try again", actionText:"OK")
                return
            }
            print("Logged in as: \(user)")
            self.refreshView()
        }
    }
    
    func logout() {
        SKYContainer.default().auth.logout { (user, error) in
            if (error != nil) {
                NSLog(error.debugDescription)
                return
            }
            print("Logged out")
            self.refreshView()
        }
    }
    
    
    func showAlert(title: String, message: String, actionText: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: actionText, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

