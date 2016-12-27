//
//  taskViewController.swift
//  petTracker
//
//  Created by Miriam Flores on 12/26/16.
//  Copyright © 2016 CSUMB. All rights reserved.
//

import UIKit

class Task {
    
    var taskTitle = ""
    var taskDescription = ""
}

class taskViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tasks = [Task]()
    
//    var tasksTitle = ["helo","things"]
//    
//    var descriptions = ["thing1", "thing2"]
    
    @IBOutlet weak var taskTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //preares TableView to display 
        self.taskTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.taskTable.dataSource=self
        self.taskTable.delegate=self
        
        getTasks()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    //creates a cell for each item in the array
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        
        let task = tasks[indexPath.row]
        
        cell.textLabel?.text = task.taskTitle
        cell.detailTextLabel?.text = task.taskDescription
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You tapped on cell #\(indexPath.row)")
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Task Description", message: tasks[indexPath.row].taskDescription, preferredStyle: .ActionSheet)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelAction)
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    
    //Two Edit and delete action buttons are added to each cell
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        
        // Edit Button
        let editAction = UITableViewRowAction(style: .Normal, title: "Edit"){ (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            
//            let firstActivityItem=self.tasks[indexPath.row]
//            let activityViewController = UIActivityViewController(activityItems: [firstActivityItem], applicationActivities: nil)
//            self.presentViewController(activityViewController, animated: true, completion: nil)
        }
        
        //Delete Button
        let deleteAction = UITableViewRowAction(style: .Normal, title: "Delete"){ (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            
            let firstActivityItem=self.tasks[indexPath.row]
            let activityViewController = UIActivityViewController(activityItems: [firstActivityItem], applicationActivities: nil)
            self.presentViewController(activityViewController, animated: true, completion: nil)
        }
        
        
        editAction.backgroundColor=UIColor.blueColor()
        deleteAction.backgroundColor=UIColor.redColor()
        
        return [deleteAction,editAction]
    }
    
    
    //function to retrivet the tasks for the pet selected
    func getTasks()
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        let petId = defaults.stringForKey(defaultsKeys.petID)
        
        let petUrl = NSURL(string: "https://pettrackerapp.herokuapp.com/task/getTasksForPet")
        let request = NSMutableURLRequest(URL:petUrl!)
        request.HTTPMethod = "POST"
        let postString = "pet_id=" + petId!
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
         print("petID:\(postString)")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            (data, response, error) in
            do {
                
                guard let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSArray else {
                    return
                }
               
                
                for arr in json{
                    let task = Task()
                    task.taskTitle = arr["taskTitle"] as! String
                    task.taskDescription = arr["description"] as! String
                    self.tasks.append(task)
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.taskTable.reloadData()
                }
                
                print(json)
            } catch let error as NSError {
                print(error.debugDescription)
            }
        }
        task.resume()
    }
    
    //reloads table when you delete a cell
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            taskTable.reloadData()
        }
    }
 
    func refresh(sender: AnyObject) {
        if tasks.count != 0{
            tasks.removeAll()
        }
        getTasks()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refresh("")
    }

}
