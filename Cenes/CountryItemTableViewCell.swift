//
//  CountryItemTableViewCell.swift
//  Deploy
//
//  Created by Cenes_Dev on 18/05/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class CountryItemTableViewCell: UITableViewCell {

    @IBOutlet weak var countryCode: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var countryItemSeparator: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.backgroundColor = themeColor;
        countryItemSeparator.backgroundColor = themeColor;
        countryItemSeparator.fadedSeparator();
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
