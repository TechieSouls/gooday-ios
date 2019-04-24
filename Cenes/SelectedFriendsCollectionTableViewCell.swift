//
//  SelectedFriendsCollectionTableViewCell.swift
//  Deploy
//
//  Created by Cenes_Dev on 19/04/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class SelectedFriendsCollectionTableViewCell: UITableViewCell {

    @IBOutlet weak var selectedFriendsColView: UICollectionView!
    
    var createGatheringDelegate: CreateGatheringV2ViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectedFriendsColView.register(UINib(nibName: "FriendCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "FriendCollectionViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension SelectedFriendsCollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return createGatheringDelegate.event.eventMembers.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FriendCollectionViewCell = selectedFriendsColView.dequeueReusableCell(withReuseIdentifier: "FriendCollectionViewCell", for: indexPath) as! FriendCollectionViewCell;
        
        let eventMember = createGatheringDelegate.event.eventMembers[indexPath.row];
        
        cell.name.text = String(eventMember.name.split(separator: " ")[0]);
        
        if (eventMember.user != nil && eventMember.user.photo != nil) {
            cell.profilePic.sd_setImage(with: URL(string: eventMember.user.photo), placeholderImage: UIImage.init(named: "profile_pic_no_image"));
        }
        return cell;
    }
}
