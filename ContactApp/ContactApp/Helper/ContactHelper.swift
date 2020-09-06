//
//  ContactHelper.swift
//  ContactApp
//
//  Created by Somayeh Sabeti on 9/5/20.
//  Copyright © 2020 Somayeh Sabeti. All rights reserved.
//

import Foundation
import Contacts

typealias Failure = ()

class ContactHelper {
    
    private init() {}
    static var shared: ContactHelper {
        return ContactHelper()
    }
    
    func checkAuthorizeAndGetContacts() {
        let store = CNContactStore()
        let authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
        
        switch authorizationStatus {
        case .notDetermined:
            store.requestAccess(for: .contacts) { [weak self] didAuthorize,
                error in
                if didAuthorize {
                    self?.loadContactAndSaveInDB()
                }
            }
        
        case .authorized:
            loadContactAndSaveInDB()
            
        case .denied:
            //TODO: show view for get access to continue in this app
            break
            
        default:
            break
        }
    }
    
    private func loadContactAndSaveInDB() {
        let contactStore = CNContactStore()
        let keysToFetch = [CNContactIdentifierKey,
                           CNContactGivenNameKey,
                           CNContactFamilyNameKey,
                           CNContactPhoneNumbersKey,
                           CNContactEmailAddressesKey,
                           CNContactThumbnailImageDataKey,
                           CNContactImageDataKey]
        var allContainers : [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
            var result = [CNContact]()
            for container in allContainers {
                let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
                do {
                    let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as [CNKeyDescriptor])
                    result.append(contentsOf: containerResults)
                    Contacts.insertContacts(array: result)
                    
                } catch {
                    debugPrint("Can't fetch contacts")
                }
            }
        } catch {
            debugPrint("Can't fetch contacts")
        }
    }
}
