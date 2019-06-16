//
//  NoGatheringTableViewCell.swift
//  Deploy
//
//  Created by Cenes_Dev on 01/05/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class NoGatheringTableViewCell: UITableViewCell {

    @IBOutlet weak var syncBtn: UIButton!
    
    @IBOutlet weak var createBtn: UIButton!
    
    var newHomeViewControllerDelegate: NewHomeViewController!;
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func syncButtonPressed(_ sender: Any) {
        //ProfileTabViewController.MainViewController();
        
        let viewController = newHomeViewControllerDelegate.storyboard?.instantiateViewController(withIdentifier: "CalendarsViewController") as! CalendarsViewController;
        newHomeViewControllerDelegate.navigationController?.pushViewController(viewController, animated: true);

    }
    @IBAction func createButtonPressed(_ sender: Any) {
        let viewController = newHomeViewControllerDelegate.storyboard?.instantiateViewController(withIdentifier: "FriendsViewController") as! FriendsViewController;
        newHomeViewControllerDelegate.navigationController?.pushViewController(viewController, animated: true);
    }
}
