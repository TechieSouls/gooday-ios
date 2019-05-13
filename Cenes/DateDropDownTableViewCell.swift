//
//  DateDropDownTableViewCell.swift
//  Deploy
//
//  Created by Cenes_Dev on 27/04/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class DateDropDownTableViewCell: UITableViewCell {

    
    @IBOutlet weak var topDate: UILabel!
    
    @IBOutlet weak var clanedarToggleArrowVioew: UIView!
    
    @IBOutlet weak var calendarArrow: UIImageView!
    
    var newHomeViewControllerDelegate: NewHomeViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.backgroundColor = themeColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
