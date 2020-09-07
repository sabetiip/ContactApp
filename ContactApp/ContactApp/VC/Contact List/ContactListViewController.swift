//
//  ContactListViewController.swift
//  ContactApp
//
//  Created by Somayeh Sabeti on 8/26/20.
//  Copyright © 2020 Somayeh Sabeti. All rights reserved.
//

import UIKit

class ContactListViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.allowsMultipleSelectionDuringEditing = true
            tableView.register(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactTableCell")
        }
    }
    
    var viewModel = ContactListViewModel()
    var isEditingMode = false
    var isFavoriteMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editAction(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "starNavItemFill"), style: .done, target: self, action: #selector(showFavoriteList(_:)))
        
        viewModel.loadContacts()
    }
    
    //MARK: - Action Methods
    @IBAction func editAction(_ sender: UIBarButtonItem) {
        isEditingMode = !isEditingMode
        if isEditingMode {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editAction(_:)))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editAction(_:)))
        }
        tableView.reloadData()
    }
    
    @IBAction func showFavoriteList(_ sender: Any) {
        isFavoriteMode = !isFavoriteMode
        if isFavoriteMode {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "starNavItem"), style: .done, target: self, action: #selector(showFavoriteList(_:)))
            viewModel.favoriteContacts()
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "starNavItemFill"), style: .done, target: self, action: #selector(showFavoriteList(_:)))
            viewModel.filterContacts(text: "")
        }
        tableView.reloadData()
    }
}

//MARK: - UITableView DataSource & Delegate
extension ContactListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filterContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableCell") as! ContactTableViewCell
        cell.favoriteButton.isHidden = !isEditingMode

        let contact = viewModel.filterContacts[indexPath.row]
        cell.contact = contact
        cell.toggleFavoriteMode = { [weak self] in
            guard let self = self else { return }
            self.viewModel.toggleFavoriteContactAt(index: indexPath.row)
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let phoneNumber = viewModel.filterContacts[indexPath.row].phoneNumbers?.first,
            let url = URL(string: "tel://\(phoneNumber)"),
            UIApplication.shared.canOpenURL(url) {
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}

//MARK: - UITableView DataSource & Delegate
extension ContactListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterContacts(text: searchText)
        tableView.reloadData()
    }
}
