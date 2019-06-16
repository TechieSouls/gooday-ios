//
//  GatheringCardTableViewCell.swift
//  Deploy
//
//  Created by Macbook on 21/01/19.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class GatheringCardTableViewCell: UITableViewCell {

    
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var membersCollectionView: UICollectionView!
    
    @IBOutlet weak var ownerLabel: UILabel!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var locationView: UIView!
    
    var bubbleNumbers: Int = 0
    
    var members: [EventMember] = [];
    
    var newHomeViewControllerDelegate: NewHomeViewController!
    
    var acceptedMembers: [EventMember] = [];
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.membersCollectionView.register(UINib(nibName: "MemberCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "MemberCollectionViewCell")
        self.membersCollectionView.register(UINib(nibName: "MemberCountCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "MemberCountCollectionViewCell")
        
        self.updateUI();

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI() {
        
        self.contentView.backgroundColor = UIColor.white;
        self.membersCollectionView.backgroundColor = UIColor.white;
        profilePic.setRounded();
    }
    
    func reloadFriends(){
        // print("Reloading data for \(self.timeLabel.text!) ")
        self.membersCollectionView.reloadData()
    }
}

extension GatheringCardTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        /*if (members.count > 3) {
            return 4
        } else {
            return members.count;
        }*/
        //Check if there are members who have accepted the event
        //Then we will show only those who have accpedted the event
        if (acceptedMembers.count != 0) {
            if (acceptedMembers.count > 3) {//If there are more than 3 persons
                                            //who has accepetd the event, then we will show
                                            //3 photos + counts
                return 4 //4
            } else {
                if (acceptedMembers.count == members.count) { //If Total accpedted members are not greater than 3
                                                            //Then we will check if they are equal to total members
                                                            //If yes then we will show all accepted members
                    return acceptedMembers.count;
                } else {
                    return (acceptedMembers.count + 1); // 2,3 //If total members are more than those who has
                                                        //accpepted the event, then we will show accpted + counts
                }
            }
        } else if (members.count != 0) {//Else we will only show the counts of people who are accepting the event
            return 1;

        } else { //We will not show anything in the colleciton view.
            return 0;
        }
        return 0;
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        /*if indexPath.row < 3 {
            
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemberCollectionViewCell", for: indexPath) as! MemberCollectionViewCell
            
            let eventMember = members[indexPath.row]
            
            if eventMember.user != nil {
                
                if (eventMember.user.photo != nil) {
                    cell.profilePic.sd_setImage(with: URL(string: (eventMember.user.photo)!), placeholderImage: UIImage(named: "profile_pic_no_image"));
                } else {
                    
                    cell.profilePic.image = UIImage(named: "profile_pic_no_image");
                }
                
                if (newHomeViewControllerDelegate.loggedInUser.userId != eventMember.userId) {
                    cell.name.text = String(eventMember.name.split(separator: " ")[0]);
                } else {
                    cell.name.text = "Me";
                }
            }
            
            if (indexPath.row == 0) {
                cell.guestLabel.isHidden = false;
            } else {
                cell.guestLabel.isHidden = true;
            }
            
            
            return cell;
        } else {
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemberCountCollectionViewCell", for: indexPath) as! MemberCountCollectionViewCell
                cell.membersCountView.isHidden = false
                cell.memberCountsLabel.text = "+\(String(members.count - 3))"
            
            return cell;
        }*/
        if (acceptedMembers.count > 0 && indexPath.row < acceptedMembers.count && indexPath.row < 3) {
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemberCollectionViewCell", for: indexPath) as! MemberCollectionViewCell
            
            let eventMember = acceptedMembers[indexPath.row]
            
            if eventMember.user != nil {
                
                if (eventMember.user.photo != nil) {
                    cell.profilePic.sd_setImage(with: URL(string: (eventMember.user.photo)!), placeholderImage: UIImage(named: "profile_pic_no_image"));
                } else {
                    
                    cell.profilePic.image = UIImage(named: "profile_pic_no_image");
                }
                
                if (newHomeViewControllerDelegate.loggedInUser.userId != eventMember.userId) {
                    if (eventMember.user != nil && eventMember.user.name != nil) {
                        cell.name.text = String(eventMember.user.name.split(separator: " ")[0]);
                    } else {
                        cell.name.text = String(eventMember.name.split(separator: " ")[0]);
                    }
                } else {
                    cell.name.text = "Me";
                }
            }
            
            if (indexPath.row == 0) {
                cell.guestLabel.isHidden = false;
            } else {
                cell.guestLabel.isHidden = true;
            }
            
            
            return cell;
        } else {
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemberCountCollectionViewCell", for: indexPath) as! MemberCountCollectionViewCell
            cell.membersCountView.isHidden = false
            
            var counts: Int = members.count;
            if (acceptedMembers.count > 0) {
                if (acceptedMembers.count > 3) {
                    counts = members.count - 3
                } else {
                    counts = members.count - acceptedMembers.count;
                }
            }
            cell.memberCountsLabel.text = "+\(String(counts))";
            return cell;
        }
        return UICollectionViewCell();
    }
}
