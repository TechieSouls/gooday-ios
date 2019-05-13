//
//  GatheringCardHeaderTableViewCell.swift
//  Deploy
//
//  Created by Macbook on 22/01/19.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class GatheringCardHeaderTableViewCell: UITableViewCell {

    
    @IBOutlet weak var headerLabel: UILabel!
    let gradient = CAGradientLayer();

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        gradient.frame = contentView.bounds;
        gradient.colors = [UIColor.white.cgColor,  themeColor.cgColor];
        gradient.locations = [0, 1];
        gradient.startPoint =  CGPoint(x: 1.0, y: 0.5);
        gradient.endPoint =   CGPoint(x: 0, y: 0.5);
        self.contentView.layer.addSublayer(gradient)
        self.contentView.addSubview(headerLabel);
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: self.layer)
        gradient
            .frame = self.contentView.bounds
    }
}
