//
//  SelectedFriendCollectionViewCell.swift
//  Deploy
//
//  Created by Cenes_Dev on 16/04/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class SelectedFriendCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nonCenesUIView: UIView!
    
    @IBOutlet weak var nonCenesUiViewLabel: UILabel!

    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var removeFriendIcon: UIImageView!
    
    @IBOutlet weak var name: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profilePic.setRounded();
        nonCenesUIView.roundedUIViewGreyBackground()
        
    }

}
