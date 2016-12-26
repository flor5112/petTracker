//
//  petViewController.swift
//  petTracker
//
//  Created by Miriam Flores on 11/23/16.
//  Copyright © 2016 CSUMB. All rights reserved.
//

import UIKit

struct defaultsKeys {
    static let userID = "userID"
}

class Pet {
    var petId = ""
    var petName = ""
    var type = ""
}

class petViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    var username: String = ""
    var userId: String = ""
    var pets = [Pet]()
    
    //Reference to tableView
    
    @IBOutlet var petsTable: UITableView!
    
    override func viewDidLoad() {
        print("user ID: \(userId)")
        print("username: \(username)")
        
        super.viewDidLoad()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(userId, forKey: defaultsKeys.userID)
        defaults.synchronize()
        
        self.petsTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.petsTable.dataSource=self
        self.petsTable.delegate=self
        
        getPets()
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(petViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        petsTable.addSubview(refreshControl) // not required when using UITableViewController
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        print("Reloading")
        self.petsTable.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Returns the number of rows in the needed for the table 
    //in other words will return the number of pets they have
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pets.count
    }
    //creates a cell for each item in the array
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        
        let pet = pets[indexPath.row]
        
        cell.textLabel?.text = pet.petName
        cell.detailTextLabel?.text = pet.type
        
        return cell
    }

    //something happens when you click on an specific cell
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You tapped on cell #\(indexPath.row)")
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
      
        // Edit Button
        let editAction = UITableViewRowAction(style: .Normal, title: "Edit"){ (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            
            let firstActivityItem=self.pets[indexPath.row]
            let activityViewController = UIActivityViewController(activityItems: [firstActivityItem], applicationActivities: nil)
            self.presentViewController(activityViewController, animated: true, completion: nil)
        }
        //Delete Button
        let deleteAction = UITableViewRowAction(style: .Normal, title: "Delete"){ (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            
            let firstActivityItem=self.pets[indexPath.row]
            let activityViewController = UIActivityViewController(activityItems: [firstActivityItem], applicationActivities: nil)
            self.presentViewController(activityViewController, animated: true, completion: nil)
        }
      
        editAction.backgroundColor=UIColor.blueColor()
        deleteAction.backgroundColor=UIColor.redColor()
        
        return [deleteAction,editAction]
    }
    
    func getPets(){
        
        let petUrl = NSURL(string: "https://pettrackerapp.herokuapp.com/pet/getPetsForUser")
        let request = NSMutableURLRequest(URL:petUrl!)
        request.HTTPMethod = "POST"
        let postString = "user_id=" + userId
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            (data, response, error) in
            do {
                guard let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSArray else {
                    return
                }
                for arr in json{
                    let pet = Pet()
                    pet.petId = arr["_id"] as! String
                    pet.petName = arr["petName"] as! String
                    pet.type = arr["type"] as! String
                    self.pets.append(pet)
                }
                dispatch_async(dispatch_get_main_queue()) {
                    self.petsTable.reloadData()
                }
                print(json)
            } catch let error as NSError {
                print(error.debugDescription)
            }
        }
       task.resume()
   }
    
    @IBAction func logout(sender: UIBarButtonItem) {
        print("Logging Out")
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue("", forKey: defaultsKeys.userID)
        defaults.synchronize()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
            self.presentViewController(viewController, animated: true, completion: nil)
        })
    }
    
    var refreshControl: UIRefreshControl!
    
    func refresh(sender: AnyObject) {
        if pets.count != 0{
            pets.removeAll()
        }
        getPets()
        refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refresh("")
    }
}

