//
//  ThirdPartyCalendarTableViewCell.swift
//  Deploy
//
//  Created by Cenes_Dev on 10/05/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class ThirdPartyCalendarTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var accountInfoLabel: UILabel!
    
    @IBOutlet weak var deleteSyncButton: UIButton!
    
    @IBOutlet weak var descriptiontext: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.backgroundColor = themeColor;
        deleteSyncButton.backgroundColor = UIColor(red:0.29, green:0.56, blue:0.89, alpha:0.75)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func deleteSyncBtnPressed(_ sender: Any) {
        
    }
    
}
