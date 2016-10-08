//
//  PresentationStudentController.swift
//  ParticipationApp
//
//  Created by CJS  on 8/5/16.
//  Copyright © 2016 CJS . All rights reserved.
//

import UIKit
import CoreData

protocol PresentationStudentDelegate {
    func presentationDonePressed(_ ispressed: Bool)
    func studentFilePressed()
}

class PresentationStudentController: UIViewController {
    @IBOutlet weak var commentsTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var pointsLabel: UILabel!
    var coreDataManager = CoreDataManager()
    let date = NSDate()
    var activeClassKey = String()
    var key = String()
    var studentName: String?
    var presentationDelegate: PresentationStudentDelegate?
    var points = 0
    
    @IBAction func subtractPoints(_ sender: AnyObject) {
        if points >= 1 {points = points - 1
            pointsLabel.text = String(points)}
    }
    
    @IBAction func addPoints(_ sender: AnyObject) {
        points = points + 1
        pointsLabel.text = String(points)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print ("activeClassKeyDeskView", activeClassKey)
        print ("classKeyKey", key)
        
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 25)!]
        if let sName = studentName {
            self.navigationItem.title = sName
        }
        
        commentsTextView.becomeFirstResponder()
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        commentsTextView.layer.borderWidth = 0.5
        commentsTextView.layer.borderColor = borderColor.cgColor
        commentsTextView.layer.cornerRadius = 5.0
        
        pointsLabel.layer.borderWidth = 0.5
        pointsLabel.layer.borderColor = borderColor.cgColor
        pointsLabel.layer.cornerRadius = 5.0
        pointsLabel.text = String(points)
    }
    
    func randomString(length: Int) -> String {
        let charSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var c = charSet.characters.map { String($0) }
        var s:String = ""
        for _ in (1...length) {
            s.append(c[Int(arc4random()) % c.count])
        }
        print (s)
        return s
    }
    
    @IBAction func saveButton(_ sender: AnyObject) {
        let someString = pointsLabel.text
        if let number = Int(someString!) {
            let myNumber = NSNumber(value:number)
        
        self.coreDataManager.addDataToStudent(comment: commentsTextView.text, studentKey: self.randomString(length: 10), key: self.key, activeClassKey: self.activeClassKey, commentDate: Date() as NSDate, point: myNumber)
        }
        presentationDelegate?.presentationDonePressed(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButton(_ sender: AnyObject) {
        presentationDelegate?.presentationDonePressed(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func StudentFilePressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
        print("this was called")
        presentationDelegate?.studentFilePressed()
    }
}
