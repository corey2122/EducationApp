//
//  MasterViewController.swift
//  ParticipationApp
//
//  Created by CJS  on 7/21/16.
//  Copyright © 2016 CJS . All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UICollectionViewController {

    @IBOutlet weak var addCancelButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    var editClassHour: Bool = false
    var flow = UICollectionViewFlowLayout()
    var dataArray = [NSManagedObject]()
    var coreDataManager = CoreDataManager()

    override func viewDidLoad() {
        super.viewDidLoad()
                print ("first")
        self.navigationItem.title = "Class"
        collectionView!.allowsMultipleSelection = true;

        flow = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        flow.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        dataArray = coreDataManager.fetchClass()
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    //cell information
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ClassCell
        let classHour = dataArray[(indexPath as NSIndexPath).row]
        
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
        cell.layer.borderColor = ColorManager().colorFromRGBHexString("966C4D").cgColor //brown
        cell.layer.backgroundColor = ColorManager().colorFromRGBHexString("2E2E2E").cgColor //black
        cell.layer.cornerRadius = cell.frame.size.width/4.0
        cell.clipsToBounds = true

        cell.classNameLabel!.text = classHour.value(forKey: "name") as? String
        
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
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Mark - Perform segue with identifier
        
        let cell = collectionView.cellForItem(at: indexPath) as! ClassCell
        print(collectionView.indexPathsForSelectedItems)
        
        if editClassHour {
            if cell.isSelected == true {
                cell.alpha = 1.0
        }
        } else {
            self.performSegue(withIdentifier: "MySegue", sender: cell)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print(collectionView.indexPathsForSelectedItems)
        collectionView.cellForItem(at: indexPath) as! ClassCell
        }

    @IBAction func deleteButton(_ sender: UIBarButtonItem) {

        editClassHour = !editClassHour
        
        if editClassHour {
            self.deleteButton.title = "Delete"
            addCancelButton.title = "Cancel"
                
        } else {
            self.deleteButton.title = "Select"
            addCancelButton.title = "Add"
            print(dataArray)
            
            let paths = (collectionView?.indexPathsForSelectedItems)! as [IndexPath]
            let sortedArray = paths.sorted() {($0 as NSIndexPath).row > ($1 as NSIndexPath).row}
           
            
            for index in sortedArray {
                let person = dataArray[(index as NSIndexPath).row]
                if let personKey = person.value(forKey: "key") {
                    coreDataManager.deleteClassHour(_key: personKey as! String)
                    dataArray.remove(at: (index as NSIndexPath).row)
                    print ("one")
                }
            }
        }
        
        collectionView?.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, canEditRowAtIndexPath indexPath: IndexPath) -> Bool {
        //Return false if you do not want the specified item to be editable.
            return true
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
    //Mark - Button to Alert View for Class Name
    @IBAction func AddButton(_ sender: UIBarButtonItem) {
        
        if !editClassHour {
        
        let alertController = UIAlertController(title: "Class Name", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addTextField() { (textField:UITextField!) -> Void in
            textField.autocorrectionType = UITextAutocorrectionType.yes;
            textField.autocapitalizationType = UITextAutocapitalizationType.words
        }
        
        alertController.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.default,handler: {(action) -> Void in
            let textf = alertController.textFields![0] as UITextField
            if let classNameStr = textf.text , !classNameStr.isEmpty {
                //self.saveName(textf.text!)
                self.coreDataManager.saveClassHour(textf.text!, key: self.randomString(length: 10))
                //Add NSManagedObject to an Array
                self.dataArray.removeAll()
                self.dataArray = self.coreDataManager.fetchClass()
                self.collectionView!.reloadData()
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {(action) -> Void in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertController, animated: true, completion: nil)
        } else {
            editClassHour = !editClassHour
            addCancelButton.title = "Add"
            self.deleteButton.title = "Select"
            collectionView?.reloadData()
        }
}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Prepare for segue and pass data
        if segue.identifier == "MySegue" {
            NotificationCenter.default.removeObserver(self)
            let indexPath = collectionView!.indexPath(for: sender as! ClassCell)
            let className = dataArray[(indexPath! as NSIndexPath).row]
            let svc = segue.destination as! DeskViewController;
            svc.newVariable = (className.value(forKey: "name") as! String?)!
            svc.activeClassKey = (className.value(forKey: "key") as! String?)!
        }
    }
}
    extension MasterViewController: UICollectionViewDelegateFlowLayout{
            
            func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
            {
                var collectionViewSize = collectionView.frame.size
                collectionViewSize.width = collectionViewSize.width/3.0 - 30.0 //Display Three elements in a row.
                collectionViewSize.height = collectionViewSize.height/4.0 - 30.0
                return collectionViewSize
            }
    }
