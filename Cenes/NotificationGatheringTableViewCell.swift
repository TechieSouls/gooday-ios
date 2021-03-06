//
//  NotificationGatheringTableViewCell.swift
//  Deploy
//
//  Created by Cenes_Dev on 06/03/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class NotificationGatheringTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var title: UILabel!;
    @IBOutlet weak var happen: UILabel!;
    @IBOutlet weak var circleButtonView: UIView!;
    @IBOutlet weak var circleButtonDot: UIButton!;
    @IBOutlet weak var messageAndNameView: UIView!
    
    @IBOutlet weak var rightCornerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.profileImage.setRounded();
        self.circleButtonDot.layer.cornerRadius = self.circleButtonDot.frame.width/2;
        self.circleButtonDot.layer.backgroundColor = cenesLabelBlue.cgColor
        self.happen.textColor = UIColor.gray;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
