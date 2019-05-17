//
//  HolidayCalendarListViewController.swift
//  Deploy
//
//  Created by Cenes_Dev on 12/03/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class HolidayCalendarListViewController: UIViewController {
    
    @IBOutlet weak var countryListTableView: UITableView!
    
    var countryDataArray: [String : HolidaySectionDto]!
    var alphabeticStrip: [String] = [String]();
    var loggedInUser: User!;
    var calendarSyncToken: CalendarSyncToken!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        self.view.backgroundColor = themeColor;
        self.title = "Holiday Calendar";
        
        countryListTableView.register(UINib(nibName: "ShowHideHolidayTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ShowHideHolidayTableViewCell");
        countryListTableView.register(UINib(nibName: "CountryTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CountryTableViewCell")
        
        countryDataArray = ProfileManager().getWorldHolidayData();
        
        alphabeticStrip = ProfileManager().getHolidayCalendarAlphabeticStrip();
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension HolidayCalendarListViewController: UITableViewDelegate, UITableViewDataSource {
 
    func numberOfSections(in tableView: UITableView) -> Int {
        return alphabeticStrip.count;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*if (calendarSyncToken != nil) {
            return (countryDataArray.count + 1);
        }
        return countryDataArray.count;*/
        if (countryDataArray[alphabeticStrip[section]] == nil) {
            return 0;
        }
        if (alphabeticStrip[section] == "#") {
            return 1;
        }
        return (countryDataArray[alphabeticStrip[section]]?.sectionData.count)!;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (alphabeticStrip[indexPath.section] == "#") {
            if (calendarSyncToken != nil) {
                return 80;
            } else {
                return 0;
            }
        }
        return 52
 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (countryDataArray![alphabeticStrip[indexPath.section]] == nil) {
            return UITableViewCell();
        }
        
        let countryDataArrayTemp = countryDataArray![alphabeticStrip[indexPath.section]]!;
        
        if (countryDataArrayTemp.sectionName == "#") {
            if (calendarSyncToken != nil) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ShowHideHolidayTableViewCell", for: indexPath) as! ShowHideHolidayTableViewCell
                
                if (calendarSyncToken != nil && calendarSyncToken.emailId != nil) {
                    cell.holidayCalendarStatus.text = "Hide Holiday Calendar";
                }
                return cell;
            }
        } else {
                if (indexPath.row <= countryDataArrayTemp.sectionData.count) {
                    let country = countryDataArrayTemp.sectionData[indexPath.row];
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableViewCell", for: indexPath) as! CountryTableViewCell
                    
                    cell.countryName.text = (country["name"] as! String);
                    
                    return cell;
                }
            }
        //}
        /*else {
            var indexPathRow = indexPath.row;
            if (calendarSyncToken != nil) {
                indexPathRow = indexPathRow - 1;
            }
            let country = countryDataArrayTemp[indexPathRow];
            let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableViewCell", for: indexPath) as! CountryTableViewCell
            
            cell.countryName.text = (country["name"] as! String);
            
            return cell;
        }*/
        
        return UITableViewCell();
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let countryDataArrayTemp = countryDataArray![alphabeticStrip[indexPath.section]];

        //if (indexPath.row == 0) {
        if (countryDataArrayTemp?.sectionName == "#") {
            if (calendarSyncToken != nil) {
                let queryStr = "calendarSyncTokenId=\(String(calendarSyncToken.refreshTokenId))";
                UserService().deleteSyncTokenByTokenId(queryStr: queryStr, token: loggedInUser.token, complete: {(response) in
                    
                })
                calendarSyncToken = nil
                tableView.reloadData();
            }
        } else {
                let country = countryDataArrayTemp?.sectionData[indexPath.row];
                
                var postData = [String: Any]();
                postData["userId"] = loggedInUser.userId;
                postData["calendarId"] = (country!["value"] as! String);
                postData["name"] = (country!["name"] as! String);
                
                DispatchQueue.global(qos: .background).async {
                    UserService().syncHolidayCalendar(postData: postData, token: self.loggedInUser.token, complete: {(response) in
                        
                    });
                }
                self.navigationController?.popViewController(animated: true);
            }
        /*} else {
            let country = countryDataArrayTemp[indexPath.row - 1];
            
            var postData = [String: Any]();
            postData["userId"] = loggedInUser.userId;
            postData["calendarId"] = (country["value"] as! String);
            postData["name"] = (country["name"] as! String);
            
            DispatchQueue.global(qos: .background).async {
                UserService().syncHolidayCalendar(postData: postData, token: self.loggedInUser.token, complete: {(response) in
                    
                });
            }
            self.navigationController?.popViewController(animated: true);
        }*/
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0;
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "";
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return alphabeticStrip;
    }
}
