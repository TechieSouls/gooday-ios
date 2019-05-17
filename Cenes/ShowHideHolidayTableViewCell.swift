//
//  ShowHideHolidayTableViewCell.swift
//  Deploy
//
//  Created by Cenes_Dev on 16/05/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class ShowHideHolidayTableViewCell: UITableViewCell {

    @IBOutlet weak var holidayCalendarStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.backgroundColor = themeColor;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

