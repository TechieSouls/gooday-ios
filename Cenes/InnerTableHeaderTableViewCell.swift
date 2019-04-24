//
//  InnerTableHeaderTableViewCell.swift
//  Deploy
//
//  Created by Cenes_Dev on 18/04/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class InnerTableHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var header: UILabel!
    
    let gradient = CAGradientLayer();

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        gradient.frame = contentView.bounds;
        gradient.colors = [UIColor.white.cgColor,  themeColor.cgColor];
        gradient.locations = [0, 1];
        gradient.startPoint = CGPoint(x: 0, y: 0.5);
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5);
        self.contentView.layer.addSublayer(gradient)
        self.contentView.addSubview(header);
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        self.contentView.layer.addSublayer(gradient)
        self.contentView.addSubview(header);
    }
}
