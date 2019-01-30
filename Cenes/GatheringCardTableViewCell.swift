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
    
    @IBOutlet weak var startTime: UILabel!
    
    @IBOutlet weak var membersCollectionView: UICollectionView!
    
    @IBOutlet weak var ownerLabel: UILabel!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var locationView: UIView!
    
    @IBOutlet weak var backgroundCardView: UIView!
    
    var bubbleNumbers: Int = 0
    
    var members: [CenesUser] = [];
    
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
        
        self.contentView.backgroundColor = themeColor;
        
        self.backgroundCardView.backgroundColor = UIColor.white;
        self.backgroundCardView.layer.cornerRadius = 30.0;
        self.backgroundCardView.layer.masksToBounds = false;
        self.backgroundCardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor;
        self.backgroundCardView.layer.shadowOffset = CGSize(width: 0, height: 0);
        self.backgroundCardView.layer.shadowOpacity  = 0.8;
        
    }
    
    func reloadFriends(){
        // print("Reloading data for \(self.timeLabel.text!) ")
        self.membersCollectionView.reloadData()
    }
}

extension GatheringCardTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return members.count;
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < 3{
            
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemberCollectionViewCell", for: indexPath) as! MemberCollectionViewCell
            
            let user = members[indexPath.row]
            
            if user.photoUrl != nil && user.photoUrl != "" {                
                cell.profilePic.cacheImage(urlString: user.photoUrl)

            } else {
                    cell.profilePic.image = #imageLiteral(resourceName: "profile icon");
            }
            return cell;
        }else {
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemberCountCollectionViewCell", for: indexPath) as! MemberCountCollectionViewCell
            
                cell.memberCountsLabel.text = "+\(bubbleNumbers)"
            
            return cell;
        }
    }
}
