//
//  PeronalDetailsTableViewCell.swift
//  Deploy
//
//  Created by Cenes_Dev on 04/05/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class PeronalDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
