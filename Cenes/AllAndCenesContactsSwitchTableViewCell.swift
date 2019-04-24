//
//  AllAndCenesContactsSwitchTableViewCell.swift
//  Deploy
//
//  Created by Cenes_Dev on 16/04/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class AllAndCenesContactsSwitchTableViewCell: UITableViewCell {

    @IBOutlet weak var switchLabel: UILabel!
    let gradient = CAGradientLayer()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        contentView.backgroundColor = themeColor;
        
        gradient.frame = contentView.bounds
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.colors = [UIColor.white.cgColor, themeColor.cgColor]
        
        contentView.layer.insertSublayer(gradient, at: 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = bounds
    }
}
