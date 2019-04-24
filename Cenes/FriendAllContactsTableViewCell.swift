//
//  FriendAllContactsTableViewCell.swift
//  Deploy
//
//  Created by Cenes_Dev on 16/04/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class FriendAllContactsTableViewCell: UITableViewCell {

    @IBOutlet weak var nonCenesUserView: UIView!
    
    @IBOutlet weak var hostGradientImage: UIImageView!
    
    @IBOutlet weak var nonCenesUserNameLabel: UILabel!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var separator: UIView!
    
    @IBOutlet weak var profilePic: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.backgroundColor = themeColor;
        profilePic.setRoundedWhiteBorder()
        nonCenesUserView.roundedUIViewWhiteBorderGreyBackground();
        separator.fadedSeparator();
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = themeColor;
    }
}
