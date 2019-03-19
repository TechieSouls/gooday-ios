//
//  GatheringPreviewImageTableViewCell.swift
//  Deploy
//
//  Created by Cenes_Dev on 22/02/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class GatheringPreviewImageTableViewCell: UITableViewCell {

    
    @IBOutlet weak var gatImage: UIImageView!
    
    @IBOutlet weak var hostImage: UIImageView!;
    
    @IBOutlet weak var hostName: UILabel!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.backgroundColor = themeColor
        self.hostImage.roundedView();
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
