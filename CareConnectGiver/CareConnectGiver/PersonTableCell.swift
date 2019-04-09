//
//  PeopleTableCell.swift
//  CareConnectGiver
//
//  Created by Andre Hijaouy on 4/8/19.
//  Copyright © 2019 Tony. All rights reserved.
//

import Foundation
import UIKit

class PersonTableCell : UITableViewCell {
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var personNameLabel: UILabel!
    var person: Person? {
        didSet {
//            profilePic.image = person?.picture
//            personNameLabel.text = person?.name
//            personNameLabel.text = "Andre"
        }
    }
    
//    private let personImage : UIImageView = {
//        let imgView = UIImageView(image: #imageLiteral(resourceName: "ruby"))
//        imgView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//        imgView.contentMode = .scaleAspectFit
//        imgView.clipsToBounds = true
//        imgView.layer.borderWidth = 1
//        imgView.layer.masksToBounds = false
//        imgView.layer.borderColor = UIColor.black.cgColor
//        imgView.layer.cornerRadius = 25
//        return imgView
//    }()
    
//    func loadPicture(name: String) -> UIImage
    
//    private let personNameLabel : UILabel = {
//        let lbl = UILabel()
//        lbl.textColor = .black
//        lbl.font = UIFont.boldSystemFont(ofSize: 16)
//        lbl.textAlignment = .center
//        return lbl
//    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        addSubview(personImage)
//        addSubview(personNameLabel)
        
//        personImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 90, height: 0, enableInsets: false)
//        personNameLabel.anchor(top: topAnchor, left: productImage.rightAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: frame.size.width / 2, height: 0, enableInsets: false)
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
