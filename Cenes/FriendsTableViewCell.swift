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

    
    var checkboxStateHolder: [Int: Bool] = [:];
    
    //var nactvityIndicatorView = NVActivityIndicatorView.init(frame: cgRectSizeLoading, type: NVActivityIndicatorType.lineScaleParty, color: UIColor.white, padding: 0.0);
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.friendListInnerTable.dataSource = self;
        //self.friendListInnerTable.delegate = self;
        
        self.friendListInnerTable.register(UINib(nibName: "FriendListItemTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "FriendListItemTableViewCell")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc func checkboxClicked(_ sender: UIButton) {
        
        print("\(sender.tag) isSelected : \(!sender.isSelected)")
        self.checkboxStateHolder[sender.tag] = !sender.isSelected;
        print("\(self.checkboxStateHolder) summary");
        if (!sender.isSelected == true) {
            print(sender.tag)
            self.friendViewControllerDelegate.selectedFriendHolder[sender.tag] = self.friendViewControllerDelegate.userContactIdMapList[sender.tag];
        } else {
            self.friendViewControllerDelegate.selectedFriendHolder.removeValue(forKey: sender.tag);
        }
        sender.isSelected = !sender.isSelected
        
        if (self.friendViewControllerDelegate.selectedFriendHolder.count > 0) {
            self.friendViewControllerDelegate.friendTableViewCellsHeight["friendCollectionViewCell"] = 100;
        } else {
            self.friendViewControllerDelegate.friendTableViewCellsHeight["friendCollectionViewCell"] = 0;
        }
        
        self.friendViewControllerDelegate.searchText = "";
        self.friendViewControllerDelegate.getfilterArray(str: "");
        self.friendViewControllerDelegate.friendTableView.reloadData();
        self.friendListInnerTable.reloadData();
        
    }
}

extension FriendsTableViewCell: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.friendViewControllerDelegate != nil) {
            return self.friendViewControllerDelegate.eventMembers.count;
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "FriendListItemTableViewCell"
        let cell: FriendListItemTableViewCell = (tableView.dequeueReusableCell(withIdentifier: identifier) as? FriendListItemTableViewCell)!
        
        let eventMember = self.friendViewControllerDelegate.eventMembers[indexPath.row] ;
        cell.nameLabel.text = eventMember.name;
        
        if (eventMember.cenesMember == "yes") {
            
            cell.nonCenesUIView.isHidden = true;
            
            if eventMember.user != nil && eventMember.user.photo != nil {
                cell.profileImageView.sd_setImage(with: URL(string: eventMember.user.photo), placeholderImage: UIImage(named: "cenes_user_no_image"))
            } else {
                cell.profileImageView.image = UIImage(named: "cenes_user_no_image");
            }
        } else {
            cell.nonCenesUIView.isHidden = false;
            var nonCenesUserName: String = "";
            let nameSplitArr = eventMember.name.split(separator: " ");
            nonCenesUserName = String(nameSplitArr[0])[0..<1].capitalized
            if (nameSplitArr.count > 1) {
                nonCenesUserName.append(String(nameSplitArr[1])[0..<1].capitalized);
            }
            cell.nonCenesNameLabel.text = nonCenesUserName;
        }
        
        
        let userContactId: Int = Int(eventMember.userContactId);
        
        let keyExists = self.checkboxStateHolder[userContactId] != nil
        if (keyExists && self.checkboxStateHolder[userContactId] == true) {
            cell.inviteUerCheckbox.isSelected = true;
            cell.inviteUerCheckbox.setImage(UIImage.init(named: "circle_selected"), for: UIControlState.normal)
        } else {
            cell.inviteUerCheckbox.isSelected = false;
            cell.inviteUerCheckbox.setImage(UIImage.init(named: "circle_unselected"), for: UIControlState.normal)
        }
        if let btnChk = cell.inviteUerCheckbox {
            btnChk.tag = Int(userContactId);
            btnChk.addTarget(self, action: #selector(checkboxClicked(_ :)), for: .touchUpInside)
        }
        return cell;
    }
}
