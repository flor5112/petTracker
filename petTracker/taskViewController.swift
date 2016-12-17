//
//  taskViewController.swift
//  petTracker
//
//  Created by Miriam Flores on 11/23/16.
//  Copyright © 2016 CSUMB. All rights reserved.
//

import UIKit

class taskViewController: UIViewController{
    
    var email: String = ""
    var username: String = ""
    var userId: String = ""
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        //welcomeLabel.text = "\(username)'s Pet List "
        print("Inside taskView \(email)")
        print("user ID: \(userId)")
        print("username: \(username)")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   

}
