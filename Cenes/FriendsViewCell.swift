//
//  FriendsViewCell.swift
//  Cenes
//
//  Created by Redblink on 06/10/17.
//  Copyright © 2017 Redblink Pvt Ltd. All rights reserved.
//

import UIKit
import  IoniconsSwift

protocol DeleteFriendDelegate {
    func deleteCell(cell: FriendsViewCell)
}

class FriendsViewCell: UICollectionViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var crossButotn: UIButton!
    
    @IBOutlet weak var nonCenesUserView: UIView!
    
    @IBOutlet weak var nonCenesUserName: UILabel!
    
    
    //var cellThree : GatheringPeopleTableViewCell!
        
    var indexPath : IndexPath!
    var delegate: DeleteFriendDelegate?
    
    var cellDiary : DiaryCellOne!
    
    @IBOutlet weak var backWhiteView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        crossButotn.setImage(Ionicons.iosCloseOutline.image(24, color: UIColor.black), for: .normal)
        self.nonCenesUserView.roundedView();
        self.nonCenesUserView.backgroundColor = themeColor;
    }

    @IBAction func crossButtonPressed(_ sender: UIButton) {
        
        if delegate != nil {
            self.delegate?.deleteCell(cell: self)
        }
        else {
            /*if self.cellThree != nil {
                self.cellThree.deleteCEll(tag: sender.tag,cell:self)
            }*/
            if self.cellDiary != nil {
                self.cellDiary.deleteCEll(tag: sender.tag,cell:self)
            }
            
        }
    }
}
