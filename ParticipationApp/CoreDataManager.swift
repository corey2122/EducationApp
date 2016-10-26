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
        do {
            try managedObjectContext.save()
        } catch {
            let fetchError = error as NSError
        }
                }
            }
        }
    }
    
//  Core Data: Desk View
    func addStudentsToClass(_ name: String, studentDtate: NSDate, key: String, activeClassKey: String?) {
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
                    newPerson.setValue(studentDtate, forKey: "studentDtate")
                    
                    print("made it here")
                    
                    let people = file.mutableSetValue(forKey: "people")
                    people.add(newPerson)
                    
                    save(file)
                }
            }
        }
    }

    func fetchStudent(activeClassKey: String?) -> [Person] {
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
                    print ("this was deleted \(student.key)")

                    do {
                        managedObjectContext.delete(student)
                        try managedObjectContext.save()
                    } catch {
                        fatalError("Could not delete person")
                    }
                }
            }
        }
    }
    
//  Core Data: Random Screen
    
    func addDataToStudent (comment: String, studentKey: String, key: String, activeClassKey: String, commentDate: NSDate, point: NSNumber) {
        for studentInfo in fetchStudent(activeClassKey: activeClassKey) {
            if let sKey = studentInfo.key {
                print ("sKey", sKey)
                if sKey == key {
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
    
    func fetchStudentData(key: String, activeClassKey: String?) -> [Selected]{
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
    
// Core Data: Student File Edit-save, delete -save.
    func deleteStudentInfo (activeClassKey: String, studentKey: String, key: String) {
        for studentInfo in fetchStudentData(key: studentKey, activeClassKey: activeClassKey) {
            print(studentKey)
            print(activeClassKey)
            
            if let fkey = studentInfo.key {
                if fkey == key {
                    managedObjectContext.delete(studentInfo)
                    try!managedObjectContext.save()
                }
            }
        }
    }
    
    func updateStudentName(name: String, activeClassKey: String, key: String){
            for student in fetchStudent(activeClassKey: activeClassKey) {
                print("key here")
                    if key == student.key {
                        student.setValue(name, forKey: "name")
                        
                        print("made it here11", name)
                        save(student)
            }
        }
    }
    
    func updateStudentData(comment: String, studentKey: String, key: String, activeClassKey: String, point: NSNumber) {
        
        for studentInfo in fetchStudent(activeClassKey: activeClassKey) {
            if let sKey = studentInfo.key, sKey == studentKey {
                print ("student key", sKey)
                
                if let studentUpdateArray = studentInfo.studentData as? Set<Selected> {
                    print("studentUpdateArray")
                    for studentUpdate in studentUpdateArray {
                        if let selectedKey = studentUpdate.key, selectedKey == key {
                            studentUpdate.setValue(comment, forKey: "comment")
                            studentUpdate.setValue(point, forKey: "point")
        
                            print("made it to addData", comment)
                            print(comment)
                            
                            save(studentInfo)
                        }
                    }
                }
            }
        }

        for studentUpdate in fetchStudentData(key: studentKey, activeClassKey: activeClassKey) {
            if let sKey = studentUpdate.value(forKey: "key"){
                print ("sKey", sKey)
                if sKey as? String == key {

                    print("made it to the new comment data ")
                    print(comment)
                    print(point)
  
                }
            }
        }
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
