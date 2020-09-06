//
//  Contacts+CoreDataProperties.swift
//  ContactApp
//
//  Created by Somayeh Sabeti on 9/5/20.
//  Copyright © 2020 Somayeh Sabeti. All rights reserved.
//
//

import Foundation
import CoreData

extension Contacts {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contacts> {
        return NSFetchRequest<Contacts>(entityName: "Contacts")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var phoneNumbers: [String]?
    @NSManaged public var picture: NSData?
    @NSManaged public var thumbnail: NSData?
}
