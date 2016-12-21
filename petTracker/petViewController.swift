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
    
    //Reference to tableView
   
    
    @IBOutlet weak var petsTable: UITableView!
    var items=["Dog","Cat","Cow"]
    var name=["lola","Philly","Carlos"]
    
    override func viewDidLoad() {
        print("user ID: \(userId)")
        print("username: \(username)")
        
        self.petsTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.petsTable.dataSource=self
        self.petsTable.delegate=self
        
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
        let cell = self.petsTable.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! petTableCell
        cell.name.text=name[indexPath.row]
        cell.type.text=items[indexPath.row]
        return cell
    }

    //something happens when you click on an specific cell
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You tapped on cell #\(indexPath.row)")
    }
}
