//
//  CreateGatheringViewController.swift
//  Cenes
//
//  Created by Redblink on 05/09/17.
//  Copyright © 2017 Sabita Rani Samal. All rights reserved.
//

import UIKit
import MobileCoreServices
import NVActivityIndicatorView
import MessageUI

@objc protocol CreateGatheringViewControllerDelegate : class {
@objc optional    func setEventImage(image : UIImage)
@objc optional    func setDateTimeValues(tag:PickerType, value:String)
    
}

enum CellHeight : CGFloat {
    case First          = 45
    case Second         = 179
    case Third          = 383
    case Fourth         = 44.5
    case Fifth          = 475
}

@objc enum PickerType : Int {
    case StartDate      = 0
    case EndDate        = 1
    case StartTime      = 2
    case EndTime        = 3
}


class CreateGatheringViewController: UIViewController,UIImagePickerControllerDelegate ,UINavigationControllerDelegate,GatheringEventCellDelegate,NVActivityIndicatorViewable, MFMessageComposeViewControllerDelegate {

    var nactvityIndicatorView = NVActivityIndicatorView.init(frame: cgRectSizeLoading, type: NVActivityIndicatorType.lineScaleParty, color: UIColor.white, padding: 0.0);
    
    @IBOutlet weak var gatheringTableView: UITableView!
    
    var event: Event = Event();
    var loggedInUser: User = User();
    
    var gatheringImage : UIImage!
    
    var gatheringImageURL : String!
    
    var gatheringDelegate : CreateGatheringViewControllerDelegate!
    
    var cellHeightTime : CellHeight!
    
    var closeCheck = false
    
    var locationName = ""
    
    var selectedLocation: LocationModel!
    
    @IBOutlet weak var pickerOuterView: UIView!
    
    @IBOutlet weak var dateTimePicker: UIDatePicker!
    
    var pickerType : PickerType!
    
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    var FriendArray = [CenesUser]()
    
    var nonCenesUsers: [UserContact] = [];
    
    var isOwner = true
    
    var summaryBool = false
    
    var loadSummary = false
    
    var editSummary = false
    
    var eventId : String!
    
    var predictiveData : NSMutableArray!
    
    var selectedDate  : Date!
    var FirstDate : Date!
    var SecondDate: Date!
    
    var startTime: String!
    var endTime: String!
    
    let picController = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        gatheringTableView.register(UINib(nibName: "GatheringTitleTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "GatheringTitleTableViewCell")
        gatheringTableView.register(UINib(nibName: "GatheringPeopleTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "GatheringPeopleTableViewCell")
        gatheringTableView.register(UINib(nibName: "GatheringDateTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "GatheringDateTableViewCell")
        gatheringTableView.register(UINib(nibName: "GatheringLocationTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "GatheringLocationTableViewCell")
        gatheringTableView.register(UINib(nibName: "GatheringDescTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "GatheringDescTableViewCell")
        gatheringTableView.register(UINib(nibName: "GatheringEventTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "GatheringEventTableViewCell")
        gatheringTableView.register(UINib(nibName: "DeleteCell", bundle: Bundle.main), forCellReuseIdentifier: "DeleteCell")
        // Do any additional setup after loading the view.
        
        gatheringTableView.rowHeight = UITableViewAutomaticDimension
        gatheringTableView.estimatedRowHeight = 140
        gatheringTableView.keyboardDismissMode = .interactive
                    
        cellHeightTime = CellHeight.First
        if summaryBool == true {
            cellHeightTime = CellHeight.Fifth
        }
        self.pickerOuterView.isHidden = true
        self.selectedDate = Date();
         self.setUpNavBar()
        
        self.loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        //If user is creating new event
        if (self.loggedInUser != nil && self.event.eventId == nil) {
            self.event.createdById = self.loggedInUser.userId;
        }
    }
    
    
    
    func setUpNavBar() {
        self.navigationController?.isNavigationBarHidden = false;

        if self.editSummary == true {
            let backButton = UIButton.init(type: .custom)
            self.title = "Edit Gathering"
            backButton.setTitle("Cancel", for: UIControlState.normal)
            backButton.setTitleColor(UIColor.black, for: .normal)
            backButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
            backButton.layer.cornerRadius = backButton.frame.height/2
            backButton.clipsToBounds = true
            backButton.addTarget(self, action: #selector(stopButtonPressed(_:)), for: .touchUpInside)
            
            let barButton = UIBarButtonItem.init(customView: backButton)
            self.navigationItem.leftBarButtonItem = barButton
            
            let nextButton = UIButton.init(type: .custom)
            
            nextButton.setTitle("Save", for: .normal)
            nextButton.setTitleColor(cenesLabelBlue, for: .normal)
            nextButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
            nextButton.layer.cornerRadius = nextButton.frame.height/2
            nextButton.clipsToBounds = true
            nextButton.addTarget(self, action: #selector(createGatheringbuttonPressed(_:)), for: .touchUpInside)
            let rightButton = UIBarButtonItem.init(customView: nextButton)
            
            self.navigationItem.rightBarButtonItem = rightButton
            
        } else if self.summaryBool {
        
        let backButton = UIButton.init(type: .custom)
        self.title = "Gathering Summary"
        backButton.setImage(#imageLiteral(resourceName: "leftArrow"), for: UIControlState.normal)
        backButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        backButton.layer.cornerRadius = backButton.frame.height/2
        backButton.clipsToBounds = true
            backButton.addTarget(self, action: #selector(stopButtonPressed(_:)), for: .touchUpInside)
        
        let barButton = UIBarButtonItem.init(customView: backButton)
        self.navigationItem.leftBarButtonItem = barButton
         
            let nextButton = UIButton.init(type: .custom)
            
            nextButton.setTitle("Edit", for: .normal)
            nextButton.setTitleColor(cenesLabelBlue, for: .normal)
            nextButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
            nextButton.layer.cornerRadius = nextButton.frame.height/2
            nextButton.clipsToBounds = true
            nextButton.addTarget(self, action: #selector(CreateGatheringViewController.setEditSummary), for: .touchUpInside)
            let rightButton = UIBarButtonItem.init(customView: nextButton)
            
            var items: [UIBarButtonItem] = [];
            
            if self.isOwner == true {
                //self.navigationItem.rightBarButtonItem = rightButton
                items.append(rightButton);
            }
            
            
            let shareEventBtn = UIButton(type: .custom)
            let eventShareImg = UIImage(named: "event_share_icon");
            shareEventBtn.setImage(eventShareImg, for: .normal)
            shareEventBtn.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            shareEventBtn.addTarget(self, action: #selector(CreateGatheringViewController.shareEventUrl), for: .touchUpInside)
            let shareBtn = UIBarButtonItem(customView: shareEventBtn)
            items.append(shareBtn);
            
            self.navigationItem.setRightBarButtonItems(items, animated: true)
        }else{
            
            self.title = "Add Gathering"
            
            
            let nextButton = UIButton.init(type: .custom)
            
            nextButton.setTitle("Preview", for: UIControlState.normal)
            nextButton.setTitleColor(cenesLabelBlue, for: .normal)
            nextButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
            nextButton.layer.cornerRadius = nextButton.frame.height/2
            nextButton.clipsToBounds = true
            //nextButton.addTarget(self, action: #selector(createGatheringbuttonPressed(_:)), for: .touchUpInside)
            
            nextButton.addTarget(self, action: #selector(showGatheringPreview(_:)), for: .touchUpInside)
            let rightButton = UIBarButtonItem.init(customView: nextButton)
            
            
            self.navigationItem.rightBarButtonItem = rightButton
            
            let cancelButton = UIButton.init(type: .custom)
            cancelButton.setTitle("Cancel", for: .normal)
            cancelButton.setTitleColor(UIColor.black, for: .normal)
            cancelButton.frame = CGRect.init(x: 0, y: 0, width: 25, height: 25)
            cancelButton.layer.cornerRadius = nextButton.frame.height/2
            cancelButton.clipsToBounds = true
            cancelButton.addTarget(self, action: #selector(stopButtonPressed(_:)), for: .touchUpInside)
            
            
            let leftButton = UIBarButtonItem.init(customView: cancelButton)
            self.navigationItem.leftBarButtonItem = leftButton
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.backgroundColor = themeColor;
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.black]
        self.navigationController?.navigationBar.backgroundColor = themeColor
        self.navigationController?.navigationBar.tintColor = themeColor;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.gatheringTableView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.tableViewBottomConstraint.constant = keyboardSize.height
            
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.tableViewBottomConstraint.constant  = 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    @IBAction func stopButtonPressed(_ sender: Any) {
        if !closeCheck {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // share text
    @IBAction func shareEventUrl(_ sender: UIButton) {
        
        // text to share
        let text = cenesWebUrl+"/event/"+eventId;
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    @objc func setEditSummary(){
        self.loadSummary = false
        self.summaryBool = false
        self.editSummary = true
        self.setUpNavBar()
        self.cellHeightTime = CellHeight.Third
        self.gatheringTableView.reloadData()
    }
    
    @IBAction func showGatheringPreview(_ sender: Any) {
        
        if (self.event.title == nil) {
            self.showAlert(title: "Event Title", message: "Please fill the event title.")
            return
        }
        
        self.performSegue(withIdentifier: "showGatheringPreview", sender: self)
    }
    
    @IBAction func createGatheringbuttonPressed(_ sender: Any) throws {
       
        var predictiveDict = [NSMutableDictionary]()
        var predictiveString : String!
        
        
        print("EVENT JSON : \(Event().toDictionary(event: event))")
        
        return;
		
        if self.event.isPredictiveOn {
            
            for result in self.predictiveData {
                let dict = NSMutableDictionary(dictionary: (result as? NSDictionary)!)
                predictiveDict.append(dict)
            }
            
            let data =  try! JSONSerialization.data(withJSONObject: predictiveDict, options: [])
            predictiveString = String(data:data, encoding:.utf8)!
            
        }
        
        
        /*if self.eventName == "" {
            self.showAlert(title: "Event Title", message: "Please fill the event title.")
            return
        }*/
        
    
        
        //if self.cellHeightTime == CellHeight.Fourth {
        if (self.selectedDate != nil) {
            
            //Duni Code
            /*if self.startTime == nil {
                self.startTime = "\(FirstDate.millisecondsSince1970)"
            }
            if self.endTime == nil {
                self.endTime = "\(SecondDate.millisecondsSince1970)"
            }*/
            
            print("Start Time : \(self.startTime), End Time : \(self.endTime)");
            let userid = setting.value(forKey: "userId") as! NSNumber
            let uid = "\(userid)"
            
            
            
            
            var eventMembers = [NSMutableDictionary]()
            
            for userContact in self.event.eventMembers {
               
                if (userContact.cenesMember == "no") {
                    continue;
                }
                let dict = NSMutableDictionary()
                
                dict["name"] = userContact.name
                dict["userId"] = userContact.userId
                
                if let status = userContact.status {
                    dict["status"] = status
                }
                
                let id = "\((setting.value(forKey: "userId") as? NSNumber)!)"
                if "\(userContact.userId)" == id {
                    continue
                }
                if userContact.user != nil {
                    dict["picture"] = userContact.user.photo;
                }
                eventMembers.append(dict)
            }
            
            let dict = NSMutableDictionary()
            
            if(setting.value(forKey: "photo") != nil){
                dict["picture"] = setting.value(forKey: "photo") as? String
            }
            
            if(setting.value(forKey: "name") != nil){
                dict["name"] = setting.value(forKey: "name") as? String
            }

            if(setting.value(forKey: "userId") != nil){
                dict["userId"] = setting.value(forKey: "userId")
            }
            
            dict["status"] = "Going"
           // if self.editSummary == false {
                eventMembers.append(dict)
           // }
            
            
            
            
            
            if (self.gatheringImage != nil && self.gatheringImageURL == nil) {
                
                startAnimating(loadinIndicatorSize, message: "Loading...", type: self.nactvityIndicatorView.type)
                let uploadImage = self.gatheringImage.compressImage(newSizeWidth: 512, newSizeHeight: 512, compressionQuality: 1.0)
                
                GatheringService().uploadEventImage(image: uploadImage, complete: { (returnedDict) in
                    
                    if returnedDict.value(forKey: "Error") as? Bool == true {
                        self.stopAnimating()
                        self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                        
                    }else{
                        print(returnedDict)
                        
                        let eventPictureUrl = (returnedDict["data"] as! NSDictionary)["eventPicture"]
                        
                        var params : [String:Any]
                        
                        if eventMembers.count > 0 {
                            if self.event.isPredictiveOn == true {
                                params   = ["title":self.event.title,"description":self.event.description,"location":(self.selectedLocation != nil && self.selectedLocation.locationName != "No Location for event") ? self.selectedLocation.locationName:"","latitude": (self.selectedLocation != nil && self.selectedLocation.latitude != nil) ? self.selectedLocation.latitude:"","longitude":(self.selectedLocation != nil && self.selectedLocation.longitude != nil) ? self.selectedLocation.longitude:"","source":"Cenes","createdById":uid,"timezone":"Asia/Kolkata","scheduleAs":"Gathering","startTime":self.startTime,"endTime":self.endTime,"eventPicture":eventPictureUrl!,"eventMembers":eventMembers,"isPredictiveOn":1,"predictiveData":predictiveString]
                            }else{
                                params   = ["title":self.event.title,"description":self.event.description,"location":(self.selectedLocation != nil && self.selectedLocation.locationName != "No Location for event") ? self.selectedLocation.locationName:"","latitude":(self.selectedLocation != nil && self.selectedLocation.latitude != nil) ? self.selectedLocation.latitude:"","longitude":(self.selectedLocation != nil && self.selectedLocation.longitude != nil) ? self.selectedLocation.longitude:"","source":"Cenes","createdById":uid,"timezone":"Asia/Kolkata","scheduleAs":"Gathering","startTime":self.startTime,"endTime":self.endTime,"eventPicture":eventPictureUrl!,"eventMembers":eventMembers,"isPredictiveOn":0]
                            }
                          
                        }else{
                            
                            if self.event.isPredictiveOn == true {
                                params    = ["title":self.event.title,"description":self.event.description,"location":(self.selectedLocation != nil && self.selectedLocation.locationName != "No Location for event") ? self.selectedLocation.locationName:"","latitude":(self.selectedLocation != nil && self.selectedLocation.latitude != nil ) ? self.selectedLocation.latitude:"","longitude":(self.selectedLocation != nil && self.selectedLocation.longitude != nil) ? self.selectedLocation.longitude:"","source":"Cenes","createdById":uid,"timezone":"Asia/Kolkata","scheduleAs":"Gathering","startTime":self.startTime,"endTime":self.endTime,"eventPicture":eventPictureUrl!,"isPredictiveOn":1,"predictiveData":predictiveString]
                            }else{
                                params    = ["title":self.event.title,"description":self.event.description,"location":(self.selectedLocation != nil && self.selectedLocation.locationName != "No Location for event") ? self.selectedLocation.locationName:"","latitude":self.selectedLocation.latitude != nil ? self.selectedLocation.latitude:"","longitude":self.selectedLocation.longitude != nil ? self.selectedLocation.longitude:"","source":"Cenes","createdById":uid,"timezone":"Asia/Kolkata","scheduleAs":"Gathering","startTime":self.startTime,"endTime":self.endTime,"eventPicture":eventPictureUrl!,"isPredictiveOn":0]
                            }
                            
                         
                        }
                        
                        if self.editSummary == true{
                            params["eventId"] = self.eventId
                            
                        }
                        
                            GatheringService().createGathering(uploadDict: params, complete: { (returnedDict) in
                                self.stopAnimating()
                                
                            if returnedDict.value(forKey: "Error") as? Bool == true {
                               
                                self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                                
                            }else{
                                
                                print("Got result from webservice\(returnedDict)")
                                let dict = returnedDict["data"] as? NSDictionary
                                if dict?.value(forKey: "eventId")! != nil {
                                    self.eventId = "\((dict?.value(forKey: "eventId")! as? NSNumber)!)"
                                }
                                
                                
                                if self.nonCenesUsers.count > 0 {
                                    
                                    var phoneNumbers: String = "";
                                    for userContact in self.nonCenesUsers {
                                        phoneNumbers = "\(userContact.phone),\(phoneNumbers)";
                                    }
                                    //self.sendSMSText(phoneNumber: phoneNumbers.substring(toIndex: phoneNumbers.count-1));
                                    
                                    self.sendSMSText(phoneNumber: String(phoneNumbers.prefix(phoneNumbers.count - 1)));
                                }
                                
                                
                                
                                self.summaryBool = true
                                self.loadSummary = true
                                self.editSummary = false
                                self.cellHeightTime =  CellHeight.Fifth
                                self.gatheringTableView.reloadData()
                                self.setUpNavBar()
                                self.navigationController?.popViewController(animated: true)
                               
                            }
                        })
                    }
                })

            }else{
                
                var params : [String:Any]
                
                if eventMembers.count > 0 {
                     if self.event.isPredictiveOn == true {
                        params = ["title":self.event.title,"description":self.event.description,"location":(self.selectedLocation != nil && self.selectedLocation.locationName != "No Location for event") ? self.selectedLocation.locationName:"","latitude": (self.selectedLocation != nil && self.selectedLocation.latitude != nil) ? self.selectedLocation.latitude:"","longitude":(self.selectedLocation != nil &&  self.selectedLocation.longitude != nil) ? self.selectedLocation.longitude:"","source":"Cenes","createdById":uid,"timezone":"Asia/Kolkata","scheduleAs":"Gathering","startTime":self.startTime,"endTime":self.endTime,"eventMembers":eventMembers,"isPredictiveOn":1,"predictiveData":predictiveString]
                     }else{
                        params = ["title":self.event.title,"description":self.event.description,"location":(self.selectedLocation != nil && self.selectedLocation.locationName != "No Location for event") ? self.selectedLocation.locationName:"","latitude": (self.selectedLocation != nil && self.selectedLocation.latitude != nil) ? self.selectedLocation.latitude:"","longitude": (self.selectedLocation != nil && self.selectedLocation.longitude != nil) ? self.selectedLocation.longitude:"","source":"Cenes","createdById":uid,"timezone":"Asia/Kolkata","scheduleAs":"Gathering","startTime":self.startTime,"endTime":self.endTime,"eventMembers":eventMembers,"isPredictiveOn":0]
                        
                        print(params)
                    }
                    
                    
                }else {
                if self.event.isPredictiveOn == true {
                    params = ["title":self.event.title,"description":self.event.description,"location":(self.selectedLocation != nil && self.selectedLocation.locationName != "No Location for event") ? self.selectedLocation.locationName:"","latitude": (self.selectedLocation != nil && self.selectedLocation.latitude != nil) ? self.selectedLocation.latitude:"","longitude":(self.selectedLocation != nil && self.selectedLocation.longitude != nil) ? self.selectedLocation.longitude:"","source":"Cenes","createdById":uid,"timezone":"Asia/Kolkata","scheduleAs":"Gathering","startTime":self.startTime,"endTime":self.endTime,"isPredictiveOn":1,"predictiveData":predictiveString]
                }else{
                    params = ["title":self.event.title,"description":self.event.description,"location":(self.selectedLocation != nil && self.selectedLocation.locationName != "No Location for event") ? self.selectedLocation.locationName:"","latitude":(self.selectedLocation != nil && self.selectedLocation.latitude != nil) ? self.selectedLocation.latitude:"","longitude":(self.selectedLocation != nil && self.selectedLocation.longitude != nil) ? self.selectedLocation.longitude:"","source":"Cenes","createdById":uid,"timezone":"Asia/Kolkata","scheduleAs":"Gathering","startTime":self.startTime,"endTime":self.endTime,"isPredictiveOn":0]
                    }
                 
                }
                
                
                if self.editSummary == true{
                    params["eventId"] = self.eventId
                    
                }
                
                params["eventPicture"] = self.gatheringImageURL
                
                print("Gathering params \(params)");
                
                startAnimating(loadinIndicatorSize, message: "Loading...", type: self.nactvityIndicatorView.type)
                GatheringService().createGathering(uploadDict: params, complete: { (returnedDict) in
                    self.stopAnimating()
                    if returnedDict.value(forKey: "Error") as? Bool == true {
                        
                        self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                        
                    }else{
                        print("Got result from webservice\(returnedDict)")
                        let dict = returnedDict["data"] as? NSDictionary
                        if dict?.value(forKey: "eventId")! != nil {
                            self.eventId = "\((dict?.value(forKey: "eventId")! as? NSNumber)!)"
                        }
                       
                       
                        // Opening SMS Intent to send Event Card to non cenes members.
                        if self.nonCenesUsers.count > 0 {
                            
                            var phoneNumbers: String! = "";
                            for userContact in self.nonCenesUsers {
                                phoneNumbers = userContact.phone+","+phoneNumbers;
                            }
                            self.sendSMSText(phoneNumber: String(phoneNumbers.prefix(phoneNumbers.count-1 )));
                            
                        }
                        self.summaryBool = true
                        self.loadSummary = true
                        self.editSummary = false
                        self.cellHeightTime =  CellHeight.Fifth
                        self.gatheringTableView.reloadData()
                        self.setUpNavBar()
                        self.navigationController?.popViewController(animated: true)
                        
                    }
                })
            }
        }else{
            if self.event.isPredictiveOn {
                self.showAlert(title: "You have not chosen a Date", message: "Pick a date from Predictive Calendar.")
            }else{
                self.showAlert(title: "You have not chosen a Date", message: "Pick a date from Calendar.")
            }
            
        }
        
    }

     func imagePickerButtonPressed() {
        
        if !self.summaryBool{
        let actionSheetController = UIAlertController(title: "Please select", message: nil, preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Take Picture", style: .default) { action -> Void in
            print("take")
            self.takePicture()
        }
        actionSheetController.addAction(cancelActionButton)
        
        let saveActionButton = UIAlertAction(title: "Choose From Gallery", style: .default) { action -> Void in
            print("choose")
            self.selectPicture()
        }
        actionSheetController.addAction(saveActionButton)
        
        let deleteActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            print("Cancel")
        }
        actionSheetController.addAction(deleteActionButton)
        self.present(actionSheetController, animated: true, completion: nil)
        }
    }
    
     func takePicture() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            picController.sourceType = UIImagePickerControllerSourceType.camera
            picController.allowsEditing = true
            picController.delegate = self
            picController.mediaTypes = [kUTTypeImage as String]
            present(picController, animated: true, completion: nil)
        }
    }
    
     func selectPicture() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            picController.delegate = self
            picController.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            picController.allowsEditing = true
            picController.mediaTypes = [kUTTypeImage as String]
            self.present(picController, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.gatheringImage = image
            self.gatheringImageURL = nil
            self.gatheringDelegate.setEventImage!(image: image)
        }
        
        picker.dismiss(animated: true, completion: nil);
    }
    
    func imageButtonTApped(cell:GatheringEventTableViewCell){
        
        self.gatheringDelegate = cell
        
        self.imagePickerButtonPressed()
    }
    
   
    @IBAction func timePickerDoneButtonPressed(_ sender: UIButton
        ) {
        
        print("done button time pre4ssed")
        
        let dateFormatter = DateFormatter()
        
        self.showPicker(show: false, pickDate: false)
        
        switch self.pickerType! {
        case PickerType.StartDate:
            dateFormatter.dateFormat = "MMM dd, YYYY"
            print("[timePickerDoneButtonPressed] Picker Type Start Date StartDate \(dateFormatter.string(from: self.dateTimePicker.date))")
            self.gatheringDelegate.setDateTimeValues!(tag: .StartDate, value: dateFormatter.string(from: self.dateTimePicker.date))
        case PickerType.EndDate:
            
            dateFormatter.dateFormat = "MMM dd, YYYY"
            print("[timePickerDoneButtonPressed] Picker Type End Date \(dateFormatter.string(from: self.dateTimePicker.date))")
            self.gatheringDelegate.setDateTimeValues!(tag: .EndDate, value: dateFormatter.string(from: self.dateTimePicker.date))
            
//---------------------------------------------------------------
        case PickerType.StartTime:
            dateFormatter.dateFormat = "h:mm a"
            print("[timePickerDoneButtonPressed] Picker Type StartTime \(dateFormatter.string(from: self.dateTimePicker.clampedDate))")
//            let timeValue = dateFormatter.string(from: self.dateTimePicker.clampedDate)
//            let index = timeValue.index(timeValue.startIndex, offsetBy: 2)
//            let endIndex = timeValue.index(timeValue.endIndex, offsetBy:-3)
//           print(timeValue[index ..< endIndex])
//            let secondValue = timeValue[index ..< endIndex]
//            if ((((secondValue as NSString).integerValue) % 5 == 0) || (((secondValue as NSString).integerValue) == 0)){
            self.gatheringDelegate.setDateTimeValues!(tag: .StartTime, value: dateFormatter.string(from: self.dateTimePicker.date))
            
            startTime = "\(self.dateTimePicker.date.millisecondsSince1970)";
            //Setting EndTime to be 1 Hour past current time.
             var dateComponent = DateComponents()
            dateComponent.minute = 60;
            print(self.dateTimePicker.date);
            print(self.dateTimePicker.date.addingTimeInterval(60.0 * 60.0))
            let endDate = Calendar.current.date(byAdding: dateComponent, to: self.dateTimePicker.date);
            print("end date : \(endDate ?? Date())");
            self.gatheringDelegate.setDateTimeValues!(tag: .EndTime, value: dateFormatter.string(from: endDate!))
            
            endTime = "\(endDate?.millisecondsSince1970 ?? Date().millisecondsSince1970)";
            
            //Checking if end time is of next day, then we change the end time date to next day
            if (Int64(endTime!)! < Int64(startTime!)!) {
                let ddf = DateFormatter()
                ddf.dateFormat = "MM dd";
                let tommorrow = Calendar.current.date(byAdding: .day, value: 1, to: endDate!);
                print("PickerType.EndTime : Tommorrows Date : \(ddf.string(from: tommorrow!))")
                endTime = "\(tommorrow?.millisecondsSince1970 ?? Date().millisecondsSince1970)";
            }
//            }
//            else{
//              self.showAlert(title: "Alert!", message: "Please select minutes as a multiple of 5 eg. 3.05, 3.10")
//            }
            
        case PickerType.EndTime:
            dateFormatter.dateFormat = "h:mm a"
            print("[timePickerDoneButtonPressed] Picker Type EndTime \(dateFormatter.string(from: self.dateTimePicker.clampedDate))")
                self.gatheringDelegate.setDateTimeValues!(tag: .EndTime, value: dateFormatter.string(from: self.dateTimePicker.date))
            endTime = "\(self.dateTimePicker.date.millisecondsSince1970)";
            
            print("Start Time : \(startTime), End Time : \(endTime), Now : \(Date().millisecondsSince1970)")
            
            //Checking if end time is of next day, then we change the end time date to next day
            if (startTime == nil && (Int64(endTime!)! < Date().millisecondsSince1970)) {
                let ddf = DateFormatter()
                ddf.dateFormat = "MM dd";
                let tommorrow = Calendar.current.date(byAdding: .day, value: 1, to: self.dateTimePicker.date);
                print("PickerType.EndTime : Tommorrows Date : \(ddf.string(from: tommorrow!))")
                endTime = "\(tommorrow?.millisecondsSince1970 ?? Date().millisecondsSince1970)";
                print("Endd Time Piker : \(endTime)")
            } else if (startTime != nil && Int64(endTime!)! < Int64(startTime!)!) {
                let ddf = DateFormatter()
                ddf.dateFormat = "MM dd";
                let tommorrow = Calendar.current.date(byAdding: .day, value: 1, to: self.dateTimePicker.date);
                print("PickerType.EndTime : Tommorrows Date : \(ddf.string(from: tommorrow!))")
                endTime = "\(tommorrow?.millisecondsSince1970 ?? Date().millisecondsSince1970)";
                print("Endd Time Piker : \(endTime)")
            }
         //---------------------------------------------------------------
        default:
            print("default printed")
        }

    }
    
    
    @IBAction func timePickerCancelButtonPressed(_ sender: UIButton) {
        print("cancel Button Pressed")
        self.showPicker(show: false, pickDate: false)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "inviteFriends" {
            let friendsNavigationVC = segue.destination as? FriendsViewController
            friendsNavigationVC?.collectionFriendsDelegate = self
        } else if segue.identifier == "showLocation" {
            let locationNavigationVC = segue.destination as? LocationTableViewController
            locationNavigationVC?.delegate = self
        } else if(segue.identifier == "showGatheringPreview"){
            let eventPreview = self.event;
            let gatheringPreviewController = segue.destination as! GatheringPreviewController
            gatheringPreviewController.event = eventPreview;
        }
    }
    
    /***
    ** This method is user when the picker is opened.
    ***/
    func showPicker(show:Bool ,pickDate : Bool){
        print("[ShowPicker] Starts");
        if show{
            
            closeCheck = true
            
            
            //This is for Selecting the Date from Date Picker.
            if pickDate {
                self.dateTimePicker.datePickerMode = .date
                
                if self.pickerType == PickerType.StartDate {
                    //self.dateTimePicker.minimumDate = Date()
                     //self.dateTimePicker.setDate(self.FirstDate, animated: false)
                    
                    print("StartTime Before Date Picker Open : \(self.event.startTime)")
                    self.dateTimePicker.setDate(Date(timeIntervalSince1970: TimeInterval(self.event.startTime)), animated: false)
                }else if self.pickerType == PickerType.EndDate {
                    var datecomponent = DateComponents()
                    datecomponent.minute = 5
                    let startDate = Calendar.current.date(byAdding: datecomponent, to: Date(timeIntervalSince1970: TimeInterval(self.event.startTime)))
                    //self.dateTimePicker.minimumDate = startDate
                    self.dateTimePicker.setDate(Date(timeIntervalSince1970: TimeInterval(self.event.endTime)), animated: false)
                }
                
                
            }else{
                //This is for Selecting the Time from DatePicker.
                self.dateTimePicker.datePickerMode = .time
                self.dateTimePicker.minuteInterval = 5
                if self.pickerType == PickerType.StartTime {
                    var datecomponent = DateComponents()
                    datecomponent.day = 1
                    let newDate = Calendar.current.date(byAdding: datecomponent, to: Date(timeIntervalSince1970: TimeInterval(self.event.startTime))) as! Date
                    print("StartTime Before Time Picker Open : \(newDate)")
                    
                    /*if newDate! <= self.SecondDate! {
                        self.dateTimePicker.minimumDate = nil
                    }else{
                        self.dateTimePicker.minimumDate = self.FirstDate
                    }*/
                    
                    self.dateTimePicker.setDate(newDate, animated: false)
                }else if self.pickerType == PickerType.EndTime {
                    var datecomponent = DateComponents()
                    datecomponent.minute = 1
                    let startDate = Calendar.current.date(byAdding: datecomponent, to: Date(timeIntervalSince1970: TimeInterval(self.event.startTime)))
                    
                    
                    datecomponent.day = 1
                    let newDate = Calendar.current.date(byAdding: datecomponent, to: Date(timeIntervalSince1970: TimeInterval(self.event.startTime)))
                    
                    /*if newDate! <= self.SecondDate! {
                        self.dateTimePicker.minimumDate = nil
                    }else{
                        self.dateTimePicker.minimumDate = startDate
                    }*/
                    
                    self.dateTimePicker.setDate(Date(timeIntervalSince1970: TimeInterval(self.event.endTime)), animated: false)
                }
            }
           
            
            self.pickerOuterView.isHidden = false
            
            
        }else{
            self.pickerOuterView.isHidden = true
            closeCheck = false
        }
    }
    
    func sendSMSText(phoneNumber: String) {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "\(cenesWebUrl)/event/"+eventId;
            controller.recipients = phoneNumber.components(separatedBy: ",")
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }
    
}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

extension CreateGatheringViewController: SelectedLocationDelegate {
    func selectedLocation(location: Location, url:String!) {
        //self.selectedLocation = location
        //self.locationName = location.locationName
        self.event.location = location.location;
        self.event.latitude = location.latitude;
        self.event.longitude = location.longitude;
            // New
            
            if self.gatheringImage == nil {
                self.gatheringImageURL = url
                self.event.eventPicture = url;
                self.gatheringTableView.reloadData()
            }else{
                
                if self.gatheringImageURL != nil {
                if self.gatheringImageURL.contains("https://maps.googleapis.com/maps/api/place/photo?key=AIzaSyAg8FTMwwY2LwneObVbjcjj-9DYZkrTR58&maxwidth=400&photoreference="){
                    self.gatheringImage = nil
                    self.gatheringImageURL = url
                    self.gatheringTableView.reloadData()
                }
            }
            }
    }
}

extension CreateGatheringViewController: CollectionFriendsProtocol {
    func collectionFriendsList(selectedFriendHolder: [EventMember]) {
        
        print("Callback Function Called....")
        
        var eventMembers = self.event.eventMembers;
        
        if (selectedFriendHolder.count > 0) {
            
            if (eventMembers == nil) {
                self.event.eventMembers = selectedFriendHolder;
            } else {
                for selectedMem in selectedFriendHolder {
                    
                    var userAlreadyExists = false;
                    for eventMem in eventMembers! {
                        if (eventMem.userContactId == selectedMem.userContactId) {
                            userAlreadyExists = true;
                            break;
                        }
                    }
                    if (!userAlreadyExists) {
                        self.event.eventMembers.append(selectedMem);
                    }
                }
            }
        }
        
        self.gatheringTableView.reloadData();
    }
}

/*extension CreateGatheringViewController : GatheringTableViewCellFiveDelegate {
    func setCase(caseHeight: CellHeight, cellIndex: IndexPath) {
        
        self.cellHeightTime = caseHeight
        self.gatheringTableView.beginUpdates()
        self.gatheringTableView.endUpdates()
        
        self.gatheringTableView.scrollToRow(at: cellIndex , at: .top, animated: true)
    }
    
    func timePick(cell: GatheringDateTableViewCell, tag: Int) {
        
        self.gatheringDelegate = cell
        switch tag {
        case PickerType.StartDate.rawValue:
            self.pickerType = PickerType.StartDate
            self.showPicker(show: true, pickDate: true)
        case PickerType.EndDate.rawValue :
            self.pickerType = PickerType.EndDate
            self.showPicker(show: true, pickDate: true)
        case PickerType.StartTime.rawValue:
            self.pickerType = PickerType.StartTime
            self.showPicker(show: true, pickDate: false)
        case PickerType.EndTime.rawValue :
            self.pickerType = PickerType.EndTime
            self.showPicker(show: true, pickDate: false)
            
        default:
            print("defulat tag pressed")
        }
    }
}
 */

