//
//  DeskView.swift
//  ParticipationApp
//
//  Created by CJS  on 7/22/16.
//  Copyright © 2016 CJS . All rights reserved.
//

import UIKit

class DeskViewController: UICollectionViewController, UIGestureRecognizerDelegate, UIPopoverPresentationControllerDelegate, PresentationStudentDelegate  {
    @IBOutlet weak var deskTextField: UITextField!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    var random = -1
    var seatArray = [String]()
    var newVariable = String ()
    var flow = UICollectionViewFlowLayout()
    var editDeleteButton: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "\(newVariable)"
        seatArray = ["Corey Schwarzkopf", "Alfred H.", "Chris", "Janet P.", "Samson Rolf", "Miranna Kutrhapualie", "Paul", "Sandy", "Smith", "", "", "", "Corey Schwarzkopf", "Alfred H.", "Chris", "Janet P.", "Samson Rolf", "Miranna Kutrhapualie", "Paul", "Sandy", "Smith", "", "", "", "Corey Schwarzkopf", "Alfred H.", "Chris", "Janet P.", "", ""]
        
        collectionView!.allowsMultipleSelection = true;

//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DeskViewController.rotated), name: UIDeviceOrientationDidChangeNotification, object: nil)

        flow = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        flow.sectionInset = UIEdgeInsetsMake(25, 10, 10, 10)
    }
        
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.view.alpha = 1.0
//        rotated()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        self.view.alpha = 1.0
    }
    
    func prepareForPopoverPresentation(popoverPresentationController: UIPopoverPresentationController) {
        self.view.alpha = 0.1
    }
    
    
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
    func presentationDonePressed(ispressed: Bool) {
        if ispressed {
            self.view.alpha = 1.0
        }
    }
    
    func studentFilePressed() {
        self.performSegueWithIdentifier("PopoverSegue", sender: nil)
    }
    
   //Mark - Random Call Button
    @IBAction func RandomCallButton(sender: UIBarButtonItem) {
        // reloads the visible cells, highlighting the random one
        self.random = Int(arc4random_uniform(UInt32(self.seatArray.count)))
        //self.collectionView!.reloadData()
      
        //Popover screen for random
        let popoverContent = (self.storyboard?.instantiateViewControllerWithIdentifier("PresentationStudentController"))! as! PresentationStudentController
        popoverContent.presentationDelegate = self
        popoverContent.studentName = seatArray[random]
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.Popover
        let popover = nav.popoverPresentationController
        let bounds = UIScreen.mainScreen().bounds
        let width = bounds.size.width - 150
        popoverContent.preferredContentSize = CGSizeMake(width, 300)
        popover!.delegate = self
        popover!.sourceView = self.view
        popover!.sourceRect = CGRectMake(CGRectGetMidX(self.view.bounds), 375, 0, 0)
        popover!.permittedArrowDirections.isEmpty
        popover?.permittedArrowDirections = UIPopoverArrowDirection()
        popover!.delegate = self
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle() -> UIModalPresentationStyle {
            return UIModalPresentationStyle.OverFullScreen
    }
    
//For iphone presentation Popover screen
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
    
    //Alert view for student name
    @IBAction func AddSeatButton(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Student Name:", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addTextFieldWithConfigurationHandler () { (textField:UITextField!) -> Void in  textField.autocorrectionType = UITextAutocorrectionType.Yes;
            textField.autocapitalizationType = UITextAutocapitalizationType.Words
        }
        
        alertController.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.Default,handler: {(action) -> Void in
            let textf = alertController.textFields![0] as UITextField
            
            // Prints student name to desk text field
            if let nameStr = textf.text {
                print(nameStr)
                self.seatArray.append(nameStr)
                self.collectionView!.reloadData()
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {(action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellDesk = collectionView.dequeueReusableCellWithReuseIdentifier("cellDesk", forIndexPath: indexPath) as! DeskNameCell

        //Desk information
        //cellDesk.deskNameLabel.text = seatArray[indexPath.row]
        cellDesk.layer.cornerRadius = cellDesk.frame.size.width/3.9
        cellDesk.layer.shadowColor = UIColor.lightGrayColor().CGColor
        cellDesk.layer.shadowOffset = CGSizeMake(0, 2)
        cellDesk.layer.shadowOpacity = 0.5
        cellDesk.layer.shadowRadius = 3
        cellDesk.clipsToBounds = false
        cellDesk.layer.masksToBounds = false
        cellDesk.layer.shouldRasterize = false
        cellDesk.deskNameLabel.text = seatArray[indexPath.row]
        
    
        //Random button pushed changes color - Changed 
        if(random == indexPath.row)  {
           // cellDesk.backgroundColor = UIColor.purpleColor()
            cellDesk.layer.backgroundColor = ColorManager().colorFromRGBHexString("966C4D").CGColor //light brown

        } else {
            cellDesk.layer.backgroundColor = ColorManager().colorFromRGBHexString("966C4D").CGColor //light brown
        }
        
        if editDeleteButton {
            cellDesk.alpha = 0.5
        } else {
            cellDesk.alpha = 1.0
        }
        
        return cellDesk
    }

    func collectionView(collectionView: UICollectionView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
        return true
    }
    
     override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.seatArray.count
    }
   
    override func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let temp = seatArray[sourceIndexPath.row]
        seatArray[sourceIndexPath.row] = seatArray[destinationIndexPath.row]
        seatArray[destinationIndexPath.row] = temp
    }
}

//Mark - CollectionView Data source
extension DeskViewController {
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //Mark - Perform segue with identifier
        newVariable = seatArray[indexPath.row]
        
        let celldesk = collectionView.cellForItemAtIndexPath(indexPath) as! DeskNameCell
        print(collectionView.indexPathsForSelectedItems())
        
        if editDeleteButton {
            if celldesk.selected == true {
                //cell.layer.borderWidth = 10
                celldesk.alpha = 1.0
                //            cell.layer.borderColor = UIColor.orangeColor().CGColor
                //            deleteButtonTapped()
            }
        }
        else {
            let popoverContent = (self.storyboard?.instantiateViewControllerWithIdentifier("PresentationStudentController"))! as! PresentationStudentController
            popoverContent.presentationDelegate = self
            popoverContent.studentName = seatArray[indexPath.row]
            let nav = UINavigationController(rootViewController: popoverContent)
            nav.modalPresentationStyle = UIModalPresentationStyle.Popover
            let popover = nav.popoverPresentationController
            let bounds = UIScreen.mainScreen().bounds
            let width = bounds.size.width - 150
            popoverContent.preferredContentSize = CGSizeMake(width, 300)
            popover!.delegate = self
            popover!.sourceView = self.view
            popover!.sourceRect = CGRectMake(CGRectGetMidX(self.view.bounds), 375, 0, 0)
            popover!.permittedArrowDirections.isEmpty
            popover?.permittedArrowDirections = UIPopoverArrowDirection()
            popover!.delegate = self
            self.presentViewController(nav, animated: true, completion: nil)
        }
    }
    
override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        print(collectionView.indexPathsForSelectedItems())
        collectionView.cellForItemAtIndexPath(indexPath) as! DeskNameCell
//        cellDesk.alpha = 0.5
    }
   
    @IBAction func editButton(sender: UIBarButtonItem) {
        editDeleteButton = !editDeleteButton
        if editDeleteButton {
            self.editButton.title = "Delete"
        } else {
            self.editButton.title = "Select"
            
            let paths = (collectionView?.indexPathsForSelectedItems())! as [NSIndexPath]
                let sortedArray = paths.sort() {$0.row > $1.row}
                
                for index in sortedArray {
                    
                    seatArray.removeAtIndex(index.row)
            }
        }
        collectionView?.reloadData()
    }
}
extension DeskViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        var collectionViewSize = collectionView.frame.size
        collectionViewSize.width = collectionViewSize.width/8.0  //Display Three elements in a row.
        collectionViewSize.height = collectionViewSize.height/9.0 - 18.0
        flow.minimumInteritemSpacing = 2
        flow.minimumLineSpacing = 45
        
        return collectionViewSize
        
    }
}
