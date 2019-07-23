//
//  CalendarsViewController.swift
//  Deploy
//
//  Created by Cenes_Dev on 10/05/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class CalendarsViewController: UIViewController {

    @IBOutlet weak var holidayCalendarBar: UIView!
    
    @IBOutlet weak var googleCalendarBar: UIView!
    
    @IBOutlet weak var outlookCalendarBar: UIView!
    
    @IBOutlet weak var appleCalendarBar: UIView!
    
    @IBOutlet weak var holidayCalendarLabel: UILabel!
    
    var loggedInUser: User!;
    var calendarSyncTokens: [CalendarSyncToken]!;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = themeColor;
        self.title = "My Calendars";
        let tapHolidayGesture = UITapGestureRecognizer.init(target: self, action: #selector(holidayCalendarBarPressed));
        holidayCalendarBar.addGestureRecognizer(tapHolidayGesture);
        
        let tapGoogleGesture = UITapGestureRecognizer.init(target: self, action: #selector(googleCalendarBarPressed));
        googleCalendarBar.addGestureRecognizer(tapGoogleGesture);
        
        let tapOutlookGesture = UITapGestureRecognizer.init(target: self, action: #selector(outlookCalendarBarPressed));
        outlookCalendarBar.addGestureRecognizer(tapOutlookGesture);
        
        let tapAppleGesture = UITapGestureRecognizer.init(target: self, action: #selector(appleCalendarBarPressed));
        appleCalendarBar.addGestureRecognizer(tapAppleGesture);
        
        loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false;
        self.tabBarController?.tabBar.isHidden = true;
    }

    override func viewDidAppear(_ animated: Bool) {
        calendarSyncTokens = [CalendarSyncToken]();
        loadUserProperties();
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @objc func holidayCalendarBarPressed() {
        let uiViewController = storyboard?.instantiateViewController(withIdentifier: "HolidayCalendarListViewController") as! HolidayCalendarListViewController;
        
        
        if (calendarSyncTokens != nil && calendarSyncTokens.count > 0) {
            for calendarSyncToken in calendarSyncTokens {
                if (calendarSyncToken.accountType == SelectedCalendar.HolidayCalendar) {
                    uiViewController.calendarSyncToken = calendarSyncToken;
                    break;
                }
            }
        }
        self.navigationController?.pushViewController(uiViewController, animated: true);
    }
    
    @objc func googleCalendarBarPressed() {
        
        let uiViewController = storyboard?.instantiateViewController(withIdentifier: "SelectedCalendarViewController") as! SelectedCalendarViewController;
        uiViewController.calendarSelected = SelectedCalendar.GoogleCalendar;
        if (calendarSyncTokens != nil && calendarSyncTokens.count > 0) {
            for calendarSyncToken in calendarSyncTokens {
                if (calendarSyncToken.accountType == SelectedCalendar.GoogleCalendar) {
                    uiViewController.calendarSyncToken = calendarSyncToken;
                }
            }
        }

        self.navigationController?.pushViewController(uiViewController, animated: true);
    }
    
    @objc func outlookCalendarBarPressed() {
        let uiViewController = storyboard?.instantiateViewController(withIdentifier: "SelectedCalendarViewController") as! SelectedCalendarViewController;
        uiViewController.calendarSelected = SelectedCalendar.OutlookCalendar;
        if (calendarSyncTokens != nil && calendarSyncTokens.count > 0) {
            for calendarSyncToken in calendarSyncTokens {
                if (calendarSyncToken.accountType == SelectedCalendar.OutlookCalendar) {
                    uiViewController.calendarSyncToken = calendarSyncToken;
                }
            }
        }

        self.navigationController?.pushViewController(uiViewController, animated: true);
    }
    
    @objc func appleCalendarBarPressed() {
        let uiViewController = storyboard?.instantiateViewController(withIdentifier: "SelectedCalendarViewController") as! SelectedCalendarViewController;
        uiViewController.calendarSelected = SelectedCalendar.AppleCalendar;
        if (calendarSyncTokens != nil && calendarSyncTokens.count > 0) {
            for calendarSyncToken in calendarSyncTokens {
                if (calendarSyncToken.accountType == SelectedCalendar.AppleCalendar) {
                    uiViewController.calendarSyncToken = calendarSyncToken;
                }
            }
        }

        self.navigationController?.pushViewController(uiViewController, animated: true);
    }
    
    func loadUserProperties() {
        
        let queryStr = "userId=\(String(loggedInUser.userId!))";
        UserService().findUserSyncTokens(queryStr: queryStr, token: loggedInUser.token, complete: {(response) in
            
            let success = response.value(forKey: "success") as! Bool;
            if (success == true) {
                
                let calendarSyncTokenArray = response.value(forKey: "data") as! NSArray;
                print(calendarSyncTokenArray)
                self.calendarSyncTokens = CalendarSyncToken().loadCalendarSyncTokens(calendarSyncTokenArray: calendarSyncTokenArray);
                
                for calendarSyncToken in self.calendarSyncTokens {
                    if (calendarSyncToken.accountType == SelectedCalendar.HolidayCalendar) {
                        self.holidayCalendarLabel.text = "Holiday: \(calendarSyncToken.emailId!)";
                        break;
                    }
                }
                
            } else {
                self.showAlert(title: "Error", message: response.value(forKey: "message") as! String);
            }
        })
    }
}
