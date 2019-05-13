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
            
            
            if (calendarSelected == SelectedCalendar.GoogleCalendar) {
                
                if (cenesProperty != nil && cenesProperty.cenesPropertyValue.value == "true") {
                    
                } else {
                    cell.accountInfoLabel.text = "Not Synced to Google Calendar";
                    cell.deleteSyncButton.titleLabel?.text = "Sync";
                }
            } else if (calendarSelected == SelectedCalendar.OutlookCalendar) {
                cell.accountInfoLabel.text = "Not Synced to Outlook Calendar";
                cell.deleteSyncButton.titleLabel?.text = "Sync";
            } else if (calendarSelected == SelectedCalendar.AppleCalendar) {
                cell.accountInfoLabel.text = "Not Synced to Apple Calendar";
                cell.deleteSyncButton.titleLabel?.text = "Sync";
            }
            
            return cell;
        }
        
        return UITableViewCell();
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 205;
    }
}
