//
//  MeTimeFriendsView.swift
//  Cenes
//
//  Created by Cenes_Dev on 28/04/2020.
//  Copyright © 2020 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class MeTimeFriendsView: UIView {

    @IBOutlet weak var profilePicBackgroundView: UIView!;
    @IBOutlet weak var profilePicPlaceholder: UIImageView!;
    @IBOutlet weak var addMoreFriendsIcon: UIImageView!;

    @IBOutlet weak var metimeFriendlistView: UIView!
    @IBOutlet weak var friendlistCollectionView: UICollectionView!
    
    var recurringEventMembers: [RecurringEventMember]!;
    
    class func instanceFromNib() -> UIView {
        var meTimeFriendsView = UINib(nibName: "MeTimeFriendsView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MeTimeFriendsView;
        
        meTimeFriendsView.friendlistCollectionView.register(UINib.init(nibName: "MeTimeFriendsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MeTimeFriendsCollectionViewCell");
        return meTimeFriendsView;
    }

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        profilePicBackgroundView.roundedView();
        profilePicPlaceholder.setRounded();        
    }
    
    
}

extension MeTimeFriendsView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (recurringEventMembers == nil) {
            return 0;
        }
        return recurringEventMembers.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (recurringEventMembers == nil || recurringEventMembers.count == 0) {
            return UICollectionViewCell();
        }
        let metimeFriendListItem = recurringEventMembers[indexPath.row];
        let metimeFriend = metimeFriendListItem.user;
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MeTimeFriendsCollectionViewCell", for: indexPath) as! MeTimeFriendsCollectionViewCell;
        
        if (metimeFriend != nil) {
            
            cell.name.text = metimeFriend?.name;
            if (metimeFriend?.photo != nil && metimeFriend?.photo != "") {
                cell.profilePic.sd_setImage(with: URL.init(string: metimeFriend!.photo), placeholderImage: UIImage.init(named: "profile_pic_no_image"), completed: nil)
            } else {
                cell.profilePic.image = UIImage.init(named: "profile_pic_no_image");
            }
        }
        
        return cell;
    }
}

