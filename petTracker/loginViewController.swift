//
//  loginViewController.swift
//  petTracker
//
//  Created by Miriam Flores on 11/23/16.
//  Copyright © 2016 CSUMB. All rights reserved.
//

import UIKit

class loginViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    var userId:String = ""
    @IBAction func registerUser(segue: UIStoryboardSegue) {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.performSegueWithIdentifier("registerUserView", sender: self)
        }
        
    }

    @IBAction func login(segue: UIStoryboardSegue) {
        var isValidLogin:String = ""
        
        if(username.text?.isEmpty ?? true || password.text?.isEmpty ?? true){
            let alert = UIAlertController(title: "Empty Fields", message: "username and password must be entered", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else{
            let activityView = self.startActivityIndicatorView()
            let petUrl = NSURL(string: "https://pettrackerapp.herokuapp.com/user/login")
            
            let request = NSMutableURLRequest(URL:petUrl!)
            
            request.HTTPMethod = "POST"
            
            let postString = "username=" + username.text! +
                             "&password=" + password.text!
            
            //start session/request
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
                (data, response, error) in
                do {
                     guard let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary else {
                        return
                    }
                        isValidLogin = json["result"] as! String
                        if(isValidLogin == "true"){
                            self.userId = json["user_id"] as! String
                        }
                    
                    } catch let error as NSError {
                    print(error.debugDescription)
                }
                self.stopActivityIndicatorView(activityView)
                if(isValidLogin == "true"){
                    print("isValidLogin \(isValidLogin)")
                    self.continueToTaskView(isValidLogin)
                }
                else{
                    print("isValidLogin \(isValidLogin)")
                    
                    NSOperationQueue.mainQueue().addOperationWithBlock {
                    let errorAlert = UIAlertController(title: "Invalid Credentials", message: "Incorrect username or password", preferredStyle:UIAlertControllerStyle.Alert)
                    errorAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(errorAlert, animated: true, completion: nil)
                    self.username.text = ""
                    self.password.text = ""
                    }
                    return
                }
            }
            task.resume()
        }
    }
    
    func continueToTaskView(success: String)
    {
        if (success == "true") {
            dispatch_async(dispatch_get_main_queue()) {
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.performSegueWithIdentifier("taskView", sender: self)
                }
            }
        }
    }
    
    func startActivityIndicatorView() -> UIActivityIndicatorView {
        let x = (self.view.frame.width / 2)
        let y = (self.view.frame.height / 2)
        
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityView.frame = CGRect(x: 200, y: 120, width: 200, height: 200)
        activityView.center = CGPoint(x: x, y: y)
        activityView.color = .blueColor()
        activityView.startAnimating()
        self.view.addSubview(activityView)
        
        return activityView
    }
    
    func stopActivityIndicatorView(activityView: UIActivityIndicatorView) {
        dispatch_async(dispatch_get_main_queue()) {
            activityView.removeFromSuperview()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "taskView"){
            print("preparing login Segue")
            
            let DestViewController = segue.destinationViewController as! UINavigationController
            let targetController = DestViewController.topViewController as! petViewController
            targetController.username = self.username.text!
            print("destination userID \(userId)")   
            targetController.userId = self.userId
        }
        
        if(segue.identifier == "registerUserView") {
            print("registerUserView segue")
        }
    }
    
     override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
