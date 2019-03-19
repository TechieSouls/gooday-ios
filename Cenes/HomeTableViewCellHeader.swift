//
//  HomeTableViewCellHeader.swift
//  Cenes
//
//  Created by Redblink on 01/09/17.
//  Copyright © 2017 Sabita Rani Samal. All rights reserved.
//

import UIKit

class HomeTableViewCellHeader: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
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
