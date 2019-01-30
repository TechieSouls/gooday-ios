//
//  MemberCountCollectionViewCell.swift
//  Deploy
//
//  Created by Macbook on 22/01/19.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class MemberCountCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var membersCountView: UIView!
    @IBOutlet weak var memberCountsLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let gradient = CAGradientLayer()
        gradient.frame = self.memberCountsLabel.bounds
        gradient.colors = [UIColor(red: 238/255, green: 155/255, blue: 38/255, alpha: 1).cgColor,UIColor(red: 232/255, green: 125/255, blue: 122/255, alpha: 1).cgColor]
        gradient.startPoint = CGPoint(x: 0, y: self.membersCountView.bounds.height)
        gradient.startPoint = CGPoint(x: self.membersCountView.bounds.width, y: self.membersCountView.bounds.height)

        //gradient.locations = [0.0,1.0]
        //gradient.startPoint = CGPoint(x: 0, y: 0.5)
        //gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.membersCountView.layer.addSublayer(gradient)
        self.membersCountView.roundedView();
    }

}
