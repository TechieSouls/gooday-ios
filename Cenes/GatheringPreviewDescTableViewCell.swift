//
//  GatheringPreviewDescTableViewCell.swift
//  Deploy
//
//  Created by Cenes_Dev on 22/02/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class GatheringPreviewDescTableViewCell: UITableViewCell {

    @IBOutlet weak var gathDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.contentView.backgroundColor = themeColor;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
