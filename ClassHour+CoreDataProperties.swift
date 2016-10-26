//
//  ClassHour+CoreDataProperties.swift
//  ParticipationApp
//
//  Created by CJS  on 10/10/16.
//  Copyright © 2016 CJS . All rights reserved.
//

import Foundation
import CoreData

extension ClassHour {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ClassHour> {
        return NSFetchRequest<ClassHour>(entityName: "ClassHour");
    }

    @NSManaged public var key: String?
    @NSManaged public var name: String?
    @NSManaged public var people: NSSet?

}

// MARK: Generated accessors for people
extension ClassHour {

    @objc(addPeopleObject:)
    @NSManaged public func addToPeople(_ value: Person)

    @objc(removePeopleObject:)
    @NSManaged public func removeFromPeople(_ value: Person)

    @objc(addPeople:)
    @NSManaged public func addToPeople(_ values: NSSet)

    @objc(removePeople:)
    @NSManaged public func removeFromPeople(_ values: NSSet)

}
