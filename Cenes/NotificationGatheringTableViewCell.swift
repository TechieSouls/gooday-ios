//
//  NotificationGatheringTableViewCell.swift
//  Deploy
//
//  Created by Cenes_Dev on 06/03/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class NotificationGatheringTableViewCell: UITableViewCell {

    @IBOutlet weak var notificationBackground: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var cellText: UILabel!
    @IBOutlet weak var readUnReadText: UILabel!
    @IBOutlet weak var daysAgoText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.profileImage.setRounded();
        
        self.notificationBackground.backgroundColor = cenesLabelBlue;
        self.notificationBackground.layer.cornerRadius = 20.0;
        self.notificationBackground.layer.masksToBounds = false;
        self.notificationBackground.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor;
        self.notificationBackground.layer.shadowOffset = CGSize(width: 0, height: 0);
        self.notificationBackground.layer.shadowOpacity  = 0.8;

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
