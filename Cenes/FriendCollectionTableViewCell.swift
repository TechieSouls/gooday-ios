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
        contentView.backgroundColor = themeColor;
        self.friendshorizontalColView.backgroundColor = themeColor;
        
        self.friendshorizontalColView.register(UINib(nibName: "SelectedFriendCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "SelectedFriendCollectionViewCell")
        
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
        if (self.friendsViewControllerDelegate.inviteFriendsDto.selectedFriendCollectionViewList.count != 0) {
            print("print : \(self.friendsViewControllerDelegate.inviteFriendsDto.selectedFriendCollectionViewList.count)")
            return self.friendsViewControllerDelegate.inviteFriendsDto.selectedFriendCollectionViewList.count;
        }
        return 0;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: SelectedFriendCollectionViewCell = friendshorizontalColView.dequeueReusableCell(withReuseIdentifier: "SelectedFriendCollectionViewCell", for: indexPath) as! SelectedFriendCollectionViewCell;
        
        if (self.friendsViewControllerDelegate.inviteFriendsDto.selectedFriendCollectionViewList.count != 0) {
            //let key = Array(self.friendsViewControllerDelegate.inviteFriendsDto.selectedFriendCollectionViewList.keys)[indexPath.row]
            let userContact = self.friendsViewControllerDelegate.inviteFriendsDto.selectedFriendCollectionViewList.reversed()[indexPath.row] as! CenesUserContactMO;
            print("Array : \(userContact)")
            
            if (userContact.user != nil || userContact.cenesMember == "yes") {
                
                cell.nonCenesUiViewLabel.isHidden = true;
                cell.profilePic.isHidden = false;
                if (userContact.user != nil && userContact.user!.photo != nil) {
                    cell.profilePic.sd_setImage(with: URL(string: userContact.user!.photo!), placeholderImage: UIImage(named: "profile_pic_no_image"))
                } else{
                    cell.profilePic.image = UIImage.init(named: "profile_pic_no_image");
                }
            } else {
                cell.nonCenesUiViewLabel.isHidden = false;
                cell.profilePic.isHidden = true;

                var nonCenesUserName: String = "";
                let nameSplitArr = userContact.name!.split(separator: " ");
                nonCenesUserName = String(nameSplitArr[0]).prefix(1).capitalized
                if (nameSplitArr.count > 1) {
                    nonCenesUserName.append(String(nameSplitArr[1]).prefix(1).capitalized);
                }
                cell.nonCenesUiViewLabel.text = nonCenesUserName;
            }
            
            if (userContact.user != nil && userContact.user!.name != nil) {
                
                cell.name.text = String(userContact.user!.name!);

            } else if (userContact.name != nil && userContact.name != "") {
                let firstName = userContact.name!.split(separator: " ")[0];
                cell.name.text = String(firstName);

            } else {
                let firstName = "Unknown \(String(userContact.userContactId))"
                cell.name.text = String(firstName);
            }
            
            if (userContact.user != nil && (userContact.user?.userId == self.friendsViewControllerDelegate.loggedInUser.userId)) {
                cell.removeFriendIcon.isHidden = true;
            } else {
                cell.removeFriendIcon.isHidden = false;
                let removeFriendIconTapGesture = RemoveFriendIconGesture(target: self, action: #selector(self.removeFriendIconPressed(sender: )));
                cell.removeFriendIcon.addGestureRecognizer(removeFriendIconTapGesture);
                if (userContact.userContactId != nil) {
                    removeFriendIconTapGesture.userContactId = Int(userContact.userContactId);
                    cell.tag = Int(userContact.userContactId);
                }
            }
        }
        return cell
    }
    
    @objc func removeFriendIconPressed(sender : RemoveFriendIconGesture) {
       // self.friendsViewControllerDelegate.inviteFriendsDto.selectedFriendCollectionViewList.removeValue(forKey: sender.userContactId);
        
        var count = 0;
        for selectedFriend in self.friendsViewControllerDelegate.inviteFriendsDto.selectedFriendCollectionViewList {
            if (selectedFriend.userContactId != nil && selectedFriend.userContactId == sender.userContactId) {
                self.friendsViewControllerDelegate.inviteFriendsDto.selectedFriendCollectionViewList.remove(at: count);
                break;
            }
            count = count + 1;
        }
        
        self.friendsViewControllerDelegate.inviteFriendsDto.checkboxStateHolder[sender.userContactId] = false;
        self.friendsViewControllerDelegate.refreshNavigationBarItems();
        self.friendsViewControllerDelegate.friendTableView.reloadData();
    }
}
class RemoveFriendIconGesture: UITapGestureRecognizer {
    var userContactId = Int();
}
