//
//  GuestListTableViewCell.swift
//  Deploy
//
//  Created by Cenes_Dev on 11/04/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class GuestListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var cenesName: UILabel!
    
    @IBOutlet weak var contactName: UILabel!
    
    @IBOutlet weak var separator: UIView!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profilePic.roundedView();
        
        let gradient = CAGradientLayer()
        gradient.frame = self.separator.bounds
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.colors = [themeColor.cgColor, UIColor.white.cgColor]
    
        separator.layer.insertSublayer(gradient, at: 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
