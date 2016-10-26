//
//  DeskView.swift
//  ParticipationApp
//
//  Created by CJS  on 7/22/16.
//  Copyright © 2016 CJS . All rights reserved.
//

import UIKit
import CoreData

class DeskViewController: UICollectionViewController, UIGestureRecognizerDelegate, UIPopoverPresentationControllerDelegate, PresentationStudentDelegate  {
    @IBOutlet weak var deskTextField: UITextField!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    var random = -1
    var activeClassKey = String()
    var key = String()
    var newVariable = String()
    var flow = UICollectionViewFlowLayout()
    var editDeleteButton: Bool = false
    var people = [Person]()
    var coreDataManager = CoreDataManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "\(newVariable)"
        print ("activeClassKey", activeClassKey)
        collectionView!.allowsMultipleSelection = true;

//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DeskViewController.rotated), name: UIDeviceOrientationDidChangeNotification, object: nil)
        
        flow = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        flow.sectionInset = UIEdgeInsetsMake(25, 10, 10, 10)
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        people.removeAll()
        print("this was called view will appear")
        coreDataManager = CoreDataManager()
        people = coreDataManager.fetchStudent(activeClassKey: activeClassKey)
        for f in people {
            print("person: \(f.name)")
        }
        
        people = people.sorted(by: { $0.studentDtate?.compare($1.studentDtate as! Date) == .orderedAscending })
        collectionView?.reloadData()
        self.view.alpha = 1.0
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        self.view.alpha = 1.0
    }
    
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        self.view.alpha = 0.1
    }
    
     func studentFilePressed() {
        print("student file 1")
        self.performSegue(withIdentifier: "PopoverSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Prepare for segue and pass data
        if segue.identifier == "PopoverSegue" {
            
            let studentName = people[random]
            let svc = segue.destination as! StudentViewController;
            if let name = studentName.name {
                svc.nameOfStudent = name
            }
            if let stKey = studentName.key {
                svc.studentKey = stKey
            }
            svc.activeClassKey = activeClassKey
            print("peformStudentFile")
        }
    }
 
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        //Prepare for segue and pass dataactiveClassKey
//        print ("popover")
//        if segue.identifier == "PopSegue" {
//            let indexPath = collectionView!.indexPath(for: sender as! DeskNameCell)
//            let studentKey = people[(indexPath! as NSIndexPath).row]
//            let svc = segue.destination as! PresentationStudentController;
//            svc.activeClassKey = (studentKey.value(forKey: "key") as! String?)!
//            svc.key = (studentKey.value(forKey: "key") as! String?)!
//            print ("popover segue used")
//        }
//    }
    
//    func rotated() {
//        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation)) {
//            let width = UIScreen.mainScreen().bounds.size.width - 200;
//            flow.itemSize = CGSizeMake(width/7, width/7)
//            flow.minimumInteritemSpacing = 25
//            flow.minimumLineSpacing = 10
//            print("landscape")
//        }
//        
//        if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation)) {
//            let width = UIScreen.mainScreen().bounds.size.width - 100;
//            flow.itemSize = CGSizeMake(width/7, width/7)
//            flow.minimumInteritemSpacing = 2
//            flow.minimumLineSpacing = 50
//            print("Portrait")
//        }
//        
//        self.collectionView?.reloadData()
//    }
    
    //Mark - PresentationStudentDelegate
    func presentationDonePressed(_ ispressed: Bool) {
        self.coreDataManager = CoreDataManager()
        people.removeAll()
        people = coreDataManager.fetchStudent(activeClassKey: activeClassKey)
        self.people = self.people.sorted(by: { $0.studentDtate?.compare($1.studentDtate as! Date) == .orderedAscending })
        collectionView?.reloadData()
        if ispressed {
            self.view.alpha = 1.0
        }
    }
    
   //Mark - Random Call Button
    @IBAction func RandomCallButton(_ sender: UIBarButtonItem) {
        self.random = Int(arc4random_uniform(UInt32(self.people.count)))
//        self.collectionView!.reloadData()
        
        //Popover screen for random
        let popoverContent = (self.storyboard?.instantiateViewController(withIdentifier: "PresentationStudentController"))! as! PresentationStudentController
        popoverContent.presentationDelegate = self
        popoverContent.studentName = people[random].name
        if let key = people[random].key {
            popoverContent.key = key
        }
        popoverContent.activeClassKey = activeClassKey
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover = nav.popoverPresentationController
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width - 150
        popoverContent.preferredContentSize = CGSize(width: width, height: 300)
        popover!.delegate = self
        popover!.sourceView = self.view
        popover!.sourceRect = CGRect(x: self.view.bounds.midX, y: 375, width: 0, height: 0)
        popover?.permittedArrowDirections = UIPopoverArrowDirection()
        popover!.delegate = self
        self.present(nav, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle() -> UIModalPresentationStyle {
            return UIModalPresentationStyle.overFullScreen
    }
    
//    For iphone presentation Popover screen
//    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
//        return UIModalPresentationStyle.None
//    }
//    
//    func presentationController(controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController?
//     {
//        let navigationController = UINavigationController(rootViewController: controller.presentedViewController)
//        let btnDone = UIBarButtonItem(title: "Done", style: .Done, target: self, action: #selector(DeskViewController.dismiss))
//        navigationController.topViewController!.navigationItem.rightBarButtonItem = btnDone
//        return navigationController
//    }
//    
//    func dismiss() {
//        self.dismissViewControllerAnimated(true, completion: nil)
//   }
    
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
    
    //Alert view for student name
    @IBAction func AddSeatButton(_ sender: UIBarButtonItem) {
        if !editDeleteButton {
            
            let alertController = UIAlertController(title: "Student Name:", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addTextField () { (textField:UITextField!) -> Void in  textField.autocorrectionType = UITextAutocorrectionType.yes;
            textField.autocapitalizationType = UITextAutocapitalizationType.words
        }
        
        alertController.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.default,handler: {(action) -> Void in
            let textf = alertController.textFields![0] as UITextField
            
            // Prints student name to desk text field
            if let nameStr = textf.text , !nameStr.isEmpty {
                print(nameStr)
                self.coreDataManager.addStudentsToClass(nameStr, studentDtate: Date() as NSDate, key: self.randomString(length: 10), activeClassKey: self.activeClassKey)
                self.people.removeAll()
                self.people = self.coreDataManager.fetchStudent(activeClassKey: self.activeClassKey)
                self.people = self.people.sorted(by: { $0.studentDtate?.compare($1.studentDtate as! Date) == .orderedAscending })
                self.collectionView!.reloadData()
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {(action) -> Void in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertController, animated: true, completion: nil)
        } else {
            editDeleteButton = !editDeleteButton
            addButton.title = "Add"
            self.editButton.title = "Select"
            collectionView?.reloadData()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellDesk = collectionView.dequeueReusableCell(withReuseIdentifier: "cellDesk", for: indexPath) as! DeskNameCell
        let desk = people[(indexPath as NSIndexPath).row]

        //Desk information
        cellDesk.layer.cornerRadius = cellDesk.frame.size.width/3.9
        cellDesk.layer.shadowColor = UIColor.lightGray.cgColor
        cellDesk.layer.shadowOffset = CGSize(width: 0, height: 2)
        cellDesk.layer.shadowOpacity = 0.5
        cellDesk.layer.shadowRadius = 3
        cellDesk.clipsToBounds = false
        cellDesk.layer.masksToBounds = false
        cellDesk.layer.shouldRasterize = false
        cellDesk.deskNameLabel.text = people[indexPath.row].name
        
        print("test: \(desk.name)")
        //Random button pushed changes color - Changed (void)
        if(random == (indexPath as NSIndexPath).row)  {
            cellDesk.layer.backgroundColor = ColorManager().colorFromRGBHexString("966C4D").cgColor //light brown

        } else {
            cellDesk.layer.backgroundColor = ColorManager().colorFromRGBHexString("966C4D").cgColor //light brown
        }
        
        if editDeleteButton {
            cellDesk.alpha = 0.5
        } else {
            cellDesk.alpha = 1.0
        }
        
        return cellDesk
    }

    func collectionView(_ collectionView: UICollectionView, canEditRowAtIndexPath indexPath: IndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
        return true
    }
    
     override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.people.count
    }
}
//    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        let temp = people[(sourceIndexPath as NSIndexPath).row]
//        people[(sourceIndexPath as NSIndexPath).row] = people[(destinationIndexPath as NSIndexPath).row]
//        people[(destinationIndexPath as NSIndexPath).row] = temp
//    }


    //Mark - CollectionView Data source
extension DeskViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let celldesk = collectionView.cellForItem(at: indexPath) as! DeskNameCell
        print(collectionView.indexPathsForSelectedItems)
    
        if editDeleteButton {
            if celldesk.isSelected == true {
                celldesk.alpha = 1.0
            }
        } else {
            let popoverContent = (self.storyboard?.instantiateViewController(withIdentifier: "PresentationStudentController"))! as! PresentationStudentController
            popoverContent.presentationDelegate = self
            random = indexPath.row
            popoverContent.studentName = people[random].name
            print("name of thing", people[random].name)
            for n in people {
                print ("names", n.name)
            }
            let nav = UINavigationController(rootViewController: popoverContent)
            nav.modalPresentationStyle = UIModalPresentationStyle.popover
            if let key = people[random].key {
                popoverContent.key = key
            }
            popoverContent.activeClassKey = activeClassKey
            let popover = nav.popoverPresentationController
            let bounds = UIScreen.main.bounds
            let width = bounds.size.width - 150
            popoverContent.preferredContentSize = CGSize(width: width, height: 300)
            popover!.delegate = self
            popover!.sourceView = self.view
            popover!.sourceRect = CGRect(x: self.view.bounds.midX, y: 375, width: 0, height: 0)
            popover?.permittedArrowDirections = UIPopoverArrowDirection()
            popover!.delegate = self
            self.present(nav, animated: true, completion: nil)
        }
    }
    
override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print(collectionView.indexPathsForSelectedItems)
    }
   
    @IBAction func editButton(_ sender: UIBarButtonItem) {
        editDeleteButton = !editDeleteButton
        
        if editDeleteButton {
            self.editButton.title = "Delete"
            addButton.title = "Cancel"
        } else {
            self.editButton.title = "Select"
            addButton.title = "Add"
            let paths = (collectionView?.indexPathsForSelectedItems)! as [IndexPath]
            let sortedArray = paths.sorted() {($0 as NSIndexPath).row > ($1 as NSIndexPath).row}
            
            for index in sortedArray {
                let person = people[(index as NSIndexPath).row]
                coreDataManager.deletePerson(activeClassKey: activeClassKey, studentKey: person.key!)
                print ("People Removed")
            }
        }
        people.removeAll()
        people = coreDataManager.fetchStudent(activeClassKey: activeClassKey)
        self.people = self.people.sorted(by: { $0.studentDtate?.compare($1.studentDtate as! Date) == .orderedAscending })
        collectionView?.reloadData()
    }
}

extension DeskViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var collectionViewSize = collectionView.frame.size
        collectionViewSize.width = collectionViewSize.width/8.0  //Display Three elements in a row.
        collectionViewSize.height = collectionViewSize.height/9.0 - 18.0
        flow.minimumInteritemSpacing = 2
        flow.minimumLineSpacing = 45
        
        return collectionViewSize
    }
}
