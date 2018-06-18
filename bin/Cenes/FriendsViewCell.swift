//
//  FriendsViewCell.swift
//  Cenes
//
//  Created by Redblink on 06/10/17.
//  Copyright © 2017 Redblink Pvt Ltd. All rights reserved.
//

import UIKit
import  IoniconsSwift

class FriendsViewCell: UICollectionViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var crossButotn: UIButton!
    
    var cellThree : GatheringTableViewCellThree!
    var cellFour : CreateReminderCellFour!
    var indexPath : IndexPath!
    @IBOutlet weak var backWhiteView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        crossButotn.setImage(Ionicons.iosCloseOutline.image(24, color: UIColor.black), for: .normal)
    }

    @IBAction func crossButtonPressed(_ sender: UIButton) {
        print(sender.tag)
        if self.cellThree != nil {
            self.cellThree.deleteCEll(tag: sender.tag,cell:self)
        }
        if self.cellFour != nil {
            self.cellFour.deleteCEll(tag: sender.tag,cell:self)
        }
    }
    
    
}
