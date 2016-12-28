//
//  addPetViewController.swift
//  petTracker
//
//  Created by Miriam Flores on 11/21/16.
//  Copyright © 2016 CSUMB. All rights reserved.
//

import UIKit

class addPetViewController: UIViewController {

    @IBOutlet weak var petName: UITextField!
    @IBOutlet weak var DOB: UIDatePicker!
    @IBOutlet weak var type: UITextField!
    
    @IBAction func addPet(sender: UIButton) {
        
        //get textbox values
        let petNameValue = petName.text
        let petDOBDate = DOB.date
        let petTypeValue = type.text
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = NSTimeZone(name: "Pacific Daylight Time")
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let petDOBValue = dateFormatter.stringFromDate(petDOBDate)
        
        if(petNameValue!.isEmpty ?? true || petTypeValue!.isEmpty ?? true){
            let alert = UIAlertController(title: "Empty Fields", message: "Pet name and type must be entered", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else{
            let defaults = NSUserDefaults.standardUserDefaults()
            let userIdValue = defaults.stringForKey(defaultsKeys.userID)
            
            //connect to server
            let petUrl = NSURL(string: "https://pettrackerapp.herokuapp.com/pet/create")
            let request = NSMutableURLRequest(URL:petUrl!)
            request.HTTPMethod = "POST"
            let postString = "petName=" + petNameValue! +
                             "&type=" + petTypeValue! +
                             "&user_id=" + userIdValue! +
                             "&dob=" + petDOBValue
            //start session/request
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
                data, response, error in
                
                if error != nil {
                    print("error\(error)")
                    return
                }
                print("******Response =\(response)")
            }
            
            task.resume()
            print(postString)
            let alert = UIAlertController(title: "Pet Added", message: "\(petNameValue!) was added", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

