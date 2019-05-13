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
        
        self.membersCountView.roundedView()
        let layer = UIView(frame: CGRect(x: membersCountView.bounds.origin.x, y: membersCountView.bounds.origin.y, width: 45, height: 45))
        let gradient = CAGradientLayer();
        gradient.frame = CGRect(x: 0, y: 0, width: 45, height: 45);
        gradient.colors = [UIColor(red:0.93, green:0.61, blue:0.15, alpha:1).cgColor, UIColor(red:0.91, green:0.49, blue:0.48, alpha:1).cgColor]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        layer.layer.addSublayer(gradient)
        self.membersCountView.addSubview(layer)
        self.membersCountView.addSubview(memberCountsLabel)

    }

}
