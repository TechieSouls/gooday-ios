//
//  RemindersEmptyTableViewCell.swift
//  Cenes
//
//  Created by Chinna Addepally on 10/30/17.
//  Copyright © 2017 Redblink Pvt Ltd. All rights reserved.
//

import UIKit

class RemindersEmptyTableViewCell: UITableViewCell {

    @IBOutlet weak var emptyLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        emptyLabel.textColor = Util.colorWithHexString(hexString: orangeNoTextColor)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
