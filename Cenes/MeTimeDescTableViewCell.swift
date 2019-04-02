//
//  MeTimeDescTableViewCell.swift
//  Deploy
//
//  Created by Cenes_Dev on 19/03/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class MeTimeDescTableViewCell: UITableViewCell {

    @IBOutlet weak var meTimeDescription: UILabel!
    var totalHeightOfCell = 100;

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.backgroundColor = themeColor;
        meTimeDescription.textColor = UIColor.black;
        meTimeDescription.contentScaleFactor = 0.1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
