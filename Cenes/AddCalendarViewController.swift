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

    
    @IBOutlet var calenderButton: UIButton!
    
    @IBOutlet weak var separatorView : UIView!

    //private let scopes = [kGTLRAuthScopeCalendarReadonly]
    
    var fromSideMenu = false
    
    
    @IBOutlet weak var outlookCheckMark: UIImageView!
    
    @IBOutlet weak var googleCheckMark: UIImageView!
    
    @IBOutlet weak var appleCalCheckmark: UIImageView!
    
    
    let service = OutlookService.shared()
    
    override func viewDidLoad()
    {
        
        
        super.viewDidLoad()
        
        outlookCheckMark.image = #imageLiteral(resourceName: "checkMarkGray")
        googleCheckMark.image  = #imageLiteral(resourceName: "checkMarkGray")
        appleCalCheckmark.image = #imageLiteral(resourceName: "checkMarkGray")
        calenderButton.isUserInteractionEnabled = true
        
        separatorView.layer.shadowOffset = CGSize(width: 0, height: -1)
        separatorView.layer.shadowRadius = 1;
        separatorView.layer.shadowOpacity = 0.5;
        separatorView.layer.masksToBounds = false
        // Do any additional setup after loading the view.
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().serverClientID = "212716305349-dqqjgf3njkqt9s3ucied3bit42po3m39.apps.googleusercontent.com";
        GIDSignIn.sharedInstance().scopes = ["https://www.googleapis.com/auth/calendar",
            "https://www.googleapis.com/auth/calendar.readonly"]
        
        if fromSideMenu {
            self.navigationItem.hidesBackButton = true
            let backButton = UIButton.init(type: .custom)
            backButton.setTitle("Cancel", for: UIControlState.normal)
            backButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
            backButton.layer.cornerRadius = backButton.frame.height/2
            backButton.clipsToBounds = true
            backButton.addTarget(self, action: #selector(backButtonPressed(_:)), for: .touchUpInside)
            
            let barButton = UIBarButtonItem.init(customView: backButton)
            self.navigationItem.leftBarButtonItem = barButton
            
             self.separatorView.isHidden = true
            
            
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.getStatus()
            }
            
            
            
            
        }
        
        
    }
    
    
    func getStatus(){
        startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))
        
        WebService().calendarSyncStatus() { [weak self] (returnedDict) in
            self?.stopAnimating()
            print(returnedDict)
            if returnedDict["Error"] as? Bool == true {
                
                self?.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                
            }else{
                print(returnedDict)
            
            let resultArray = returnedDict["data"] as? NSArray
            
            for val in resultArray! {
                
                let result = val as? [String:Any]
                
                let calendarType = result?["cenesProperty"] as?  [String: Any]
                if calendarType!["name"] as? String == "device_calendar" {
                    self?.appleCalCheckmark.image = #imageLiteral(resourceName: "CheckMarkGreen")
                }else if calendarType!["name"] as? String == "outlook_calendar" {
                    self?.outlookCheckMark.image = #imageLiteral(resourceName: "CheckMarkGreen")
                }else if calendarType!["name"] as? String == "google_calendar" {
                    self?.googleCheckMark.image = #imageLiteral(resourceName: "CheckMarkGreen")
                }
            }
            }
        }
    }
    
    
    @objc func backButtonPressed(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
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
    
    
    
    @IBAction func outlookButtonPressed(_ sender: UIButton) {
        
        if (service.isLoggedIn) {
             service.logout()
        }
            // pass to webservice
        
        service.login(from: self) { (error,token, refreshToken) in
            if error == nil{
                print(token!)
                self.outLookSync(token: token!, refreshToken: refreshToken!)
                // token recieved and pass to webservie
            }else{
                if let unwrappedError = error {
                    self.showAlert(title: "Error", message: unwrappedError)
                }
            }
        }
    }
    
    
    func outLookSync(token:String, refreshToken: String){
        let webService = WebService()
        
        startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))
        
        webService.outlookEvent(outlookAuthToken: token, refreshToken: refreshToken) { (success) in
            self.stopAnimating()
            if success {
                self.showAlert(title: "Outlook Accont Sync", message: "Your Outlook Account has been synched.")
                self.outlookCheckMark.image = #imageLiteral(resourceName: "CheckMarkGreen")
            }else{
                self.showAlert(title: "Outlook Accont Sync", message: "Your Outlook Account has not been synched. Pleae try after sometime.")
            }
        }
    }

    
    @IBAction func googleButtonPressed(_ sender: UIButton) {
        
        GIDSignIn.sharedInstance().disconnect()
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    
    @IBAction func appleCalendarButtonPressed(_ sender: UIButton)
    {
        
        calenderButton.isUserInteractionEnabled = false
        var params : [String:Any]
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
                        
                        
                        
                        arrayDict.append(["title":title!,"description":description,"location":location!,"source":"Apple","createdById":uid,"timezone":"Asia/Kolkata","scheduleAs":"Event","startTime":startTime,"endTime":endTime])
                        
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
               // print("failed to save event with error : \(error!) or access not granted")
                self.showAlert(title: "Error", message: "Please provide Permission to Cenes App to access your Device Calendar.")
            }
          }
 
        
       
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!){
        if let error = error {
            print(error.localizedDescription)
            
        }else{
        
        let authentication = user.authentication
        print("Access token:", (authentication?.accessToken!)!)
        print("Refresh token:", (authentication?.refreshToken!)!)
        print("User Auth Token: ", (user?.serverAuthCode!)!)
        
        let webService = WebService()
        
        startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))

            webService.googleEvent(googleAuthToken: (authentication?.accessToken!)!, serverAuthCode: (user?.serverAuthCode!)!) { (success) in
            self.stopAnimating()
            if success {
                self.showAlert(title: "Google Accont Sync", message: "Your google Account has been synched.")
                self.googleCheckMark.image = #imageLiteral(resourceName: "CheckMarkGreen")
            }else{
                self.showAlert(title: "Google Accont Sync", message: "Your google Account has not been synched. Pleae try after sometime.")
            }
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
                self.calenderButton.isUserInteractionEnabled = true
                self.stopAnimating()
                self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                
            }else{
                self.calenderButton.isUserInteractionEnabled = true
                print(returnedDict)
                self.stopAnimating()
                self.showAlert(title: "Device Calendar Sync", message: "Your Device Calendar has been synched.")
                self.appleCalCheckmark.image = #imageLiteral(resourceName: "CheckMarkGreen")
            }
        })

    }
    
    
    
}


