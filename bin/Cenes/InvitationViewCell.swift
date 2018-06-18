//
//  InvitationViewCell.swift
//  Cenes
//
//  Created by Redblink on 23/10/17.
//  Copyright © 2017 Redblink Pvt Ltd. All rights reserved.
//

import UIKit

class InvitationViewCell: UITableViewCell {

    var gatheringView : GatheringViewController!
    
    @IBOutlet weak var eventImageView: UIImageView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var invitationLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func acceptButtonPressed(_ sender: UIButton) {
        self.gatheringView.acceptInvite(sender:sender)
    }
    
    
    
    @IBAction func declineButtonPressed(_ sender: UIButton) {
        self.gatheringView.declineInvite(sender:sender)
    }
    
    
    
}
