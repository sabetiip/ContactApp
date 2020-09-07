//
//  ContactListViewModel.swift
//  ContactApp
//
//  Created by Somayeh Sabeti on 9/5/20.
//  Copyright © 2020 Somayeh Sabeti. All rights reserved.
//

import Foundation

class ContactListViewModel {
    
    var contacts: [Contacts] = []
    
    var filterContacts: [Contacts] = []
    
    func loadContacts() {
        contacts = Contacts.loadContacts() ?? []
        filterContacts = contacts
    }
    
    func filterContacts(text: String) {
        filterContacts = text.isEmpty ? contacts : contacts.filter({ ($0.name?.contains(text) ?? false) })
    }
    
    func favoriteContacts() {
        filterContacts = contacts.filter({ $0.isFavorite })
    }
    
    func toggleFavoriteContactAt(index: Int) {
        filterContacts[index].isFavorite = !filterContacts[index].isFavorite
        if let baseIndex = contacts.firstIndex(where: { $0.id == filterContacts[index].id }) {
            contacts[baseIndex] = filterContacts[index]
        }
    }
}
