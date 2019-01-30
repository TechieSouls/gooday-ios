//
//  GatheringCardHeaderTableViewCell.swift
//  Deploy
//
//  Created by Macbook on 22/01/19.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class GatheringCardHeaderTableViewCell: UITableViewCell {

    
    @IBOutlet weak var headerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        headerLabel.textColor = selectedColor;
        contentView.backgroundColor = themeColor;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
