//
//  MeTimeItemTableViewCell.swift
//  Deploy
//
//  Created by Cenes_Dev on 19/03/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class MeTimeItemTableViewCell: UITableViewCell {

    
    @IBOutlet weak var meTimeCellViewDetails: UIView!
    @IBOutlet weak var meTimeImage: UIImageView!
    
    @IBOutlet weak var meTimeViewNoImage: UIView!
    
    @IBOutlet weak var meTimeTitle: UILabel!
    @IBOutlet weak var meTimeDays: UILabel!
    @IBOutlet weak var meTimeHours: UILabel!
    @IBOutlet weak var meTimeScheduleView: UIView!
    @IBOutlet weak var notSchedulesLabel: UILabel!
    
    @IBOutlet weak var meTimeNoImageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contentView.backgroundColor = themeColor;
        
        meTimeCellViewDetails.viewCircledCorners();
        meTimeImage.setRounded()
        
        meTimeTitle.textColor = cenesLabelBlue
        meTimeNoImageLabel.textColor = cenesLabelBlue
        
        meTimeDays.textColor = selectedColor
        meTimeHours.textColor = selectedColor
        
        notSchedulesLabel.textColor = unselectedColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
