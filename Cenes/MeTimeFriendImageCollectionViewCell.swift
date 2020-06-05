//
//  MeTimeFriendImageCollectionViewCell.swift
//  Cenes
//
//  Created by Cenes_Dev on 07/05/2020.
//  Copyright © 2020 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class MeTimeFriendImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var profilePic: UIImageView!;
    @IBOutlet weak var memberCountView: UIView!;
    @IBOutlet weak var memberCountLabel: UILabel!;

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        decorateMemberCountView();
    }
    
    func decorateMemberCountView() {
        profilePic.setRounded()
        memberCountView.roundedView();

        let layer = UIView(frame: CGRect(x: memberCountView.bounds.origin.x, y: memberCountView.bounds.origin.y, width: 30, height: 30))
         let gradient = CAGradientLayer();
         gradient.frame = CGRect(x: 0, y: 0, width: 45, height: 45);
         gradient.colors = [UIColor(red:0.93, green:0.61, blue:0.15, alpha:1).cgColor, UIColor(red:0.91, green:0.49, blue:0.48, alpha:1).cgColor]
         gradient.locations = [0, 1]
         gradient.startPoint = CGPoint(x: 0.5, y: 0)
         gradient.endPoint = CGPoint(x: 0.5, y: 1)
         layer.layer.addSublayer(gradient)
         self.memberCountView.addSubview(layer)
        self.memberCountView.addSubview(memberCountLabel);
    }
    
    override func layoutSubviews() {

    }
}
