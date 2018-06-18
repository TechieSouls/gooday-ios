//
//  RemindersTableViewCell.swift
//  Cenes
//
//  Created by Chinna Addepally on 10/27/17.
//  Copyright © 2017 Redblink Pvt Ltd. All rights reserved.
//

import UIKit

class RemindersTableViewCell: UITableViewCell {

    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var reminderImageView: UIImageView!
    @IBOutlet weak var reminderButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
