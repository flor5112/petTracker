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
    
    @IBOutlet weak var taskTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //preares TableView to display 
        self.taskTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.taskTable.dataSource=self
        self.taskTable.delegate=self
        
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
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        
        // Edit Button
        let editAction = UITableViewRowAction(style: .Normal, title: "Edit"){ (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            
            let firstActivityItem=self.tasks[indexPath.row]
            let activityViewController = UIActivityViewController(activityItems: [firstActivityItem], applicationActivities: nil)
            self.presentViewController(activityViewController, animated: true, completion: nil)
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
    
    func getTasks()
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        let petId = defaults.stringForKey(defaultsKeys.petID)
        
        let petUrl = NSURL(string: "https://pettrackerapp.herokuapp.com/pet/getTaskForPet")
        let request = NSMutableURLRequest(URL:petUrl!)
        request.HTTPMethod = "POST"
        let postString = "pet_id=" + petId!
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            (data, response, error) in
            do {
                guard let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSArray else {
                    return
                }
                for arr in json{
                    let task = Task()
                    task.taskTitle = arr["taskTitle"] as! String
                    task.taskDescription = arr["taskDescription"] as! String
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
