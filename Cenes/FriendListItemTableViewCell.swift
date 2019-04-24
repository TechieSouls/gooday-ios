//
//  FriendListItemTableViewCell.swift
//  Deploy
//
//  Created by Cenes_Dev on 03/03/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class FriendListItemTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneBookName: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var unselectedProfilePic: UIImageView!
        
    @IBOutlet weak var cenesUserSelectedView: UIView!
    
    @IBOutlet weak var cenesUserUnselectedView: UIView!
    
    @IBOutlet weak var separator: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.backgroundColor = themeColor;
        
        self.profileImageView.setRounded();
        
        self.unselectedProfilePic.layer.borderColor = UIColor.white.cgColor;
        self.unselectedProfilePic.layer.borderWidth = 2;
        self.unselectedProfilePic.setRounded();
        
        separator.fadedSeparator();
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
