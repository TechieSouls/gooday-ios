//
//  ThirdPartyCalendarTableViewCell.swift
//  Deploy
//
//  Created by Cenes_Dev on 10/05/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class ThirdPartyCalendarTableViewCell: UITableViewCell, ThirdPartyCalendarProtocol {

    @IBOutlet weak var accountInfoLabel: UILabel!
    
    @IBOutlet weak var deleteSyncButton: UIButton!
    
    @IBOutlet weak var descriptiontext: UILabel!
    
    var selectedCalendarDelegate: SelectedCalendarViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.backgroundColor = themeColor;
        deleteSyncButton.backgroundColor = UIColor(red:0.29, green:0.56, blue:0.89, alpha:0.75)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func deleteSyncBtnPressed(_ sender: Any) {
        
        if (selectedCalendarDelegate.calendarSelected == SelectedCalendar.GoogleCalendar) {
            if (selectedCalendarDelegate.isSynced == false) {
                selectedCalendarDelegate.googleSyncBegins();
            } else {
                self.selectedCalendarDelegate.deleteSyncBySyncId(syncId: selectedCalendarDelegate.calendarSyncToken.refreshTokenId)
            }
        } else if (selectedCalendarDelegate.calendarSelected == SelectedCalendar.OutlookCalendar) {
            if (selectedCalendarDelegate.isSynced == false) {
                selectedCalendarDelegate.outlookSyncBegins();
            } else {
                self.selectedCalendarDelegate.deleteSyncBySyncId(syncId: selectedCalendarDelegate.calendarSyncToken.refreshTokenId)
            }
        } else if (selectedCalendarDelegate.calendarSelected == SelectedCalendar.AppleCalendar) {
            if (selectedCalendarDelegate.isSynced == false) {
                selectedCalendarDelegate.appleSyncBegins()
            } else {
                self.selectedCalendarDelegate.deleteSyncBySyncId(syncId: selectedCalendarDelegate.calendarSyncToken.refreshTokenId)
            }
        }
    }
    
    func updateInfo(isSynced: Bool, email: String) {
        if (isSynced == false) {
            accountInfoLabel.text = "Not Synced to \(String(selectedCalendarDelegate.calendarSelected)) Calendar";
            deleteSyncButton.setTitle("Sync", for: .normal)
        } else {
            accountInfoLabel.text = "Account: \(String(email))";
            deleteSyncButton.setTitle("Delete", for: .normal)
        }
    }
    
}
