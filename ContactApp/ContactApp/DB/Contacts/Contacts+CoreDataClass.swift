//
//  Contacts+CoreDataClass.swift
//  ContactApp
//
//  Created by Somayeh Sabeti on 9/5/20.
//  Copyright © 2020 Somayeh Sabeti. All rights reserved.
//
//

import Foundation
import CoreData
import Contacts

public class Contacts: NSManagedObject {
    
    var isFavorite = false
    
    static func insertContacts(array : [CNContact]) {
        array.forEach{ (item) in
            if !existContactInDB(id: item.identifier) {
                let newContact = NSEntityDescription.insertNewObject(forEntityName: "Contacts", into: DBHandler.shared.persistentContainer.viewContext) as? Contacts
                newContact?.id = item.identifier
                newContact?.name = item.givenName + " " + item.familyName
                newContact?.email = item.emailAddresses.first?.value as String?
                newContact?.phoneNumbers = item.phoneNumbers.map({ $0.value.stringValue })
                if let thumbnailData = item.thumbnailImageData {
                    newContact?.thumbnail = NSData.init(data: thumbnailData)
                }
                if let imageData = item.imageData {
                    newContact?.picture = NSData.init(data: imageData)
                }
            }
        }
        DBHandler.shared.saveContext()
    }
    
    static func loadContacts(id: String? = nil) -> [Contacts]? {
        let request: NSFetchRequest<Contacts> = Contacts.fetchRequest()
        if let id = id {
            request.predicate = NSPredicate(format: "\(#keyPath(Contacts.id)) == '\(id)'")
        }
        do {
            let array = try DBHandler.shared.persistentContainer.viewContext.fetch(request)
            return array
        } catch {
            print("error fetching result from core data")
            return nil
        }
    }
    
    static func existContactInDB(id: String) -> Bool {
        if let list = loadContacts(id: id), !list.isEmpty {
            return true
        }
        return false
    }
}
