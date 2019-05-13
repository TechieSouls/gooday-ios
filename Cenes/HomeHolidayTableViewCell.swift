//
//  HomeHolidayTableViewCell.swift
//  Deploy
//
//  Created by Macbook on 25/01/19.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class HomeHolidayTableViewCell: UITableViewCell {

    @IBOutlet weak var holidayDate: UILabel!
    @IBOutlet weak var holidayLabel: UILabel!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contentView.backgroundColor = themeColor;
        holidayLabel.textColor = UIColor.black;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
