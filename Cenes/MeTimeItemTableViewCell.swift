//
//  MeTimeItemTableViewCell.swift
//  Deploy
//
//  Created by Cenes_Dev on 19/03/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class MeTimeItemTableViewCell: UITableViewCell {

    
    @IBOutlet weak var meTimeCellViewDetails: UIView!
    @IBOutlet weak var meTimeImage: UIImageView!
    @IBOutlet weak var meTimeTitle: UILabel!
    @IBOutlet weak var meTimeDays: UILabel!
    @IBOutlet weak var meTimeHours: UILabel!
    @IBOutlet weak var meTimeScheduleView: UIView!
    @IBOutlet weak var meTimeViewNoImage: UIView!
    @IBOutlet weak var meTimeNoImageLabel: UILabel!
    @IBOutlet weak var meTimeFriendCollection: UICollectionView!
    
    var totalHeightOfCell = 110;
    var metimeRecurringEvent: MetimeRecurringEvent!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contentView.backgroundColor = themeColor;
        
        meTimeCellViewDetails.viewCircledCorners();
        meTimeCellViewDetails.layer.borderWidth = 1;
        meTimeCellViewDetails.layer.borderColor = cenesLabelBlue.cgColor;
        
        meTimeImage.setRounded()
        meTimeImage.contentMode = .scaleAspectFill

        meTimeViewNoImage.roundedView();
        meTimeViewNoImage.layer.borderColor = cenesLabelBlue.cgColor;
        meTimeViewNoImage.layer.borderWidth = 1;
        
        meTimeNoImageLabel.textColor = cenesLabelBlue;
        
        meTimeTitle.textColor = cenesLabelBlue
        
        meTimeDays.textColor = selectedColor
        meTimeHours.textColor = selectedColor
        
        meTimeFriendCollection.register(UINib.init(nibName: "MeTimeFriendImageCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "MeTimeFriendImageCollectionViewCell");
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension MeTimeItemTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if (metimeRecurringEvent == nil) {
            return 0;
        }
        if (metimeRecurringEvent.recurringEventMembers.count > 3) {
            return 4;
        }
        return metimeRecurringEvent.recurringEventMembers.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let recurringEventMember = metimeRecurringEvent.recurringEventMembers[indexPath.row];
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MeTimeFriendImageCollectionViewCell", for: indexPath) as! MeTimeFriendImageCollectionViewCell;
        cell.decorateMemberCountView()

        cell.profilePic.setRounded();
        cell.profilePic.isHidden = false;
        cell.memberCountView.isHidden = true;
        
        if (indexPath.row == 3) {
            cell.profilePic.isHidden = true;
            cell.memberCountView.isHidden = false;
            cell.memberCountLabel.text = "+\(metimeRecurringEvent.recurringEventMembers.count - 3)"
        } else {
            if (recurringEventMember.user != nil && recurringEventMember.user.photo != nil) {
                cell.profilePic.sd_setImage(with: URL.init(string: recurringEventMember.user.photo), placeholderImage: UIImage.init(named: "profile_pic_no_image"), completed: nil);
            } else {
                cell.profilePic.image = UIImage.init(named: "profile_pic_no_image");
            }
        }
        return cell;
    }
}
