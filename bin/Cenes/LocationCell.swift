//
//  LocationCell.swift
//  Cenes
//
//  Created by Redblink on 12/09/17.
//  Copyright © 2017 Sabita Rani Samal. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
