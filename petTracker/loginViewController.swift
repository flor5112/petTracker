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
    
  
    @IBAction func registerUser(segue: UIStoryboardSegue) {
        
    }

    @IBAction func login(segue: UIStoryboardSegue) {
        
        var  isValidLogin: String = " "
        
        if(username.text?.isEmpty ?? true || password.text?.isEmpty ?? true)
        {
            let alert = UIAlertController(title: "Empty Fields", message: "username and password must be entered", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {
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
                    isValidLogin = json["result"]! as! String
                    
                    } catch let error as NSError {
                    print(error.debugDescription)
                }
                
                if(isValidLogin == "true"){
                  print(isValidLogin)
                    self.continueToTaskView(isValidLogin)
                }
                else
                {
                 print(isValidLogin)
                    /*  let invalidCredetialAlert = UIAlertController(title: "Invalid Credentials", message: "invalid username or password", preferredStyle: UIAlertControllerStyle.Alert)
                    invalidCredetialAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(invalidCredetialAlert, animated: true, completion: nil)*/
                }
            }
            task.resume()
           
            
        }
    }
    
    func continueToTaskView(success: String)
    {
        if (success == "true") {
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.performSegueWithIdentifier("taskView", sender: self)
            }
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
