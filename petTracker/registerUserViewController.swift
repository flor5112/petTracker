//
//  registerUserViewController.swift
//  petTracker
//
//  Created by Miriam Flores on 11/23/16.
//  Copyright © 2016 CSUMB. All rights reserved.
//

import UIKit

class registerUserViewController: UIViewController {
    
    //text fields
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var confirmEmail: UITextField!
    @IBOutlet weak var passErrorMessage: UILabel!
    @IBOutlet weak var emailErrorMessage: UILabel!
    var userId: String = ""
    
    
    @IBAction func signUp(segue: UIStoryboardSegue) {
        var usernameValue = ""
        var emailValue = ""
        
        print("starting Sign up")
        //checks that for empty fields
        if( password.text?.isEmpty ?? true || username.text?.isEmpty ?? true ||
            confirmPassword.text?.isEmpty ?? true || email.text?.isEmpty ?? true ||
            confirmEmail.text?.isEmpty ?? true )
        {
            print("EmptyFields")
            let alert = UIAlertController(title: "Empty Fields", message: "All fields must be fill out", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        else{
            //validate for password and confirm password match
            if( password.text != confirmPassword.text ){
                print("passwords don't match")
                password.text = ""
                confirmPassword.text = ""
                passErrorMessage.hidden = false
            }
            else{
                passErrorMessage.hidden = true
            }
            if(email.text != confirmEmail.text){
                print("emails don't match")
                email.text = ""
                confirmEmail.text = ""
                emailErrorMessage.hidden = false
            }
            else{
                emailErrorMessage.hidden = true
            }
            if(self.passErrorMessage.hidden == false || self.emailErrorMessage.hidden == false ){
                return
            }
            print("connecting to backend")
            //connect backend to register user
            let petUrl = NSURL(string: "https://pettrackerapp.herokuapp.com/user/register")
            let request = NSMutableURLRequest(URL:petUrl!)
            request.HTTPMethod = "POST"
            let postString = "username=" + username.text! +
                         "&password=" + password.text! +
                         "&email=" + email.text!
            //start session/request
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
                (data, response, error) in
                do {
                    guard let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary else {
                        return
                    }
                    emailValue = json["email"]! as! String
                    usernameValue = json["username"]! as! String
                
                    if let id = json["userId"] as? String {
                        self.userId = id
                    }
                    print(json)
                    print("\(emailValue), \(usernameValue), \(self.userId)")
                
                    if(emailValue == "false" && usernameValue == "false"){
                        NSOperationQueue.mainQueue().addOperationWithBlock {
                            let errorAlert = UIAlertController(title: "Invalid Username and Email", message: "An account with \(self.username.text!) and \(self.email.text!) alredy exists", preferredStyle: UIAlertControllerStyle.Alert)
                            errorAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                            self.presentViewController(errorAlert, animated: true, completion: nil)
                        }
                    }
                    if(emailValue == "false"){
                        NSOperationQueue.mainQueue().addOperationWithBlock {
                        let errorAlert = UIAlertController(title: "Invalid Email", message: "An account with email \(self.email.text) alredy exists", preferredStyle: UIAlertControllerStyle.Alert)
                        errorAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(errorAlert, animated: true, completion: nil)
                        }
                    }
                    if(usernameValue == "false"){
                        NSOperationQueue.mainQueue().addOperationWithBlock {
                            let errorAlert = UIAlertController(title: "Invalid Username", message: "An account with email \(self.username.text) alredy exists", preferredStyle: UIAlertControllerStyle.Alert)
                            errorAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                            self.presentViewController(errorAlert, animated: true, completion: nil)
                        }
                    }
                    
                        dispatch_async(dispatch_get_main_queue()) {
                            NSOperationQueue.mainQueue().addOperationWithBlock {
                                self.performSegueWithIdentifier("taskViewFromRegister", sender: self)
                            }
                        }
                
            } catch let error as NSError {
                print(error.debugDescription)
                }
            }
            task.resume()
            print("Registered User")
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("preparing register Segue")
        
        if(segue.identifier == "taskViewFromRegister"){
            if let destination = segue.destinationViewController as? taskViewController {
                destination.email = self.email.text!
                destination.username = self.username.text!
                print("destination userID \(userId)")
                destination.userId = self.userId
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.passErrorMessage.hidden = true
        self.emailErrorMessage.hidden = true
    }
}

