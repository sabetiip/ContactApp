//
//  DBHandler.swift
//  ContactApp
//
//  Created by Somayeh Sabeti on 9/5/20.
//  Copyright © 2020 Somayeh Sabeti. All rights reserved.
//

import Foundation
import CoreData

class DBHandler {
    
    static let shared = DBHandler()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ContactApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
