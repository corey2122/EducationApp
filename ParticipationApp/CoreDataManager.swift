//
//  CoreDataManager.swift
//  ParticipationApp
//
//  Created by CJS  on 9/24/16.
//  Copyright © 2016 CJS . All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    let managedObjectContext = AppDelegate().managedObjectContext
    //create array of NSManaged Objects - Method that returns an array of (fetchfiles)...loops thru array
    
    //Core Data: Class
    func saveClassHour(_ name: String, key: String) {
        let entity =  NSEntityDescription.entity(forEntityName: "ClassHour",
                                                 in:managedObjectContext)
        
        let classHour = NSManagedObject(entity: entity!,
                                        insertInto: managedObjectContext)
        
        classHour.setValue(name, forKey: "name")
        classHour.setValue(key, forKey: "key")
        
        save(classHour)
    }
    
    func fetchClass() -> [NSManagedObject] {
    //1
        var managedObjectArray = [NSManagedObject]()
        let fetchRequest = NSFetchRequest<ClassHour>(entityName: "ClassHour")

        do {
            managedObjectArray = try self.managedObjectContext.fetch(fetchRequest)
        } catch {
            let fetchError = error as NSError
        }
    return managedObjectArray
    }

    func deleteClassHour (_key: String) {
    for obj in fetchClass() {
    if let fKey = obj.value(forKey:"key"){
    if fKey as! String == _key {
        managedObjectContext.delete(obj)
        try!managedObjectContext.save()
                }
            }
        }
    }
//  Core Data: Desk View
    func addStudentsToClass(_ name: String, key: String, activeClassKey: String?) {
        print (key, "key")
        print(activeClassKey, "activeClassKey")
        for file in fetchClass() {
        if let fKey = file.value(forKey: "key"){
                print ("fkey", fKey)
                if fKey as? String == activeClassKey {
                    let entityStudents = NSEntityDescription.entity(forEntityName: "Person", in: managedObjectContext)
                    let newPerson = NSManagedObject(entity: entityStudents!, insertInto: managedObjectContext)
          
                    newPerson.setValue(key, forKey: "key")
                    newPerson.setValue(name, forKey: "name")
                    
                    print("made it here")
                    
                    let people = file.mutableSetValue(forKey: "people")
                    people.add(newPerson)
                    
                    save(file)
                }
            }
    }
}

    func fetchStudent(activeClassKey: String?) -> [Person]{
        var managedObjectArray = Set<Person>()
        
        for file in fetchClass() {
            if let fKey = file.value(forKey: "key"){
                if fKey as? String == activeClassKey {
                managedObjectArray = file.value(forKey: "people") as! Set<Person>
                }
            }
        }

        return Array(managedObjectArray)
    }
    
    func deletePerson (activeClassKey: String, studentKey: String) {
        for student in fetchStudent(activeClassKey: activeClassKey) {
            if let fkey = student.key { 
                if fkey == studentKey {
                managedObjectContext.delete(student)
                try!managedObjectContext.save()
                }
            }
        }
    }
    
//  Core Data: Random Screen
    
    func addDataToStudent (comment: String, studentKey: String, key: String, activeClassKey: String, commentDate: NSDate, point: NSNumber) {
        for studentInfo in fetchStudent(activeClassKey: activeClassKey) {
            if let sKey = studentInfo.value(forKey: "key"){
                print ("sKey", sKey)
                if sKey as? String == key {
                    let entityData = NSEntityDescription.entity (forEntityName: "Selected", in: managedObjectContext)
                    let newData = NSManagedObject(entity: entityData!, insertInto: managedObjectContext)
                    
                    newData.setValue(comment, forKey: "comment")
                    newData.setValue(studentKey, forKey: "key")
                    newData.setValue(commentDate, forKey: "commentDate")
                    newData.setValue(point, forKey: "point")
                    
                    print("made it to addData")
                    
                    let newInfo = studentInfo.mutableSetValue(forKey: "studentData")
                    newInfo.add(newData)
                    
                    print(comment)
                    print(commentDate)
                    
                    save(studentInfo)
                }
            }
        }
    }
    
// Core Data: Student File 
    
    func fetchStudentData(studentKey: String, key: String, activeClassKey: String?) -> [Selected]{
        var managedObjectArray = Set<Selected>()

        for studentInfo in fetchStudent(activeClassKey: activeClassKey) {
            if let sKey = studentInfo.value(forKey: "key"){
                print ("sKey", sKey)
                if sKey as? String == key {
                   
                        managedObjectArray = studentInfo.value(forKey: "studentData") as! Set<Selected>

            }
        }
        }
        return Array(managedObjectArray)
    }
    
    func save(_ managedObject: NSManagedObject) {
        do {
            try managedObject.managedObjectContext?.save()
            print ("comment")
        } catch {
            fatalError("Could not save NSManagedObject")
        }
    }
}

