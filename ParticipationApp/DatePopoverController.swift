//
//  DatePopoverController.swift
//  ParticipationApp
//
//  Created by CJS  on 8/24/16.
//  Copyright © 2016 CJS . All rights reserved.
//

import UIKit

protocol DateDelegate {
    func dateIsChanged(_ dateChosen: String)
}

class DatePopoverController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var dateTableView: UITableView!
    
    var tableView: UITableView!
    var items: [String] = ["Today", "Week", "Month", "All Time"]
    var chosen = "All Time"
    var dateDel: DateDelegate?
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        if let chosenFilter = defaults.object(forKey: "selection") {
            
            chosen = chosenFilter as! String
        }
        
        self.dateTableView.isScrollEnabled = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(items[(indexPath as NSIndexPath).row], forKey: "selection")
        UserDefaults.standard.synchronize()
        dateDel?.dateIsChanged(items[(indexPath as NSIndexPath).row])
        
        //load user defaults to chosen variable
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dateTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DateTableViewCell
        
        cell.dateLabel?.text = self.items[(indexPath as NSIndexPath).row]
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        if items[(indexPath as NSIndexPath).row] == chosen {
        cell.backgroundColor = UIColor.gray
        }
        
        return cell
    }
}
