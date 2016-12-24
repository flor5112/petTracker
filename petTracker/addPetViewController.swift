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
        
        //connect to server
        let petUrl = NSURL(string: "https://pettrackerapp.herokuapp.com/pet/create")
        let request = NSMutableURLRequest(URL:petUrl!)
        request.HTTPMethod = "POST"
        let postString = "petName=" + petNameValue! +
                         "&type=" + petTypeValue! +
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

