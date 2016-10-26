//
//  Selected+CoreDataProperties.swift
//  ParticipationApp
//
//  Created by CJS  on 10/10/16.
//  Copyright © 2016 CJS . All rights reserved.
//

import Foundation
import CoreData
 

extension Selected {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Selected> {
        return NSFetchRequest<Selected>(entityName: "Selected");
    }

    @NSManaged public var comment: String?
    @NSManaged public var commentDate: NSDate?
    @NSManaged public var key: String?
    @NSManaged public var point: NSNumber?
    @NSManaged public var savedData: Person?

}
