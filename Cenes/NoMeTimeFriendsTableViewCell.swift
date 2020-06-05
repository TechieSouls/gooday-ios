//
//  NoMeTimeFriendsTableViewCell.swift
//  Cenes
//
//  Created by Cenes_Dev on 04/05/2020.
//  Copyright © 2020 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class NoMeTimeFriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var shareToFriends: UIButton!;
    var friendsViewControllerDelegate: FriendsViewController!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func shareToFriendsPressed() {
        // set up activity view controller
        let textToShare = [ appStoreLink ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.friendsViewControllerDelegate.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = []
        // present the view controller
        self.friendsViewControllerDelegate.present(activityViewController, animated: true, completion: nil)
    }
    
}
