//
//  MasterViewController.swift
//  ParticipationApp
//
//  Created by CJS  on 7/21/16.
//  Copyright © 2016 CJS . All rights reserved.
//

import UIKit

class MasterViewController: UICollectionViewController {
    

    @IBOutlet weak var deleteButton: UIBarButtonItem!
    var editClassHour: Bool = false
    var flow = UICollectionViewFlowLayout()
    //Mark - Array of class names
    var dataArray = ["World History", "English 2", "1st Hour", "APUSH", "2nd Hour", "English 2", "Health"]

    var className = String()

    override func viewDidLoad() {
        super.viewDidLoad()
                print ("first")
        self.navigationItem.title = "Class"
        collectionView!.allowsMultipleSelection = true;

//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MasterViewController.rotated), name: UIDeviceOrientationDidChangeNotification, object: nil)
        
        flow = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        flow.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
    }
 
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
       
//        rotated()
    }
    
//    func rotated() {
//        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation)) {
//            let height = UIScreen.mainScreen().bounds.size.height - 50;
//            flow.itemSize = CGSizeMake(height/2.25, height/2.25)
//            flow.minimumInteritemSpacing = 4
//            flow.minimumLineSpacing = 55
//            print("landscape from master")
//        }
//        
//        if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation)) {
//            let height = UIScreen.mainScreen().bounds.size.height;
//            flow.itemSize = CGSizeMake(height/4.5, height/4.5)
//            flow.minimumInteritemSpacing = 0
//            flow.minimumLineSpacing = 10
//            print("Portrait from master")
//        }
//        
//       self.collectionView?.reloadData()
//    }
//
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    //cell information
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! ClassCell
        
        //Circle inside
//        cell.classViewCell.layer.borderWidth = 5
//        cell.classViewCell.layer.borderColor = ColorManager().colorFromRGBHexString("D8D8D8").CGColor //silver
//        cell.classViewCell.layer.backgroundColor = ColorManager().colorFromRGBHexString("2E2E2E").CGColor //black
//        cell.classViewCell.layer.cornerRadius = cell.classViewCell.frame.size.width/3.0
//        cell.classViewCell.clipsToBounds = true
        
        //Outside circle
//        cell.layer.borderWidth = 10
//        cell.layer.borderColor = ColorManager().colorFromRGBHexString("966C4D").CGColor //brown
//        cell.layer.backgroundColor = UIColor.clearColor().CGColor //clear
//        cell.layer.cornerRadius = cell.frame.size.width/3.0 - 40.0
//        cell.layer.shadowColor = UIColor.darkGrayColor().CGColor
//        cell.layer.shadowOffset = CGSizeMake(0, 5)
//        cell.layer.shadowOpacity = 0.5
//        cell.layer.shadowRadius = 5
//        cell.clipsToBounds = false
//        cell.layer.masksToBounds = false
//        cell.layer.shouldRasterize = false
        
        cell.layer.borderWidth = 10
        cell.layer.borderColor = ColorManager().colorFromRGBHexString("966C4D").CGColor //brown
        cell.layer.backgroundColor = ColorManager().colorFromRGBHexString("2E2E2E").CGColor //black
        cell.layer.cornerRadius = cell.frame.size.width/4.0
        cell.clipsToBounds = true

        cell.classNameLabel.text = dataArray[indexPath.row]
        
        if editClassHour {
        cell.alpha = 0.5
        } else {
        cell.alpha = 1.0
        }
        
        return cell
    }
}

//Mark - CollectionView Data source
extension MasterViewController {
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //Mark - Perform segue with identifier
        className = dataArray[indexPath.row]
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ClassCell
        print(collectionView.indexPathsForSelectedItems())
        
        if editClassHour {
            if cell.selected == true {
                //cell.layer.borderWidth = 10
                cell.alpha = 1.0
//            cell.layer.borderColor = UIColor.orangeColor().CGColor
//            deleteButtonTapped()
        }
        }
        else {
            self.performSegueWithIdentifier("MySegue", sender: cell)
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        print(collectionView.indexPathsForSelectedItems())
        collectionView.cellForItemAtIndexPath(indexPath) as! ClassCell
//        cell.alpha = 0.5
        }

    @IBAction func deleteButton(sender: UIBarButtonItem) {

        editClassHour = !editClassHour
        
        if editClassHour {
            self.deleteButton.title = "Delete"
        } else {
            self.deleteButton.title = "Select"
            print(dataArray)
            
            let paths = (collectionView?.indexPathsForSelectedItems())! as [NSIndexPath]
            let sortedArray = paths.sort() {$0.row > $1.row}
            
            for index in sortedArray {
                
                dataArray.removeAtIndex(index.row)
            }
        }
        collectionView?.reloadData()
    }

    func collectionView(collectionView: UICollectionView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        //Return false if you do not want the specified item to be editable.
            return true
    }

    //Mark - Button to Alert View for Class Name
    @IBAction func AddButton(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Class Name", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addTextFieldWithConfigurationHandler() { (textField:UITextField!) -> Void in
            textField.autocorrectionType = UITextAutocorrectionType.Yes;
            textField.autocapitalizationType = UITextAutocapitalizationType.Words
        }
        
        alertController.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.Default,handler: {(action) -> Void in
            let textf = alertController.textFields![0] as UITextField
            if let classNameStr = textf.text where !classNameStr.isEmpty {
                self.dataArray.append(classNameStr)
                self.collectionView!.reloadData()
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {(action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //Prepare for segue and pass data
        if segue.identifier == "MySegue" {
            NSNotificationCenter.defaultCenter().removeObserver(self)
            let indexPath = collectionView!.indexPathForCell(sender as! ClassCell)
            className = dataArray[indexPath!.row]
            let svc = segue.destinationViewController as! DeskViewController;
            svc.newVariable = className
        }
    }
}
    extension MasterViewController: UICollectionViewDelegateFlowLayout{
            
            func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
            {
                var collectionViewSize = collectionView.frame.size
                collectionViewSize.width = collectionViewSize.width/3.0 - 30.0 //Display Three elements in a row.
                collectionViewSize.height = collectionViewSize.height/4.0 - 30.0
                return collectionViewSize
            }
    }

