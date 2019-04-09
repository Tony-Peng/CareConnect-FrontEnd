//
//  PersonTableViewCell.swift
//  CareConnectGiver
//
//  Created by Andre Hijaouy on 4/8/19.
//  Copyright © 2019 Tony. All rights reserved.
//

import UIKit

class PersonTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    
    var person: Person? {
        didSet {
            self.nameLabel.text = person?.name
            self.profilePic.image = person?.picture
            self.loadProfilePicture()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.loadProfilePicture()
        print("Does this not get called")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadProfilePicture() {
        self.profilePic.layer.borderWidth = 1
        self.profilePic.layer.masksToBounds = false
        self.profilePic.layer.borderColor = UIColor.white.cgColor
        self.profilePic.layer.cornerRadius = self.profilePic.frame.height / 2
        self.profilePic.clipsToBounds = true
    }
    
    
}
