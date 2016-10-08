//
//  Person+CoreDataProperties.swift
//  ParticipationApp
//
//  Created by CJS  on 10/4/16.
//  Copyright © 2016 CJS . All rights reserved.
//

import Foundation
import CoreData

extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person");
    }

    @NSManaged public var key: String?
    @NSManaged public var name: String?
    @NSManaged public var classHour: ClassHour?
    @NSManaged public var studentData: NSSet?

}

// MARK: Generated accessors for studentData
extension Person {

    @objc(addStudentDataObject:)
    @NSManaged public func addToStudentData(_ value: Selected)

    @objc(removeStudentDataObject:)
    @NSManaged public func removeFromStudentData(_ value: Selected)

    @objc(addStudentData:)
    @NSManaged public func addToStudentData(_ values: NSSet)

    @objc(removeStudentData:)
    @NSManaged public func removeFromStudentData(_ values: NSSet)

}
