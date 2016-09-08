//
//  StudentViewController.swift
//  ParticipationApp
//
//  Created by CJS  on 7/23/16.
//  Copyright © 2016 CJS . All rights reserved.
//

import UIKit

class StudentViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITableViewDelegate, UITableViewDataSource, DateDelegate{
    
    @IBOutlet weak var notesTableView: UITableView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var pointsViewLabel: UILabel!
    @IBOutlet weak var editSaveButton: UIBarButtonItem!
    
    var editButton: Bool = false
    var isEditable: Bool = false
    var notesTableViewDelete: NSIndexPath? = nil
    var notesArray = ["", "", ""]

    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = NSUserDefaults.standardUserDefaults()
        if let chosenFilter = defaults.objectForKey("selection") {
            self.navigationItem.title = chosenFilter as? String
        }
        
    
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        pointsViewLabel.layer.borderWidth = 0.5
        pointsViewLabel.layer.borderColor = borderColor.CGColor
        pointsViewLabel.layer.cornerRadius = 5.0
        pointsViewLabel.layer.masksToBounds = true
    
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(StudentViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        textFieldDeactive()
        
        self.notesTableView.tableFooterView = UIView()

        // This view controller itself will provide the delegate methods and row data for the table view.
        notesTableView.delegate = self
        notesTableView.dataSource = self
    }
    
    // number of rows in table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesArray.count
    }
    
     func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if isEditable {
            return true
        }
        return false
    }
    
     func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            notesArray.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)        }
    }
    
    
    
    // create a cell for each table view row
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        // create a new cell if needed or reuse an old one
        let cell = notesTableView.dequeueReusableCellWithIdentifier("cell") as! StudentFileTableViewCell
        if isEditable{
            cell.pointsNoteTextField.setBoarder()
            cell.noteTextView.layer.borderWidth = 2
            cell.noteTextView.layer.borderColor = UIColor.grayColor().CGColor
            cell.noteTextView.layer.cornerRadius = 8
            cell.noteTextView.userInteractionEnabled = true
        } else {
            cell.pointsNoteTextField.removeBoarder()
            cell.noteTextView.layer.borderWidth = 0.5
            cell.noteTextView.layer.borderColor = borderColor.CGColor
            cell.noteTextView.layer.cornerRadius = 5.0
            cell.noteTextView.userInteractionEnabled = false
        }
        
        cell.noteTextView.text = "The student was on task all hour. Student added participation to class and said, Walter Whitman was an American poet, essayist, and journalist. A humanist, he was a part of the transition between transcendentalism and realism, incorporating both views in his works"
        cell.pointsNoteTextField.text = "1"
        cell.noteTextView.textColor = UIColor(red: 114 / 255,
                                          green: 114 / 255,
                                          blue: 114 / 255,
                                          alpha: 1.0)
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
    }

    @IBAction func editSaveButton(sender: UIBarButtonItem) {
        editButton = !editButton //switches button ON/OFF
        if editButton {
            self.editSaveButton.title = "Save"
            textFieldActive()
        } else {
            self.editSaveButton.title = "Edit"
//          notesTableView.editing = true
            textFieldDeactive()
        }
    }
    
    func textFieldActive(){
    //Changes border style
        nameTextField.setBoarder()
        isEditable = true
        notesTableView.reloadData()
    }

    func  textFieldDeactive(){
        nameTextField.removeBoarder()
        isEditable = false
        notesTableView.reloadData()
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func dateIsChanged(dateChosen: String) {
        self.navigationItem.title = dateChosen

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "dateSegue" {
            let popoverViewController = segue.destinationViewController as! DatePopoverController
            popoverViewController.dateDel = self
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    @IBAction func doneButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension UITextField {
    
    func setBoarder() {
        self.userInteractionEnabled = true
        self.layer.cornerRadius = 8
        self.layer.borderColor = UIColor.grayColor().CGColor
        self.layer.borderWidth = 2
    }
    func removeBoarder() {
        self.userInteractionEnabled = false
        self.layer.borderColor = UIColor.clearColor().CGColor
    }
}
