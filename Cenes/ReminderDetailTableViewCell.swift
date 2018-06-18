//
//  ReminderDetailTableViewCell.swift
//  Cenes
//
//  Created by Chinna Addepally on 10/30/17.
//  Copyright © 2017 Redblink Pvt Ltd. All rights reserved.
//

import UIKit

class ReminderDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var reminderStatusButton: UIButton!
    @IBOutlet weak var reminderTitleLabel: UILabel!
    @IBOutlet weak var reminderEditButton: UIButton!
    @IBOutlet weak var reminderDateLabel: UILabel!
    @IBOutlet weak var reminderLocationLabel: UILabel!
    @IBOutlet weak var locationPointImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
