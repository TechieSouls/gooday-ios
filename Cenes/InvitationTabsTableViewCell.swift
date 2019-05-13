//
//  InvitationTabsTableViewCell.swift
//  Deploy
//
//  Created by Cenes_Dev on 27/04/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class InvitationTabsTableViewCell: UITableViewCell {

    @IBOutlet weak var acceptedBtn: UIButton!
    @IBOutlet weak var pendingBtn: UIButton!
    @IBOutlet weak var declinedBtn: UIButton!
    
    var newHomeViewControllerDelegate: NewHomeViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.backgroundColor = themeColor;
        acceptedBtn.selectedBottomBorderBtn();
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func acceptBtnPressed(_ sender: Any) {
        acceptedBtn.selectedBottomBorderBtn();
        pendingBtn.unselectedBottomBorderBtn();
        declinedBtn.unselectedBottomBorderBtn();
        activateSelectedTabData(selectedTab: HomeInvitationTabs.Accepted);
        newHomeViewControllerDelegate.homeDtoList = newHomeViewControllerDelegate.homescreenDto.acceptedGatherings;
        newHomeViewControllerDelegate.homeTableView.reloadData();
        //newHomeViewControllerDelegate.dataTableViewCellProtocolDelegate.reloadTableToTop();
        //newHomeViewControllerDelegate.loadGatheringDataByStatus(status: "Going")
    }
    
    @IBAction func pendingBtnPressed(_ sender: Any) {
        pendingBtn.selectedBottomBorderBtn();
        acceptedBtn.unselectedBottomBorderBtn();
        declinedBtn.unselectedBottomBorderBtn();
        activateSelectedTabData(selectedTab: HomeInvitationTabs.Pending);
        newHomeViewControllerDelegate.homeDtoList = newHomeViewControllerDelegate.homescreenDto.pendingGatherings;
    
        newHomeViewControllerDelegate.homeTableView.reloadData();
        //newHomeViewControllerDelegate.dataTableViewCellProtocolDelegate.reloadTableToTop();
        //newHomeViewControllerDelegate.loadGatheringDataByStatus(status: "pending")
    }
    
    @IBAction func declinedBtnPressed(_ sender: Any) {
        declinedBtn.selectedBottomBorderBtn();
        acceptedBtn.unselectedBottomBorderBtn();
        pendingBtn.unselectedBottomBorderBtn();
        activateSelectedTabData(selectedTab: HomeInvitationTabs.Declined);
        newHomeViewControllerDelegate.homeDtoList = newHomeViewControllerDelegate.homescreenDto.declinedGatherings;

        newHomeViewControllerDelegate.homeTableView.reloadData();
        //newHomeViewControllerDelegate.dataTableViewCellProtocolDelegate.reloadTableToTop();
        //newHomeViewControllerDelegate.loadGatheringDataByStatus(status: "NotGoing")
    }
    
    func activateSelectedTabData(selectedTab: String) {
        newHomeViewControllerDelegate.homescreenDto.invitationTabs = selectedTab;
    }
    
    func activeSelectedTabTab() {
        
            if (HomeInvitationTabs.Accepted == newHomeViewControllerDelegate.homescreenDto.invitationTabs) {
                acceptedBtn.selectedBottomBorderBtn();
                pendingBtn.unselectedBottomBorderBtn();
                declinedBtn.unselectedBottomBorderBtn();
            } else if (HomeInvitationTabs.Pending == newHomeViewControllerDelegate.homescreenDto.invitationTabs) {
                acceptedBtn.unselectedBottomBorderBtn();
                pendingBtn.selectedBottomBorderBtn();
                declinedBtn.unselectedBottomBorderBtn();
            } else if (HomeInvitationTabs.Declined == newHomeViewControllerDelegate.homescreenDto.invitationTabs) {
                acceptedBtn.unselectedBottomBorderBtn();
                pendingBtn.unselectedBottomBorderBtn();
                declinedBtn.selectedBottomBorderBtn();
            }
        
    }
}
