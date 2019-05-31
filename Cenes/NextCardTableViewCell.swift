//
//  NextCardTableViewCell.swift
//  Deploy
//
//  Created by Cenes_Dev on 24/05/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class NextCardTableViewCell: UITableViewCell {

    @IBOutlet weak var cardUpArrow: UIImageView!
    
    var gatheringInvitationViewControllerDelegate: GatheringInvitationViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.backgroundColor = themeColor;
        
        let cardUpArrowTap = UITapGestureRecognizer.init(target: self, action: #selector(cardUpArrowPressed));
        cardUpArrow.addGestureRecognizer(cardUpArrowTap);
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func cardUpArrowPressed() {
        gatheringInvitationViewControllerDelegate.skipCard();
    }
}
