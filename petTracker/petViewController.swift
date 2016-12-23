//
//  petViewController.swift
//  petTracker
//
//  Created by Miriam Flores on 11/23/16.
//  Copyright © 2016 CSUMB. All rights reserved.
//

import UIKit

class petViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var username: String = ""
    var userId: String = ""
    var pets:NSArray = []
    
    //Reference to tableView
   
  
    
    @IBOutlet var petsTable: UITableView!
    
    var items=["Dog","Cat","Cow"]
    var name=["lola","Philly","Carlos"]
    
    override func viewDidLoad() {
        print("user ID: \(userId)")
        print("username: \(username)")
        
        self.petsTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.petsTable.dataSource=self
        self.petsTable.delegate=self
        //getPets()
        print("pets:\(self.pets)")
        getPets()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Returns the number of rows in the needed for the table 
    //in other words will return the number of pets they have
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    //creates a cell for each item in the array
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        
        cell.textLabel?.text = name[indexPath.row]
        cell.detailTextLabel?.text = items[indexPath.row]
        
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
            
            let firstActivityItem=self.name[indexPath.row]
            let activityViewController = UIActivityViewController(activityItems: [firstActivityItem], applicationActivities: nil)
            self.presentViewController(activityViewController, animated: true, completion: nil)
        }
        //Delete Button
        let deleteAction = UITableViewRowAction(style: .Normal, title: "Delete"){ (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            
            let firstActivityItem=self.name[indexPath.row]
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
                let mutableArray = NSMutableArray()
                
                for arr in json{
                    mutableArray.addObject(arr)
                }
                var array = NSArray()
                array = mutableArray.mutableCopy() as! NSArray
                
                print(json)
                print(array)
            } catch let error as NSError {
                print(error.debugDescription)
            }
        }
       task.resume()
      
   }
}

