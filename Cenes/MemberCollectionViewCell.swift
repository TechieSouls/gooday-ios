//
//  MemberCollectionViewCell.swift
//  Deploy
//
//  Created by Macbook on 22/01/19.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class MemberCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var guestLabel: UILabel!
    
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profilePic.setRounded();
    }

}
