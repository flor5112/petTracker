//
//  addTaskViewController.swift
//  petTracker
//
//  Created by Laura Chavez on 12/19/16.
//  Copyright © 2016 CSUMB. All rights reserved.
//

import UIKit

class addTaskViewController: UIViewController {
    
    @IBOutlet weak var taskTitle: UITextField!
    @IBOutlet weak var taskDescription: UITextField!
    @IBOutlet weak var reminderTime: UIDatePicker!
    
    
    @IBAction func addTask(sender: UIButton) {
        //get textbox values
        let titleValue = taskTitle.text
        let descriptionValue = taskDescription.text
        let reminderTimeDate = reminderTime.date
        let defaults = NSUserDefaults.standardUserDefaults()
        let petId = defaults.stringForKey(defaultsKeys.petID)
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = NSTimeZone(name: "Pacific Daylight Time")
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let reminderTimeValue = dateFormatter.stringFromDate(reminderTimeDate)
        
        //connect to server
        let petUrl = NSURL(string: "https://pettrackerapp.herokuapp.com/task/create")
        let request = NSMutableURLRequest(URL:petUrl!)
        request.HTTPMethod = "POST"
        let postString = "taskTitle=" + titleValue! +
            "&pet_id=" + petId! +
            "&description=" + descriptionValue! +
            "&reminderTime=" + reminderTimeValue
        
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
