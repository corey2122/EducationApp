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
    var notesTableViewDelete: IndexPath? = nil
    var notesArray = [""]
    var nameOfStudent = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = UserDefaults.standard
        if let chosenFilter = defaults.object(forKey: "selection") {
            self.navigationItem.title = chosenFilter as? String
        }
        
        nameTextField.text = nameOfStudent

        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        pointsViewLabel.layer.borderWidth = 0.5
        pointsViewLabel.layer.borderColor = borderColor.cgColor
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesArray.count
    }
    
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if isEditable {
            return true
        }
        return false
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            notesArray.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        // create a new cell if needed or reuse an old one
        let cell = notesTableView.dequeueReusableCell(withIdentifier: "cell") as! StudentFileTableViewCell
        
        
        if isEditable{
            cell.pointsNoteTextField.setBoarder()
            cell.noteTextView.layer.borderWidth = 2
            cell.noteTextView.layer.borderColor = UIColor.gray.cgColor
            cell.noteTextView.layer.cornerRadius = 8
            cell.noteTextView.isUserInteractionEnabled = true
        } else {
            cell.pointsNoteTextField.removeBoarder()
            cell.noteTextView.layer.borderWidth = 0.5
            cell.noteTextView.layer.borderColor = borderColor.cgColor
            cell.noteTextView.layer.cornerRadius = 5.0
            cell.noteTextView.isUserInteractionEnabled = false
        }
        
        cell.noteTextView.textColor = UIColor(red: 114 / 255,
                                          green: 114 / 255,
                                          blue: 114 / 255,
                                          alpha: 1.0)
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
    
        return cell
    }

    @IBAction func editSaveButton(_ sender: UIBarButtonItem) {
        editButton = !editButton //switches button ON/OFF
        if editButton {
            self.editSaveButton.title = "Save"
            textFieldActive()
        } else {
            self.editSaveButton.title = "Edit"
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
    
    func dateIsChanged(_ dateChosen: String) {
        self.navigationItem.title = dateChosen

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dateSegue" {
            let popoverViewController = segue.destination as! DatePopoverController
            popoverViewController.dateDel = self
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    @IBAction func doneButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension UITextField {
    
    func setBoarder() {
        self.isUserInteractionEnabled = true
        self.layer.cornerRadius = 8
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 2
    }
    func removeBoarder() {
        self.isUserInteractionEnabled = false
        self.layer.borderColor = UIColor.clear.cgColor
    }
}
