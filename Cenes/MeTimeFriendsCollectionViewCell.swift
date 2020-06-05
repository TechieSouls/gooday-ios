//
//  MeTimeFriendsCollectionViewCell.swift
//  Cenes
//
//  Created by Cenes_Dev on 28/04/2020.
//  Copyright © 2020 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class MeTimeFriendsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var profilePicBackgroundView: UIView!;
    @IBOutlet weak var profilePic: UIImageView!;
    @IBOutlet weak var name: UILabel!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profilePicBackgroundView.roundedView();
        profilePic.setRounded();
    }

}
