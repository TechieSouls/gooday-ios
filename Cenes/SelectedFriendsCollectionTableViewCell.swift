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
    
    @IBOutlet weak var addMoreFriendsView: UIView!
    
    var createGatheringDelegate: CreateGatheringV2ViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        var viewTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(addMoreFriendsPressed));
        addMoreFriendsView.addGestureRecognizer(viewTapGesture);
        
        selectedFriendsColView.register(UINib(nibName: "FriendCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "FriendCollectionViewCell")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func addMoreFriendsPressed() {
        createGatheringDelegate.openGuestListViewController();
    }
}

extension SelectedFriendsCollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return createGatheringDelegate.event.eventMembers.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FriendCollectionViewCell = selectedFriendsColView.dequeueReusableCell(withReuseIdentifier: "FriendCollectionViewCell", for: indexPath) as! FriendCollectionViewCell;
        
        let eventMember = createGatheringDelegate.event.eventMembers[indexPath.row];
        
        if (eventMember.user != nil) {
            cell.name.text = String(eventMember.user.name.split(separator: " ")[0]);
        } else if (eventMember.name != nil) {
            cell.name.text = String(eventMember.name);
        } else {
            cell.name.text = "Unknown";
        }
        
        if (eventMember.user != nil && eventMember.user.photo != nil) {
            cell.profilePic.isHidden = false;
            cell.nonCenesUserView.isHidden = true;
            cell.profilePic.sd_setImage(with: URL(string: eventMember.user.photo), placeholderImage: UIImage.init(named: "profile_pic_no_image"));
        } else {
            
            //Here we will check. If user is cenes member and has image then we will set it.
            //If user is not a cenes member yet, then we will show first two letters
            //of name as its label.
            cell.profilePic.isHidden = true;
            cell.nonCenesUserView.isHidden = false;
            
            var nonCenesUserName: String = "";
            var nameSplitArr : [ArraySlice<Character>]!;
            if (eventMember.user != nil) {
               nameSplitArr =  eventMember.user.name.split(separator: " ");
            } else if (eventMember.name != nil) {
                nameSplitArr = eventMember.name.split(separator: " ");
            }
            nonCenesUserName = String(nameSplitArr[0]).prefix(1).capitalized
            if (nameSplitArr.count > 1) {
                
                let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
                //If string contains valid characters, then goes in if loop
                if String(nameSplitArr[1]).prefix(1).rangeOfCharacter(from: characterset.inverted) == nil {
                    nonCenesUserName.append(String(nameSplitArr[1]).prefix(1).capitalized);
                } else {
                    //If string containts speacial character, then we will check if there is anymore strnig
                    //available, If yes then we will chekc for third string.
                    if (nameSplitArr.count > 2) {
                        if String(nameSplitArr[2]).prefix(1).rangeOfCharacter(from: characterset.inverted) == nil {
                            nonCenesUserName.append(String(nameSplitArr[2]).prefix(1).capitalized);
                        } else {
                            nonCenesUserName.append(String(nameSplitArr[2]).prefix(1).capitalized);
                        }
                    } else {
                        nonCenesUserName.append(String(nameSplitArr[1]).prefix(1).capitalized);
                    }
                }
            }
            cell.nonCenesUserLabel.text = nonCenesUserName;            
        }
        return cell;
    }
}
