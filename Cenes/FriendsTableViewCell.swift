//
//  FriendsTableViewCell.swift
//  Deploy
//
//  Created by Cenes_Dev on 04/03/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var friendListInnerTable: UITableView!

    var friendViewControllerDelegate: FriendsViewController!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contentView.backgroundColor = themeColor;
        
        self.friendListInnerTable.backgroundColor = themeColor;
        self.friendListInnerTable.sectionIndexColor = UIColor.darkGray;
        
        self.friendListInnerTable.register(UINib(nibName: "FriendListItemTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "FriendListItemTableViewCell");
        
        self.friendListInnerTable.register(UINib(nibName: "FriendAllContactsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "FriendAllContactsTableViewCell");
        
         self.friendListInnerTable.register(UINib(nibName: "InnerTableHeaderTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "InnerTableHeaderTableViewCell");
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

extension FriendsTableViewCell: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (self.friendViewControllerDelegate != nil) {
            if (self.friendViewControllerDelegate.inviteFriendsDto.isAllContactsView == false) {
                return 1;
            } else {
                return friendViewControllerDelegate.inviteFriendsDto.allContacts.count;
            }
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.friendViewControllerDelegate != nil) {
            if (self.friendViewControllerDelegate.inviteFriendsDto.isAllContactsView == false) {
                return self.friendViewControllerDelegate.inviteFriendsDto.cenesContacts.count;
            } else {
                return self.friendViewControllerDelegate.inviteFriendsDto.allContacts[section].sectionObjects.count;
            }
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "FriendListItemTableViewCell"
        let cell: FriendListItemTableViewCell = (tableView.dequeueReusableCell(withIdentifier: identifier) as? FriendListItemTableViewCell)!
        
        //This is the case when user is at the wehere he can see only cenes contacts
        if (self.friendViewControllerDelegate.inviteFriendsDto.isAllContactsView == false) {
            
            let eventMember = friendViewControllerDelegate.inviteFriendsDto.cenesContacts[indexPath.row];
            if (eventMember.user != nil) {
                cell.nameLabel.text = eventMember.user.name;
            } else {
                cell.nameLabel.text = eventMember.name;
            }
            
            cell.phoneBookName.text = eventMember.name;
            
            if eventMember.user != nil && eventMember.user.photo != nil {
                cell.profileImageView.sd_setImage(with: URL(string: eventMember.user.photo), placeholderImage: UIImage(named: "profile_pic_no_image"))
                cell.unselectedProfilePic.sd_setImage(with: URL(string: eventMember.user.photo), placeholderImage: UIImage(named: "profile_pic_no_image"))
            }
            
            let userContactId: Int = Int(eventMember.userContactId);
            
            let keyExists = friendViewControllerDelegate.inviteFriendsDto.checkboxStateHolder[userContactId] != nil
            if (keyExists && friendViewControllerDelegate.inviteFriendsDto.checkboxStateHolder[userContactId] == true) {
                if (eventMember.cenesMember == "yes") {
                    cell.cenesUserSelectedView.isHidden = false;
                    cell.cenesUserUnselectedView.isHidden = true;
                } else {
                    cell.cenesUserSelectedView.isHidden = true;
                    cell.cenesUserUnselectedView.isHidden = true;
                }
            } else {
                cell.cenesUserSelectedView.isHidden = true;
                cell.cenesUserUnselectedView.isHidden = false;
                if (eventMember.cenesMember == "yes") {
                    cell.cenesUserSelectedView.isHidden = true;
                    cell.cenesUserUnselectedView.isHidden = false;
                } else {
                    cell.cenesUserSelectedView.isHidden = true;
                    cell.cenesUserUnselectedView.isHidden = true;
                }
            }
            return cell;
        } else {
            //This is the case where user views all the contacts in its contact list.
            let eventMember = friendViewControllerDelegate.inviteFriendsDto.allContacts[indexPath.section].sectionObjects[indexPath.row];
            
            let cell: FriendAllContactsTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "FriendAllContactsTableViewCell") as? FriendAllContactsTableViewCell)!
            
            //If user is not nil then we will show cenes user name.
            if (eventMember.user != nil) {
                cell.name.text = eventMember.user.name;
            } else {
                cell.name.text = eventMember.name;
            }
            cell.phone.text = eventMember.phone;
            
            //Here we will check. If user is cenes member and has image then we will set it.
            //If user is not a cenes member yet, then we will show first two letters
            //of name as its label.
            if (eventMember.cenesMember == "yes") {
                cell.nonCenesUserView.isHidden = true;
                if eventMember.user != nil && eventMember.user.photo != nil {
                    cell.profilePic.sd_setImage(with: URL(string: eventMember.user.photo), placeholderImage: UIImage(named: "profile_pic_no_image"))
                }
            } else {
                cell.nonCenesUserView.isHidden = false;
                var nonCenesUserName: String = "";
                let nameSplitArr = eventMember.name.split(separator: " ");
                nonCenesUserName = String(nameSplitArr[0])[0..<1].capitalized
                if (nameSplitArr.count > 1) {
                    
                    let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
                    //If string contains valid characters, then goes in if loop
                    if String(nameSplitArr[1])[0..<1].rangeOfCharacter(from: characterset.inverted) == nil {
                        nonCenesUserName.append(String(nameSplitArr[1])[0..<1].capitalized);
                    } else {
                        //If string containts speacial character, then we will check if there is anymore strnig
                        //available, If yes then we will chekc for third string.
                        if (nameSplitArr.count > 2) {
                            if String(nameSplitArr[2])[0..<1].rangeOfCharacter(from: characterset.inverted) == nil {
                                nonCenesUserName.append(String(nameSplitArr[2])[0..<1].capitalized);
                            } else {
                                nonCenesUserName.append(String(nameSplitArr[2])[1..<2].capitalized);
                            }
                        } else {
                            nonCenesUserName.append(String(nameSplitArr[1])[1..<2].capitalized);
                        }
                    }
                }
                cell.nonCenesUserNameLabel.text = nonCenesUserName;
            }
            
            
            let userContactId: Int = Int(eventMember.userContactId);
            let keyExists = friendViewControllerDelegate.inviteFriendsDto.checkboxStateHolder[userContactId] != nil
            if (keyExists && friendViewControllerDelegate.inviteFriendsDto.checkboxStateHolder[userContactId] == true) {
                cell.hostGradientImage.isHidden = false;
                if (eventMember.cenesMember == "yes") {
                    cell.profilePic.isHidden = false;
                    cell.nonCenesUserView.isHidden = true;
                } else {
                    cell.nonCenesUserView.roundedUIViewGreyBackground();
                    cell.profilePic.isHidden = true;
                    cell.nonCenesUserView.isHidden = false;
                }
            } else {
                cell.hostGradientImage.isHidden = true;
                
                if (eventMember.cenesMember == "yes") {
                    cell.profilePic.isHidden = false;
                    cell.nonCenesUserView.isHidden = true;
                } else {
                    cell.nonCenesUserView.roundedUIViewGreyBackground();
                    cell.profilePic.isHidden = true;
                    cell.nonCenesUserView.isHidden = false;
                }
                
            }
            return cell;
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        var friendObj = EventMember();
        
        //Fetch User Contact based on the type of the screen user at.
        //If he is at all contacts screen then we will fetch all the contacts.
        if (self.friendViewControllerDelegate.inviteFriendsDto.isAllContactsView == false) {
            friendObj = friendViewControllerDelegate.inviteFriendsDto.cenesContacts[indexPath.row];
        } else {
            friendObj = friendViewControllerDelegate.inviteFriendsDto.allContacts[indexPath.section].sectionObjects[indexPath.row];
        }
        
        let userContactId = Int(friendObj.userContactId);
        
        //We will check if contact is never selected then we will add it in holder and mark it selected.
        if (friendViewControllerDelegate.inviteFriendsDto.checkboxStateHolder[userContactId] != nil ) {
        
            if (friendViewControllerDelegate.inviteFriendsDto.checkboxStateHolder[userContactId] == true) {
                friendViewControllerDelegate.inviteFriendsDto.checkboxStateHolder[userContactId] = false;
            } else {
                 friendViewControllerDelegate.inviteFriendsDto.checkboxStateHolder[userContactId] = true;
            }
        } else {
            friendViewControllerDelegate.inviteFriendsDto.checkboxStateHolder[userContactId] = true;
        }
        
        
        //After checking whether user is selected or not we will remove and add it in collection view cell.
        if (friendViewControllerDelegate.inviteFriendsDto.checkboxStateHolder[userContactId] == true) {
            friendViewControllerDelegate.inviteFriendsDto.selectedFriendCollectionViewList.append(self.friendViewControllerDelegate.inviteFriendsDto.userContactIdMapList[userContactId]!);
        } else {
            //self.friendViewControllerDelegate.inviteFriendsDto.selectedFriendCollectionViewList.removeValue(forKey: userContactId);
            var count = 0;
            for selectedFriend in friendViewControllerDelegate.inviteFriendsDto.selectedFriendCollectionViewList {
                if (selectedFriend.userContactId == friendObj.userContactId) {
                    friendViewControllerDelegate.inviteFriendsDto.selectedFriendCollectionViewList.remove(at: count);
                    break;
                }
                count = count + 1;
            }
        }
        
        friendViewControllerDelegate.refreshNavigationBarItems();
        
        self.friendViewControllerDelegate.friendTableView.reloadData();
        self.friendListInnerTable.reloadData();
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (friendViewControllerDelegate.inviteFriendsDto.isAllContactsView == true) {
            return friendViewControllerDelegate.inviteFriendsDto.allContacts[section].sectionName;
        }
        return "";
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionTitle = friendViewControllerDelegate.inviteFriendsDto.allContacts[section].sectionName;
        
        let identifier = "InnerTableHeaderTableViewCell"
        let cell: InnerTableHeaderTableViewCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? InnerTableHeaderTableViewCell
        
        if (self.friendViewControllerDelegate.inviteFriendsDto.isAllContactsView == true) {
            cell.header.text = sectionTitle
        } else {
            cell.header.text = "";
        }
        
        return cell
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return friendViewControllerDelegate.inviteFriendsDto.alphabetStrip;
    }
}

