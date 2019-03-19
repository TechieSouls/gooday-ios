//
//  HomeEventHeaderViewCell.swift
//  Deploy
//
//  Created by Cenes_Dev on 12/03/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class HomeEventHeaderViewCell: UITableViewCell {

    @IBOutlet weak var headerLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let gradient = CAGradientLayer()
        gradient.frame = self.contentView.bounds
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.colors = [themeColor.cgColor, UIColor.white.cgColor]
        self.contentView.layer.addSublayer(gradient)
        self.contentView.addSubview(headerLabel);
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
