//
//  PredictiveInfoTableViewCell.swift
//  Deploy
//
//  Created by Cenes_Dev on 19/04/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class PredictiveInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var greenColorCircle: UIView!
    
    @IBOutlet weak var greyColorCirlce: UIView!
    
    @IBOutlet weak var yellowColorCirlce: UIView!
    
    @IBOutlet weak var redColorCircle: UIView!
    
    @IBOutlet weak var pinkColorCircle: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        greenColorCircle.roundedView();
        greyColorCirlce.roundedView();
        yellowColorCirlce.roundedView();
        redColorCircle.roundedView();
        pinkColorCircle.roundedView();

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
