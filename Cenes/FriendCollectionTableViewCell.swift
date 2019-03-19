//
//  FriendCollectionTableViewCell.swift
//  Deploy
//
//  Created by Cenes_Dev on 04/03/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class FriendCollectionTableViewCell: UITableViewCell {

    @IBOutlet weak var friendshorizontalColView: UICollectionView!;

    var selectedFriendHolder : [Int: EventMember]!;
    var friendsViewControllerDelegate: FriendsViewController!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.friendshorizontalColView.register(UINib(nibName: "FriendsViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "friendCell")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension FriendCollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (self.friendsViewControllerDelegate.selectedFriendHolder != nil) {
            print("print : \(self.friendsViewControllerDelegate.selectedFriendHolder.count)")
            return self.friendsViewControllerDelegate.selectedFriendHolder.count;
        }
        return 0;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = friendshorizontalColView.dequeueReusableCell(withReuseIdentifier: "friendCell", for: indexPath) as! FriendsViewCell;
        
        if (self.friendsViewControllerDelegate.selectedFriendHolder != nil) {
            print("row Number : \(indexPath.row)")
            let key = Array(self.friendsViewControllerDelegate.selectedFriendHolder.keys)[indexPath.row]
            let userContact = self.friendsViewControllerDelegate.selectedFriendHolder[key] as! EventMember;
            print("Array : \(userContact)")
            
            if (userContact.cenesMember == "yes") {
                
                cell.nonCenesUserView.isHidden = true;
                cell.profileImage.isHidden = false;
                if (userContact.user != nil && userContact.user.photo != nil) {
                    cell.profileImage.sd_setImage(with: URL(string: userContact.user.photo), placeholderImage: UIImage(named: "cenes_user_no_image"))
                } else{
                    cell.profileImage.image = #imageLiteral(resourceName: "cenes_user_no_image")
                }
            } else {
                cell.nonCenesUserView.isHidden = false;
                cell.profileImage.isHidden = true;

                var nonCenesUserName: String = "";
                let nameSplitArr = userContact.name.split(separator: " ");
                nonCenesUserName = String(nameSplitArr[0])[0..<1].capitalized
                if (nameSplitArr.count > 1) {
                    nonCenesUserName.append(String(nameSplitArr[1])[0..<1].capitalized);
                }
                cell.nonCenesUserName.text = nonCenesUserName;
            }
            
            cell.nameLabel.text = userContact.name;
            cell.tag = Int(userContact.userContactId);
        }
        
        //cell.inviteFriendCtrl = self;
        return cell
    }
}
