//
//  StudentViewController.swift
//  ParticipationApp
//
//  Created by CJS  on 7/23/16.
//  Copyright © 2016 CJS . All rights reserved.
//

import UIKit
import CoreData

class StudentViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITableViewDelegate, UITableViewDataSource, DateDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var notesTableView: UITableView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var pointsViewLabel: UILabel!
    @IBOutlet weak var editSaveButton: UIBarButtonItem!
    
    var editButton: Bool = false
    var isEditable: Bool = false
    var notesTableViewDelete: IndexPath? = nil
    var notesArray = [Selected]()
    var nameOfStudent = String()
    var coreDataManager = CoreDataManager()
    var studentKey = String()
    var activeClassKey = String()
    var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.delegate = self
        nameTextField.text = nameOfStudent

        notesTableView.estimatedRowHeight = 300.00
        notesTableView.rowHeight = UITableViewAutomaticDimension

        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        pointsViewLabel.layer.borderWidth = 0.5
        pointsViewLabel.layer.borderColor = borderColor.cgColor
        pointsViewLabel.layer.cornerRadius = 5.0
        pointsViewLabel.layer.masksToBounds = true
        
        print("score", score)
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(StudentViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        textFieldDeactive()
        
        self.notesTableView.tableFooterView = UIView()
        notesTableView.delegate = self
        notesTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let defaults = UserDefaults.standard
        if let chosenFilter = defaults.object(forKey: "selection") as? String {
            self.navigationItem.title = chosenFilter
              filter(chosenFilter)
        }

        score = addPoints()
        pointsViewLabel.text = String(score)
        notesTableView.reloadData()
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesArray.count
    }

    func addPoints() -> Int {
        print("this called add points")
        for points in notesArray {
            score += points.point as! Int
        }
        print("score12", score)
        return score
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let note = notesArray[indexPath.row]
            coreDataManager.deleteStudentInfo(activeClassKey: activeClassKey, studentKey: studentKey, key: note.key!)
            notesArray.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
        score = 0
        score = addPoints()
        pointsViewLabel.text = String(score)
        coreDataManager.updateStudentName(name: nameTextField.text!, activeClassKey: self.activeClassKey, key: studentKey)
        tableView.reloadData()
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        // create a new cell if needed or reuse an old one
        let cell = notesTableView.dequeueReusableCell(withIdentifier: "cell") as! StudentFileTableViewCell
        let note = notesArray[(indexPath as NSIndexPath).row]
        
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
        cell.noteTextView.text = note.value(forKey: "comment") as? String
        let x = note.point?.description
        cell.pointsNoteTextField.text = x
        let commentDate = note.commentDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let string = dateFormatter.string(from: commentDate as! Date)
        cell.dateNoteLabel.text = string
        return cell
    }

    @IBAction func editSaveButton(_ sender: UIBarButtonItem) {
        editButton = !editButton //switches button ON/OFF
        
        if editButton {
            self.editSaveButton.title = "Save"
            textFieldActive()
        } else {
            self.editSaveButton.title = "Edit"
     
            for (index, note) in notesArray.enumerated() {
                let cell = notesTableView.cellForRow(at: IndexPath(row: index, section: 0)) as! StudentFileTableViewCell
                
                let someString =  cell.pointsNoteTextField.text
                print("testt: \(index)")
                if let number = Int(someString!) {
                    let myNumber = NSNumber(value:number)
                coreDataManager.updateStudentData(comment: cell.noteTextView.text, studentKey: self.studentKey, key: note.key!, activeClassKey: self.activeClassKey, point: myNumber)
                    
                    score = 0
                    score = addPoints()
                    pointsViewLabel.text = String(score)
                    coreDataManager.updateStudentName(name: nameTextField.text!, activeClassKey: self.activeClassKey, key: studentKey)
                }
            }
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
        filter(dateChosen)
        score = 0
        score = addPoints()
        pointsViewLabel.text = String(score)
        notesTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dateSegue" {
            let popoverViewController = segue.destination as! DatePopoverController
            popoverViewController.dateDel = self
        }
    }
    
    func filter(_ dateChosen: String) {
        var someArray = [Selected]()
        let calendar = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let month = (calendar?.component(NSCalendar.Unit.month, from: NSDate() as Date))!
        let week = (calendar?.component(NSCalendar.Unit.weekOfYear, from: NSDate() as Date))!
        let today = (calendar?.component(NSCalendar.Unit.day, from: NSDate() as Date))!
        
        if dateChosen == "All Time" {
            print("All Time Called")
            notesArray = coreDataManager.fetchStudentData(key: studentKey, activeClassKey: activeClassKey)
            notesArray = notesArray.sorted(by: { $0.commentDate?.compare($1.commentDate as! Date) == .orderedDescending })
        }
        else if dateChosen == "Today" {
            notesArray = coreDataManager.fetchStudentData(key: studentKey, activeClassKey: activeClassKey)
            for notes in notesArray {
                let noteDay = (calendar?.component(NSCalendar.Unit.day, from: notes.commentDate as! Date))!
                print (noteDay, "noteDay")
                if today == noteDay
                {
                    someArray.append(notes)
                }
            }
            notesArray.removeAll()
            notesArray = someArray
            notesArray = notesArray.sorted(by: { $0.commentDate?.compare($1.commentDate as! Date) == .orderedDescending })
            print ("day", today)
        }
            
        else if dateChosen == "Month" {
            notesArray = coreDataManager.fetchStudentData(key: studentKey, activeClassKey: activeClassKey)
            for notes in notesArray {
                let noteMonth = (calendar?.component(NSCalendar.Unit.month, from: notes.commentDate as! Date))!
                print (noteMonth, "noteMonth")
                    if month == noteMonth
                    {
                        someArray.append(notes)
                    }
            }
            notesArray.removeAll()
            notesArray = someArray
            notesArray = notesArray.sorted(by: { $0.commentDate?.compare($1.commentDate as! Date) == .orderedDescending })
            print ("Month", month)
        }
            
        else if dateChosen == "Week" {
            notesArray = coreDataManager.fetchStudentData(key: studentKey, activeClassKey: activeClassKey)
            for notes in notesArray {
                let noteWeek = (calendar?.component(NSCalendar.Unit.weekOfYear, from: notes.commentDate as! Date))!
                print (noteWeek, "noteWeek")
                if week == noteWeek
                {
                    someArray.append(notes)
                }
            }
            
            notesArray.removeAll()
            notesArray = someArray
            notesArray = notesArray.sorted(by: { $0.commentDate?.compare($1.commentDate as! Date) == .orderedDescending })
            print ("week", week)
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
