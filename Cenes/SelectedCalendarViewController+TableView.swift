//
//  SelectedCalendarViewController+TableView.swift
//  Deploy
//
//  Created by Cenes_Dev on 10/05/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
extension SelectedCalendarViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (calendarSelected == SelectedCalendar.HolidayCalendar) {
            return holidayCountries.count;
        }
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (calendarSelected == SelectedCalendar.HolidayCalendar) {
            let cell: HolidayCalendarTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HolidayCalendarTableViewCell") as! HolidayCalendarTableViewCell;
            
            return cell;
        } else {
            let cell: ThirdPartyCalendarTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ThirdPartyCalendarTableViewCell") as! ThirdPartyCalendarTableViewCell;
            cell.selectedCalendarDelegate = self;
            thirdPartyCalendarProtocolDelegate = cell;
            
            if (calendarSelected == SelectedCalendar.GoogleCalendar) {
                
                cell.descriptiontext.text = "Only one Google account can be synced at a time. Add a different account by deleting the current one.";
                
                if (calendarSyncToken != nil && calendarSyncToken.accountType == SelectedCalendar.GoogleCalendar && calendarSyncToken.emailId != nil) {
                    cell.accountInfoLabel.text = "Account: \(String(calendarSyncToken.emailId))";
                    cell.deleteSyncButton.setTitle("Delete", for: .normal);
                    isSynced = true;
                } else {
                    cell.accountInfoLabel.text = "Not Synced to Google Calendar";
                    cell.deleteSyncButton.setTitle("Sync", for: .normal);
                    isSynced = false;
                }
            } else if (calendarSelected == SelectedCalendar.OutlookCalendar) {
                
                cell.descriptiontext.text = "Only one Outlook account can be synced at a time. Add a different account by deleting the current one.";
                
                if (calendarSyncToken != nil && calendarSyncToken.accountType == SelectedCalendar.OutlookCalendar && calendarSyncToken.emailId != nil) {
                    cell.accountInfoLabel.text = "Account: \(String(calendarSyncToken.emailId))";
                    cell.deleteSyncButton.setTitle("Delete", for: .normal);
                    isSynced = true;
                } else {
                    cell.accountInfoLabel.text = "Not Synced to Outlook Calendar";
                    cell.deleteSyncButton.setTitle("Sync", for: .normal);
                    isSynced = false;
                }
                
            } else if (calendarSelected == SelectedCalendar.AppleCalendar) {
                
                cell.descriptiontext.text = "";
                
                if (calendarSyncToken != nil && calendarSyncToken.accountType == SelectedCalendar.AppleCalendar) {
                    cell.accountInfoLabel.text = "Account: \(String(calendarSyncToken.emailId))";
                    cell.deleteSyncButton.setTitle("Delete", for: .normal);
                    isSynced = true;
                } else {
                    cell.accountInfoLabel.text = "Not Synced to Apple Calendar";
                    cell.deleteSyncButton.setTitle("Sync", for: .normal);
                    isSynced = false;
                }
            }
            
            return cell;
        }
        
        return UITableViewCell();
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 205;
    }
}
