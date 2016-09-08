//
//  PresentationStudentController.swift
//  ParticipationApp
//
//  Created by CJS  on 8/5/16.
//  Copyright © 2016 CJS . All rights reserved.
//

import UIKit

protocol PresentationStudentDelegate {
    func presentationDonePressed(ispressed: Bool)
    func studentFilePressed()
}

class PresentationStudentController: UIViewController {
    @IBOutlet weak var commentsTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var pointsLabel: UILabel!
    
    var studentName: String?
    var presentationDelegate: PresentationStudentDelegate?
    var points = 0
    
    @IBAction func subtractPoints(sender: AnyObject) {
        if points >= 1 {points = points - 1
            pointsLabel.text = String(points)}
    }
    
    @IBAction func addPoints(sender: AnyObject) {
        points = points + 1
        pointsLabel.text = String(points)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 25)!]
        if let sName = studentName {
            self.navigationItem.title = sName
        }
        
        commentsTextView.becomeFirstResponder()
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        commentsTextView.layer.borderWidth = 0.5
        commentsTextView.layer.borderColor = borderColor.CGColor
        commentsTextView.layer.cornerRadius = 5.0
        
        pointsLabel.layer.borderWidth = 0.5
        pointsLabel.layer.borderColor = borderColor.CGColor
        pointsLabel.layer.cornerRadius = 5.0
        pointsLabel.text = String(points)
    }
    
    @IBAction func doneButton(sender: AnyObject) {
        presentationDelegate?.presentationDonePressed(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func StudentFilePressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        presentationDelegate?.studentFilePressed()
    }
}
