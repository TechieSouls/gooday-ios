//
//  HomeTableViewCellTwo.swift
//  Cenes
//
//  Created by Sabita Rani Samal on 8/6/17.
//  Copyright © 2017 Sabita Rani Samal. All rights reserved.
//

import UIKit
import IoniconsSwift

class HomeTableViewCellTwo: UITableViewCell {
    
    @IBOutlet weak var reminderImage: UIImageView!
    @IBOutlet weak var reminderlabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        reminderImage.image = Ionicons.iosCircleOutline.image(10)
        reminderlabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        reminderlabel.numberOfLines = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
