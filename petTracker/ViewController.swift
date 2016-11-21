//
//  ViewController.swift
//  petTracker
//
//  Created by Miriam Flores on 11/21/16.
//  Copyright © 2016 CSUMB. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var petName: UITextField!
    @IBOutlet weak var petDescription: UITextField!
    @IBOutlet weak var DOB: UITextField!
    
    @IBAction func addPet(sender: UIButton) {
        
        //get textbox values
        let petNameValue = petName.text
        let petDescriptionValue = petDescription.text
        let petDOBValue = DOB.text
        
        //connect to server
        let petUrl = NSURL(string: "https://pettrackerapp.herokuapp.com/pet/create")
        let request = NSMutableURLRequest(URL:petUrl!)
        request.HTTPMethod = "POST"
        let postString = "petName=" + petNameValue! +
                         "&type=" + petDescriptionValue! +
                         "&dob=" + petDOBValue!
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

