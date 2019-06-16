//
//  MonthSeparatorTableViewCell.swift
//  Deploy
//
//  Created by Cenes_Dev on 11/06/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class MonthSeparatorTableViewCell: UITableViewCell {

    @IBOutlet weak var monthSeparatorLabel: UILabel!
    
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
