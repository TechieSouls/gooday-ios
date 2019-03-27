//
//  MeTimeUnscheduleTableViewCell.swift
//  Deploy
//
//  Created by Cenes_Dev on 20/03/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class MeTimeUnscheduleTableViewCell: UITableViewCell {

    @IBOutlet weak var meTimeCardView: UIView!
    @IBOutlet weak var roundedView: UIView!
    
    @IBOutlet weak var meTimeViewLabel: UILabel!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var notScheduledText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contentView.backgroundColor = themeColor;
        
        meTimeCardView.viewCircledCorners();
        meTimeCardView.layer.borderWidth = 1;
        meTimeCardView.layer.borderColor = cenesLabelBlue.cgColor;
        
        roundedView.layer.borderColor = cenesLabelBlue.cgColor;
        roundedView.layer.borderWidth = 1;
        roundedView.roundedView();
        
        meTimeViewLabel.textColor = cenesLabelBlue

        title.textColor = cenesLabelBlue

        notScheduledText.textColor = unselectedColor

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
