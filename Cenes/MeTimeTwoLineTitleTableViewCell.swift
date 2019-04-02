//
//  MeTimeTwoLineTitleTableViewCell.swift
//  Deploy
//
//  Created by Cenes_Dev on 29/03/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class MeTimeTwoLineTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var meTimeCellViewDetails: UIView!
    @IBOutlet weak var meTimeImage: UIImageView!
    @IBOutlet weak var meTimeTitle: UILabel!
    @IBOutlet weak var meTimeDays: UILabel!
    @IBOutlet weak var meTimeHours: UILabel!
    @IBOutlet weak var meTimeViewNoImage: UIView!
    @IBOutlet weak var meTimeNoImageLabel: UILabel!

    var totalHeightOfCell = 145;

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contentView.backgroundColor = themeColor;
        
        meTimeCellViewDetails.viewCircledCorners();
        meTimeCellViewDetails.layer.borderWidth = 1;
        meTimeCellViewDetails.layer.borderColor = cenesLabelBlue.cgColor;
        
        meTimeImage.setRounded()
        
        meTimeViewNoImage.roundedView();
        meTimeViewNoImage.layer.borderColor = cenesLabelBlue.cgColor;
        meTimeViewNoImage.layer.borderWidth = 1;
        
        meTimeNoImageLabel.textColor = cenesLabelBlue;
        
        meTimeTitle.textColor = cenesLabelBlue
        
        meTimeDays.textColor = selectedColor
        meTimeHours.textColor = selectedColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
