//
//  LocationItemTableViewCell.swift
//  Deploy
//
//  Created by Cenes_Dev on 23/04/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class LocationItemTableViewCell: UITableViewCell {

    
    @IBOutlet weak var locationTitle: UILabel!
    
    @IBOutlet weak var locationAddress: UILabel!
    
    @IBOutlet weak var distanceInKm: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
