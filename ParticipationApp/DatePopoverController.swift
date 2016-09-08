//
//  DatePopoverController.swift
//  ParticipationApp
//
//  Created by CJS  on 8/24/16.
//  Copyright © 2016 CJS . All rights reserved.
//

import UIKit

protocol DateDelegate {
    func dateIsChanged(dateChosen: String)
}


class DatePopoverController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var dateTableView: UITableView!
    
    var tableView: UITableView!
    var items: [String] = ["Today", "Week", "Month", "All Time"]
    var chosen = "All Time"
    var dateDel: DateDelegate?
    let defaults = NSUserDefaults.standardUserDefaults()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let chosenFilter = defaults.objectForKey("selection") {
            
            chosen = chosenFilter as! String
        }
        self.dateTableView.scrollEnabled = false
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSUserDefaults.standardUserDefaults().setObject(items[indexPath.row], forKey: "selection")
        NSUserDefaults.standardUserDefaults().synchronize()
        dateDel?.dateIsChanged(items[indexPath.row])
        
        //load user defaults to chosen variable
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.dateTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! DateTableViewCell
        
        cell.dateLabel?.text = self.items[indexPath.row]
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        if items[indexPath.row] == chosen {
        cell.backgroundColor = UIColor.grayColor()
        }
        
        return cell
    }
}
