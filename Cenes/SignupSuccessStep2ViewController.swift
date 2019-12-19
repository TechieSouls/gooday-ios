//
//  SignupSuccessStep2ViewController.swift
//  Deploy
//
//  Created by Cenes_Dev on 13/05/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit
import GoogleSignIn
import EventKit
import EventKitUI
import MobileCoreServices
import Photos
import Mixpanel

protocol SignupStep2FormTableViewCellProtocol {
    
    func datePickerDone(date: Date);
    func updateProfilePic(profilePicImage: UIImage);
}

protocol SignupStep2CalendarsTableViewProtocol {
    func highlightCalendarCircles(calendar: String);
}

class SignupSuccessStep2ViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var signupStep2TableView: UITableView!
    
    @IBOutlet weak var datePickerView: UIView!
    
    @IBOutlet weak var datepickerButtonBar: UIView!
    
    @IBOutlet weak var datePickerCancelButton: UIButton!
    
    @IBOutlet weak var datePickerDoneButton: UIButton!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var completeButton: UIButton!

    @IBOutlet weak var completeButtonView: UIView!
    
    var signupStep2FormTableViewCellProtocolDelegate: SignupStep2FormTableViewCellProtocol!
    var signupStep2CalendarsTableViewProtocolDelegate: SignupStep2CalendarsTableViewProtocol!
    var signupStep2FormTableViewCellDelegate: SignupStep2FormTableViewCell!;
    var loggedInUser: User!;
    var outlookService = OutlookService.shared();
    let picController = UIImagePickerController();
    var signupSuccessStep2Dto: SignupSuccessStep2Dto!;
    
    class func MainViewController() -> UINavigationController{
        
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignupStep2NavController") as! UINavigationController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        datepickerButtonBar.backgroundColor = themeColor;
        
        signupStep2TableView.register(UINib.init(nibName: "SignupStep2FormTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SignupStep2FormTableViewCell");
        
        signupStep2TableView.register(UINib.init(nibName: "SignupStep2CalendarsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SignupStep2CalendarsTableViewCell");
        
        self.hideKeyboardWhenTappedAround();
        
        self.datePicker.maximumDate = Date();
        
        loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().serverClientID = Util.GOOGLE_SERVER_ID;
        GIDSignIn.sharedInstance().scopes = ["https://www.googleapis.com/auth/calendar",
                                             "https://www.googleapis.com/auth/calendar.readonly"]
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true;
    }

    func photoIconClicked() {
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: "Help Others recognize you.", message: "Upload or Take your photo", preferredStyle: .actionSheet)
        
        let takePhotoAction: UIAlertAction = UIAlertAction(title: "Take Photo", style: .default) { action -> Void in
            self.takePicture();
        }
        takePhotoAction.setValue(cenesLabelBlue, forKey: "titleTextColor")
        
        let uploadPhotoAction: UIAlertAction = UIAlertAction(title: "Choose From Library", style: .default) { action -> Void in
            self.selectPicture();
        }
        uploadPhotoAction.setValue(selectedColor, forKey: "titleTextColor")
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        actionSheetController.addAction(takePhotoAction)
        actionSheetController.addAction(uploadPhotoAction)
        actionSheetController.addAction(cancelAction)
        
        // present an actionSheet...
        present(actionSheetController, animated: true, completion: nil)
    }
    
    func takePicture() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            self.picController.sourceType = UIImagePickerControllerSourceType.camera
            self.picController.allowsEditing = true
            self.picController.delegate = self
            self.picController.mediaTypes = [kUTTypeImage as String]
            present(picController, animated: true, completion: nil)
        }
    }
    
    func selectPicture() {
        //self.checkPermission();
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            self.picController.delegate = self
            self.picController.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            self.picController.allowsEditing = true
            self.picController.mediaTypes = [kUTTypeImage as String]
            self.present(picController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            let imageToUpload = image.fixedOrientation();
            imageToUpload.compressImage(newSizeWidth: 212, newSizeHeight: 212, compressionQuality: 1.0)
            
            signupStep2FormTableViewCellProtocolDelegate.updateProfilePic(profilePicImage: imageToUpload);

            var postData = [String: Any]();
            postData["uploadImage"] = imageToUpload;
            postData["userId"] = loggedInUser.userId!;
            UserService().uploadUserProfilePic(postData: postData, token: loggedInUser.token, complete: {(resp) in
                let success = resp.value(forKey: "success") as! Bool;
                if (success == false) {
                    self.showAlert(title: "Error", message: resp.value(forKey: "message") as! String);
                } else {
                    self.loggedInUser.photo = resp.value(forKey: "data") as! String;
                    User().updateUserValuesInUserDefaults(user: self.loggedInUser);
                }
            })
            
        }
        
        picker.dismiss(animated: true, completion: nil);
    }
    
    func highLightCompleteButton() {
         if (self.loggedInUser.gender != nil && self.loggedInUser.name != nil && self.loggedInUser.birthDayStr != nil) {
            
            completeButtonView.backgroundColor = UIColor(red:0.29, green:0.56, blue:0.89, alpha:0.75);
        }
    }
    
    func googleSyncBegins() {
        GIDSignIn.sharedInstance().disconnect()
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().signIn();
        
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
                self.signupStep2CalendarsTableViewProtocolDelegate.highlightCalendarCircles(calendar: "Outlook");

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
                    
                        DispatchQueue.global(qos: .background).async {
                            // your code here
                            UserService().syncOutlookEvents(postData: postData, token: self.loggedInUser.token, complete: {(response) in
                                print("Outlook Synced.");
                                
                                Mixpanel.mainInstance().track(event: "SyncCalendar",
                                properties:[ "CalendarType" : "Outlook", "Action" : "Sync Success", "UserEmail": "\(self.loggedInUser.email!)", "UserName": "\(self.loggedInUser.name!)"]);
                            })
                        }
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
        
        Mixpanel.mainInstance().track(event: "SyncCalendar",
        properties:[ "CalendarType" : "Apple", "Action" : "Sync Begins", "UserEmail": "\(loggedInUser.email!)", "UserName": "\(loggedInUser.name!)"]);
        
        var params : [String:Any]
        let eventStore : EKEventStore = EKEventStore()
        
        // 'EKEntityTypeReminder' or 'EKEntityTypeEvent'
        
    self.signupStep2CalendarsTableViewProtocolDelegate.highlightCalendarCircles(calendar: "Apple");
        
        var username = "Your iPhone";
        if (loggedInUser.name != nil && loggedInUser.name != "") {
            username = "\(String(loggedInUser.name.split(separator: " ")[0]))'s iPhone";
        }
        
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
                    
                    var params : [String:Any]
                    
                    var arrayDict = [NSMutableDictionary]()
                    
                    for event  in eventArray {
                        
                        let event = event as EKEvent
                        
                        let title = event.title
                        
                        var location = ""
                        if let loc = event.location{
                            location = loc
                        }

                        var description = ""
                        if let desc = event.notes{
                            description = desc
                        }
                        
                        let startTime = "\(event.startDate.millisecondsSince1970)"
                        let endTime = "\(event.endDate.millisecondsSince1970)"
                        
                        let nowDateMillis = Date().millisecondsSince1970

                        var postData: NSMutableDictionary = ["title":title!,"description":description,"location":location,"source":"Apple","createdById":"\(self.loggedInUser.userId!)","timezone":"\(TimeZone.current.identifier)","scheduleAs":"Event","startTime":startTime,"endTime":endTime,"sourceEventId":"\(event.eventIdentifier!)\(startTime)"]
                        
                        if (event.startDate.millisecondsSince1970 < nowDateMillis) {
                            
                            postData["processed"] = "\(1)";
                            arrayDict.append(postData)
                        } else {
                            
                            postData["processed"] = "\(0)";
                            arrayDict.append(postData)
                        }
                        
                    }
                    params = ["data":arrayDict]
                    params["userId"] = self.loggedInUser.userId;
                    params["name"] = username;
                    
                    //Running In Background
                    DispatchQueue.global(qos: .background).async {
                        // your code here
                        UserService().syncDeviceEvents(postData: params, token: self.loggedInUser.token, complete: {(response) in
                            print("Device Synced.")
                            
                            Mixpanel.mainInstance().track(event: "SyncCalendar",
                                                          properties:[ "CalendarType" : "Apple", "Action" : "Sync Success", "UserEmail": "\(self.loggedInUser.email!)", "UserName": "\(self.loggedInUser.name!)"]);
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
    
    @IBAction func datePickerCancelButtonPressed(_ sender: Any) {
        datePickerView.isHidden = true;
    }
    
    @IBAction func datePickerDoneButtonPressed(_ sender: Any) {
        datePickerView.isHidden = true;
        signupStep2FormTableViewCellProtocolDelegate.datePickerDone(date: datePicker.clampedDate);
    }
    
    @IBAction func completeButtonPressed(_ sender: Any) {
        
        /*if (self.loggedInUser.name == nil || self.loggedInUser.name.trimmingCharacters(in: .whitespaces) == "") {*/
            
            if (self.loggedInUser.name != nil && self.loggedInUser.name.trimmingCharacters(in: .whitespaces) != "") {
                
                self.loggedInUser.name = signupStep2FormTableViewCellDelegate.usernameField.text!
                
                var postData: [String: Any] = [String: Any]();
                postData["username"] = signupStep2FormTableViewCellDelegate.usernameField.text!;
                postData["userId"] = self.loggedInUser.userId;
                User().updateUserValuesInUserDefaults(user: self.loggedInUser);
                
                DispatchQueue.global(qos: .background).async {
                    UserService().postUserDetails(postData: postData, token: self.loggedInUser.token, complete: {(response) in
                        print("Name Updated")
                    });
                }
                
                setting.setValue(UserSteps.Authentication, forKey: "footprints")
                DispatchQueue.main.async {
                    WebService().setPushToken()
                    UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController()
                }
            } else {
                self.showAlert(title: "Name cannot be left empty", message: "");
            }
            /*} else {
            setting.setValue(UserSteps.Authentication, forKey: "footprints")
            DispatchQueue.main.async {
                WebService().setPushToken()
                UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController()
            }
        }*/
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!){
        if let error = error {
            print(error.localizedDescription)
        } else {
            
            self.signupStep2CalendarsTableViewProtocolDelegate.highlightCalendarCircles(calendar: "Google")
            
            let authentication = user.authentication
            print("Access token:", (authentication?.accessToken!)!)
            print("Refresh token:", (authentication?.refreshToken!)!)
            print("User Email : ", (user.profile.email!))
            print("User Auth Token: ", (user.serverAuthCode!))

            var postData = [String: Any]();
            postData["serverAuthCode"] = user.serverAuthCode;
            postData["userId"] = loggedInUser.userId;
            postData["email"] = user.profile.email!;
            postData["accessToken"] = authentication?.accessToken!;

            //Running in Background
            DispatchQueue.global(qos: .background).async {
                UserService().syncGoogleEvent(postData: postData, token: self.loggedInUser.token, complete: {(response) in
                    print("synced");
                    
                    Mixpanel.mainInstance().track(event: "SyncCalendar",
                    properties:[ "CalendarType" : "Google", "Action" : "Sync Success", "UserEmail": "\(self.loggedInUser.email!)", "UserName": "\(self.loggedInUser.name!)"]);
                });
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("disconnected from google")
        GIDSignIn.sharedInstance().signOut();
    }

}

extension SignupSuccessStep2ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
            case 0:
                return 435;
            case 1:
                return 200;
            default:
                return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell: SignupStep2FormTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SignupStep2FormTableViewCell") as! SignupStep2FormTableViewCell;
            cell.signupSuccessStep2ViewControllerDelegate = self;
            
            if (loggedInUser.photo != nil) {
                cell.profilePic.sd_setImage(with: URL(string: loggedInUser.photo), placeholderImage: UIImage.init(named: "profile_pic_no_miage"))
            }
            
            if (loggedInUser.gender != nil) {
                cell.gender.setTitle(loggedInUser.gender!, for: .normal);
            }
            
            if (loggedInUser.name != nil) {
                cell.usernameField.text = loggedInUser.name!;
            }
            self.signupStep2FormTableViewCellProtocolDelegate = cell;
            
            self.signupStep2FormTableViewCellDelegate = cell;
            return cell;

        case 1:
            let cell: SignupStep2CalendarsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SignupStep2CalendarsTableViewCell") as! SignupStep2CalendarsTableViewCell;
            cell.signupSuccessStep2ViewControllerDelegate = self;
            self.signupStep2CalendarsTableViewProtocolDelegate = cell;
            
            return cell;
            
        default:
            print("Default")
        }
        
        return UITableViewCell();
    }
}
