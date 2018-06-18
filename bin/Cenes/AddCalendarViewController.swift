//
//  AddCalendarViewController.swift
//  Cenes
//
//  Created by Ashutosh Tiwari on 8/28/17.
//  Copyright © 2017 Sabita Rani Samal. All rights reserved.
//

import UIKit
import IoniconsSwift
import GoogleSignIn
import EventKit
import EventKitUI
import NVActivityIndicatorView

class AddCalendarViewController: UIViewController,GIDSignInDelegate, GIDSignInUIDelegate,NVActivityIndicatorViewable {

    @IBOutlet weak var calendarTableView : UITableView!
    
    @IBOutlet weak var separatorView : UIView!

    //private let scopes = [kGTLRAuthScopeCalendarReadonly]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        separatorView.layer.shadowOffset = CGSize(width: 0, height: -1)
        separatorView.layer.shadowRadius = 1;
        separatorView.layer.shadowOpacity = 0.5;
        separatorView.layer.masksToBounds = false
        // Do any additional setup after loading the view.
        calendarTableView.tableFooterView = UIView()
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = ["https://www.googleapis.com/auth/calendar",
            "https://www.googleapis.com/auth/calendar.readonly"]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction  func userDidSelectNext() {
        UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController()
    }
    
     func userDidSelectLater() {
        UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController()
    }
    
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!){
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        let authentication = user.authentication
        print("Access token:", (authentication?.accessToken!)!)
        
        let webService = WebService()
        
        startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))

        webService.googleEvent(googleAuthToken: (authentication?.accessToken!)!) { (success) in
            self.stopAnimating()
            if success {
                self.showAlert(title: "Google Accont Sync", message: "Your google Account has been synched.")
            }else{
                self.showAlert(title: "Google Accont Sync", message: "Your google Account has not been synched. Pleae try after sometime.")
            }
        }
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("disconnected from google")
    }
    
    
    func callWebservice(params:[String:Any]){
        startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))
        WebService().syncDeviceCalendar(uploadDict: params, complete: { (returnedDict) in
            
            if returnedDict.value(forKey: "Error") as? Bool == true {
                self.stopAnimating()
                self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                
            }else{
                print(returnedDict)
                
                self.stopAnimating()
            }
        })

    }
    
    
    
}

extension AddCalendarViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            //GIDSignIn.sharedInstance().uiDelegate = self
            GIDSignIn.sharedInstance().signIn()
        }else if indexPath.row == 2 {
            let eventStore : EKEventStore = EKEventStore()
            
            // 'EKEntityTypeReminder' or 'EKEntityTypeEvent'
            
            eventStore.requestAccess(to: .event) { (granted, error) in
                
                if (granted) && (error == nil) {
                    print("granted \(granted)")
                    print("error \(error)")
                    
                    let calendar = Calendar.current
                    
                    var datecomponent = DateComponents()
                    datecomponent.day = 30
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
                    
                    print(eventArray.description)
                    
                    if eventArray.count > 0 {
                        
                        var params : [String:Any]
                        
                        var arrayDict = [NSMutableDictionary]()
                        
                        for event  in eventArray {
                            
                            let event = event as EKEvent
                            
                            let title = event.title
                            
                            let location = event.location
                            
                            var description = ""
                            if let desc = event.notes{
                                description = desc
                            }
                            
                            let startTime = "\(event.startDate.millisecondsSince1970)"
                            let endTime = "\(event.endDate.millisecondsSince1970)"
                            print(event.notes!)
                            
                            
                            
                            arrayDict.append(["title":title,"description":description,"location":location!,"source":"Apple","createdById":uid,"timezone":"Asia/Kolkata","scheduleAs":"Event","startTime":startTime,"endTime":endTime])
                            
                        }
                        params = ["data":arrayDict]
                        print(params)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            // your code here
                            self.callWebservice(params: params)
                        }
                        
                       }
                }
                else{
                    print("failed to save event with error : \(error) or access not granted")
                    self.showAlert(title: "Error", message: "Please provide Permission to Cenes App to access your Device Calendar.")
                }
            }
        }
        
    }
}

extension AddCalendarViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "calendarCell")
        switch indexPath.row {
        case 0:
            cell?.textLabel?.text = "Google Calendar"
            cell?.imageView?.image = Ionicons.iosCalendarOutline.image(30, color: UIColor.red)
            break
        case 1:
            cell?.textLabel?.text = "Outlook"
            cell?.imageView?.image = Ionicons.iosCalendarOutline.image(30, color: UIColor.blue)

            break
        case 2:
            cell?.textLabel?.text = "Calendar"
            cell?.imageView?.image = Ionicons.iosCalendarOutline.image(30, color: UIColor.red)

            break
        default:
            break
        }
        return cell!
    }
    
}
