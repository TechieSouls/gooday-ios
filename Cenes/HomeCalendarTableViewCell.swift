//
//  HomeCalendarTableViewCell.swift
//  Deploy
//
//  Created by Macbook on 25/01/19.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class HomeCalendarTableViewCell: UITableViewCell {

    
    @IBOutlet weak var calendarTitle: UILabel!
    
    @IBOutlet weak var calendarType: UILabel!
    
    @IBOutlet weak var calendarTime: UILabel!
    
    @IBOutlet weak var roundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contentView.backgroundColor = themeColor;
        self.roundView.roundedView();
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
