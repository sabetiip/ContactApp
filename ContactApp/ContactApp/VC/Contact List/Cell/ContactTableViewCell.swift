//
//  ContactTableViewCell.swift
//  ContactApp
//
//  Created by Somayeh Sabeti on 8/26/20.
//  Copyright © 2020 Somayeh Sabeti. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var contactPhoneLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var toggleFavoriteMode: (() -> Void)?
    
    var contact: Contacts? {
        didSet {
            guard let contact = contact else { return }
            
            if let data = contact.thumbnail {
                contactImageView.image = UIImage(data: data as Data)
            } else {
                contactImageView.image = nil
            }
            
            if let name = contact.name, !name.isEmpty {
                contactNameLabel.text = name
            } else {
                contactNameLabel.text = contact.phoneNumbers?.first
            }
            
            contactPhoneLabel.text = contact.phoneNumbers?.first
            
            favoriteButton.setImage(contact.isFavorite ? #imageLiteral(resourceName: "starFill") : #imageLiteral(resourceName: "star"), for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contactImageView.layer.cornerRadius = contactImageView.frame.width / 2
        contactImageView.clipsToBounds = true
    }
    
    @IBAction func favoriteAction(_ sender: Any) {
        toggleFavoriteMode?()
    }
}
