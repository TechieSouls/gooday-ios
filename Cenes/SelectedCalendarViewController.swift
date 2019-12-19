//
//  SelectedCalendarViewController.swift
//  Deploy
//
//  Created by Cenes_Dev on 10/05/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit
import GoogleSignIn
import EventKit
import EventKitUI
import Mixpanel

protocol ThirdPartyCalendarProtocol {
    func updateInfo(isSynced: Bool, email: String);
}
class SelectedCalendarViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {

    @IBOutlet weak var selectedCalendarTableView: UITableView!
    
    var calendarSelected: String!;
    var isSynced: Bool = false;
    var holidayCountries: [String]!;
    var loggedInUser: User!;
    var calendarSyncToken: CalendarSyncToken!;
    var outlookService = OutlookService.shared();
    var thirdPartyCalendarProtocolDelegate: ThirdPartyCalendarProtocol!
    var activityIndicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = themeColor;
        selectedCalendarTableView.backgroundColor = themeColor;
        
        selectedCalendarTableView.register(UINib.init(nibName: "ThirdPartyCalendarTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ThirdPartyCalendarTableViewCell");
        
        selectedCalendarTableView.register(UINib.init(nibName: "HolidayCalendarTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "HolidayCalendarTableViewCell");
        
        self.title = "\(String(calendarSelected)) Calendar";
        
        loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().serverClientID = Util.GOOGLE_SERVER_ID;
        GIDSignIn.sharedInstance().scopes = ["https://www.googleapis.com/auth/calendar","https://www.googleapis.com/auth/calendar.readonly"]
        //Cenes App
        //212716305349-dqqjgf3njkqt9s3ucied3bit42po3m39.apps.googleusercontent.com
        
        //New Beta
        //54828242588-8qk7si330grto3qo9ddek6e5q2j0dmdh.apps.googleusercontent.com

        activityIndicator.activityIndicatorViewStyle = .gray;
        activityIndicator.center = view.center;
        self.view.addSubview(activityIndicator);
        
        loadUserProperties();
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false;
    }

    func loadUserProperties() {
        
        let queryStr = "userId=\(String(loggedInUser.userId!))";
        UserService().findUserSyncTokens(queryStr: queryStr, token: loggedInUser.token, complete: {(response) in
            
            let success = response.value(forKey: "success") as! Bool;
            if (success == true) {
                
                let calendarSyncTokenArray = response.value(forKey: "data") as! NSArray;
                print(calendarSyncTokenArray)
                var calendarSyncTokens = CalendarSyncToken().loadCalendarSyncTokens(calendarSyncTokenArray: calendarSyncTokenArray);
                
                for calSyncTok in calendarSyncTokens {
                    if (calSyncTok.accountType == self.calendarSelected) {
                        self.calendarSyncToken = calSyncTok;
                        break;
                    }
                }
                self.selectedCalendarTableView.reloadData();
            } else {
                self.showAlert(title: "Error", message: response.value(forKey: "message") as! String);
            }
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func googleSyncBegins() {
        GIDSignIn.sharedInstance().disconnect()
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().signIn()
        
        Mixpanel.mainInstance().track(event: "SyncCalendar",
        properties:[ "CalendarType" : "Google", "Action" : "Sync Begins", "UserEmail": "\(loggedInUser.email!)", "UserName": "\(loggedInUser.name!)"]);
    }
    
    func outlookSyncBegins() {
        if (outlookService.isLoggedIn) {
            outlookService.logout()
        }
        // pass to webservice
        Mixpanel.mainInstance().track(event: "SyncCalendar",
               properties:[ "CalendarType" : "Outlook", "Action" : "Sync Begins", "UserEmail": "\(loggedInUser.email!)", "UserName": "\(loggedInUser.name!)"]);
        outlookService.login(from: self) { (error,token, refreshToken) in
            if error == nil{

                print(token!)
                //self.outLookSync(token: token!, refreshToken: refreshToken!)
                // token recieved and pass to webservie
                
                var postData = [String: Any]();
                postData["accessToken"] = token!;
                postData["refreshToken"] = refreshToken!;
                postData["userId"] = self.loggedInUser.userId;

                self.outlookService.getUserEmail() {
                    email in
                    if let unwrappedEmail = email {
                        postData["email"] = unwrappedEmail;
                        NSLog("Hello \(unwrappedEmail)")
                        
                        self.isSynced = true;
                        self.thirdPartyCalendarProtocolDelegate.updateInfo(isSynced: true, email: unwrappedEmail)

                        self.activityIndicator.startAnimating();
                        UIApplication.shared.beginIgnoringInteractionEvents()

                        //DispatchQueue.global(qos: .background).async {
                            // your code here
                            UserService().syncOutlookEvents(postData: postData, token: self.loggedInUser.token, complete: {(response) in
                                print("Outlook Synced.")
                                let success = response.value(forKey: "success") as! Bool;
                                if (success == true) {
                                    
                                    Mixpanel.mainInstance().track(event: "SyncCalendar",
                                                                  properties:[ "CalendarType" : "Outlook", "Action" : "Sync Success", "UserEmail": "\(self.loggedInUser.email!)", "UserName": "\(self.loggedInUser.name!)"]);CalendarSyncToken().updateCalendarSettingDefault(calendarName: self.calendarSelected, isSynced: true);
                                    
                                    let calendarSyncDict = response.value(forKey: "data") as! NSDictionary;
                                    
                                    self.calendarSyncToken = CalendarSyncToken().loadCalendarSyncToken(calendarSyncTokenDict: calendarSyncDict);
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                                    
                                    UIApplication.shared.endIgnoringInteractionEvents();

                                    self.activityIndicator.stopAnimating();
                                    self.showAlert(title: "Account Synced", message: "");
                                    
                                    if let cenesTabBarViewControllers = self.tabBarController!.viewControllers {
                                        
                                        let homeViewController = (cenesTabBarViewControllers[0] as? UINavigationController)?.viewControllers.first as? NewHomeViewController
                                        homeViewController?.refershDataFromOtherScreens();
                                    }
                                });
                            })
                        //}
                    }
                }
                
            }else{
                if let unwrappedError = error {
                    self.showAlert(title: "Error", message: unwrappedError)
                }
            }
        }
    }
    
    func appleSyncBegins() {
        var params : [String:Any]
        let eventStore : EKEventStore = EKEventStore()
        
        Mixpanel.mainInstance().track(event: "SyncCalendar",
               properties:[ "CalendarType" : "Apple", "Action" : "Sync Begins", "UserEmail": "\(loggedInUser.email!)", "UserName": "\(loggedInUser.name!)"]);
        // 'EKEntityTypeReminder' or 'EKEntityTypeEvent'
        let name = "\(String(loggedInUser.name.split(separator: " ")[0]))'s iPhone";
        self.isSynced = true;
        self.thirdPartyCalendarProtocolDelegate.updateInfo(isSynced: true, email: name)
        
        
        eventStore.requestAccess(to: .event) { (granted, error) in
            
            if (granted) && (error == nil) {
            
                 print("granted \(granted)")
                print("error \(error)")
                
                let calendar = Calendar.current
                
                var datecomponent = DateComponents()
                datecomponent.year = 1
                var endDate = calendar.date(byAdding: datecomponent, to: Date())
                
                let calendars = eventStore.calendars(for: .event)
                
                var newCalendar = [EKCalendar]()
                
                for calendar in calendars {
                    if calendar.title == "Work" || calendar.title == "Home"{
                        //      newCalendar.append(calendar)
                    }
                    newCalendar.append(calendar)
                }
                
                let predicate = eventStore.predicateForEvents(withStart: Date(), end: endDate!, calendars: newCalendar)
                
                let userid = setting.value(forKey: "userId") as! NSNumber
                let uid = "\(userid)"
                let eventArray = eventStore.events(matching: predicate)
                
                if eventArray.count > 0 {
                    
                    var arrayDict = [NSMutableDictionary]()
                    
                    for event  in eventArray {
                        
                        let event = event as EKEvent
                        
                        print(event.eventIdentifier);
                        
                        if (event.isAllDay == true) {
                            continue;
                        }
                        let title = event.title
                        
                        let location = event.location
                        
                        var description = ""
                        if let desc = event.notes{
                            description = desc
                        }
                        
                        let startTime = "\(event.startDate.millisecondsSince1970)"
                        let endTime = "\(event.endDate.millisecondsSince1970)"
                       
                        
                        let nowDateMillis = Date().millisecondsSince1970
                        
                        
                        var postData: NSMutableDictionary = ["title":title!,"description":description,"location":location!,"source":"Apple","createdById":uid,"timezone":"\(TimeZone.current.identifier)","scheduleAs":"Event","startTime":startTime,"endTime":endTime,"sourceEventId":"\(event.eventIdentifier!)\(startTime)"]

                        if (event.startDate.millisecondsSince1970 < nowDateMillis) {
                            
                            postData["processed"] = "\(1)";
                            arrayDict.append(postData)
                        } else {
                           
                            postData["processed"] = "\(0)";
                            arrayDict.append(postData)
                        }
                    }
                
                    var params =  [String:Any]();
                    params["data"]  = arrayDict;
                    params["userId"] = self.loggedInUser.userId;
                    params["name"] = name;

                    DispatchQueue.main.async {
                        self.activityIndicator.startAnimating();
                        UIApplication.shared.beginIgnoringInteractionEvents()
                    }
                    //Running In Background
                    //DispatchQueue.global(qos: .background).async {
                        // your code here
                        UserService().syncDeviceEvents(postData: params, token: self.loggedInUser.token, complete: {(response) in
                            print("Device Synced.")

                            let success = response.value(forKey: "success") as! Bool;
                            if (success == true) {
                                let calendarSyncDict = response.value(forKey: "data") as! NSDictionary;

                                Mixpanel.mainInstance().track(event: "SyncCalendar",
                                                              properties:[ "CalendarType" : "Apple", "Action" : "Sync Success", "UserEmail": "\(self.loggedInUser.email!)", "UserName": "\(self.loggedInUser.name!)"]);
                                
                                self.calendarSyncToken = CalendarSyncToken().loadCalendarSyncToken(calendarSyncTokenDict: calendarSyncDict);
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                                UIApplication.shared.endIgnoringInteractionEvents();
                                self.activityIndicator.stopAnimating();
                                self.showAlert(title: "Account Synced", message: "");

                                if let cenesTabBarViewControllers = self.tabBarController!.viewControllers {
                                    
                                    let homeViewController = (cenesTabBarViewControllers[0] as? UINavigationController)?.viewControllers.first as? NewHomeViewController
                                    homeViewController?.refershDataFromOtherScreens();
                                }
                            });

                        })
                    //}
                } else {
                    
                    
                    var params =  [String:Any]();
                    params["data"]  = [NSMutableDictionary]();
                    params["userId"] = self.loggedInUser.userId;
                    params["name"] = name;

                    //Running In Background
                    DispatchQueue.global(qos: .background).async {
                        // your code here
                        UserService().syncDeviceEvents(postData: params, token: self.loggedInUser.token, complete: {(response) in
                            print("Device Synced.")
                            self.showAlert(title: "Account Synced", message: "");

                            let success = response.value(forKey: "success") as! Bool;
                            if (success == true) {
                                
                                CalendarSyncToken().updateCalendarSettingDefault(calendarName: self.calendarSelected, isSynced: true);
                                
                                let calendarSyncDict = response.value(forKey: "data") as! NSDictionary;
                                
                                self.calendarSyncToken = CalendarSyncToken().loadCalendarSyncToken(calendarSyncTokenDict: calendarSyncDict);
                            }
                            
                        })
                    }
                    
                }
            }
            else{
                // print("failed to save event with error : \(error!) or access not granted")
                self.showAlert(title: "Error", message: "Please provide Permission to Cenes App to access your Device Calendar.")
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!){
        if let error = error {
            print(error.localizedDescription)
        } else {
            
            let authentication = user.authentication
            print("Access token:", (authentication?.accessToken!)!)
            print("Refresh token:", (authentication?.refreshToken!)!)
            print("User Email : ", (user.profile.email!))
            print("User Auth Token: ", (user.serverAuthCode!))
            
            isSynced = true;
            self.thirdPartyCalendarProtocolDelegate.updateInfo(isSynced: true, email: user.profile.email)

            var postData = [String: Any]();
            postData["serverAuthCode"] = user.serverAuthCode;
            postData["userId"] = loggedInUser.userId;
            postData["email"] = user.profile.email!;
            postData["accessToken"] = authentication?.accessToken!;
            
            //Running in Background
            //DispatchQueue.global(qos: .background).async {
            activityIndicator.startAnimating();
            UIApplication.shared.beginIgnoringInteractionEvents()

                UserService().syncGoogleEvent(postData: postData, token: self.loggedInUser.token, complete: {(response) in
                    print("synced");
                    let success = response.value(forKey: "success") as! Bool;
                    if (success == true) {
                        let calendarSyncDict = response.value(forKey: "data") as! NSDictionary;
                        
                        Mixpanel.mainInstance().track(event: "SyncCalendar",
                                                      properties:[ "CalendarType" : "Google", "Action" : "Sync Success", "UserEmail": "\(self.loggedInUser.email!)", "UserName": "\(self.loggedInUser.name!)"]);
                        self.calendarSyncToken = CalendarSyncToken().loadCalendarSyncToken(calendarSyncTokenDict: calendarSyncDict);
                    }
                    
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                        CalendarSyncToken().updateCalendarSettingDefault(calendarName: self.calendarSelected, isSynced: true);
                        
                        UIApplication.shared.endIgnoringInteractionEvents();
                        self.activityIndicator.stopAnimating();
                        self.showAlert(title: "Account Synced", message: "");
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadHomeScreen"), object: nil);
                        /*if let cenesTabBarViewControllers = self.tabBarController!.viewControllers {
                            
                            let homeViewController = (cenesTabBarViewControllers[0] as? UINavigationController)?.viewControllers.first as? NewHomeViewController
                            homeViewController?.refershDataFromOtherScreens();
                            
                        }*/
                    });

                });
            //}
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("disconnected from google")
        GIDSignIn.sharedInstance().signOut();
    }

    func deleteSyncBySyncId(syncId: Int32) {
        
        activityIndicator.startAnimating();
        UIApplication.shared.beginIgnoringInteractionEvents()

        let queryStr = "calendarSyncTokenId=\(String(syncId))";
        UserService().deleteSyncTokenByTokenId(queryStr: queryStr, token: loggedInUser.token) {(response) in
            print("Deleted");
            self.isSynced = false;
            self.thirdPartyCalendarProtocolDelegate.updateInfo(isSynced: false, email: "");
            CalendarSyncToken().updateCalendarSettingDefault(calendarName: self.calendarSelected, isSynced: false);

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                UIApplication.shared.endIgnoringInteractionEvents();

                self.activityIndicator.stopAnimating();
                self.showAlert(title: "Account Deleted", message: "");
                
                if let cenesTabBarViewControllers = self.tabBarController!.viewControllers {
                    
                    let homeViewController = (cenesTabBarViewControllers[0] as? UINavigationController)?.viewControllers.first as? NewHomeViewController
                    homeViewController?.refershDataFromOtherScreens();
                }
            });
        }
        
    }
}

class SelectedCalendar {
    static let HolidayCalendar: String = "Holiday";
    static let GoogleCalendar: String = "Google";
    static let OutlookCalendar: String = "Outlook";
    static let AppleCalendar: String = "Apple"
    
}
