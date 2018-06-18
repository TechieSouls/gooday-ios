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


class CreateGatheringViewController: UIViewController,UIImagePickerControllerDelegate ,UINavigationControllerDelegate,GatheringEventCellDelegate,NVActivityIndicatorViewable {

    @IBOutlet weak var gatheringTableView: UITableView!
    
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
    
    var eventName = ""
    
    var isPreditiveEnabled = false
    
    var eventDetails = ""
    
    
    var isOwner = true
    
    var summaryBool = false
    
    var loadSummary = false
    
    var editSummary = false
    
    var eventId : String!
    
    var predictiveData : NSMutableArray!
    
    var selectedDate  : Date!
    var FirstDate : Date!
    var SecondDate: Date!
    
    var startTime = ""
    var endTime = ""
    
    let picController = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        gatheringTableView.register(UINib(nibName: "GatheringTableViewCellTwo", bundle: Bundle.main), forCellReuseIdentifier: "GatheringTableViewCellTwo")
        gatheringTableView.register(UINib(nibName: "GatheringTableViewCellThree", bundle: Bundle.main), forCellReuseIdentifier: "GatheringTableViewCellThree")
        gatheringTableView.register(UINib(nibName: "GatheringTableViewCellFive", bundle: Bundle.main), forCellReuseIdentifier: "GatheringTableViewCellFive")
        gatheringTableView.register(UINib(nibName: "GatheringTableViewCellOne", bundle: Bundle.main), forCellReuseIdentifier: "GatheringTableViewCellOne")
        gatheringTableView.register(UINib(nibName: "GAtheringTableViewCellFour", bundle: Bundle.main), forCellReuseIdentifier: "GAtheringTableViewCellFour")
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
        
         self.setUpNavBar()
        
        
    }
    
    
    
    func setUpNavBar() {
        
        if self.editSummary == true {
            let backButton = UIButton.init(type: .custom)
            self.title = "Edit Gathering"
            backButton.setTitle("Cancel", for: UIControlState.normal)
            backButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
            backButton.layer.cornerRadius = backButton.frame.height/2
            backButton.clipsToBounds = true
            backButton.addTarget(self, action: #selector(stopButtonPressed(_:)), for: .touchUpInside)
            
            let barButton = UIBarButtonItem.init(customView: backButton)
            self.navigationItem.leftBarButtonItem = barButton
            
            let nextButton = UIButton.init(type: .custom)
            
            nextButton.setTitle("Save", for: .normal)
            nextButton.setTitleColor(UIColor.black, for: .normal)
            nextButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
            nextButton.layer.cornerRadius = nextButton.frame.height/2
            nextButton.clipsToBounds = true
            nextButton.addTarget(self, action: #selector(createGatheringbuttonPressed(_:)), for: .touchUpInside)
            let rightButton = UIBarButtonItem.init(customView: nextButton)
            
            self.navigationItem.rightBarButtonItem = rightButton
            
        }else if self.summaryBool{
        
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
            nextButton.setTitleColor(UIColor.black, for: .normal)
            nextButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
            nextButton.layer.cornerRadius = nextButton.frame.height/2
            nextButton.clipsToBounds = true
            nextButton.addTarget(self, action: #selector(CreateGatheringViewController.setEditSummary), for: .touchUpInside)
            let rightButton = UIBarButtonItem.init(customView: nextButton)
            
            
            if self.isOwner == true {
                self.navigationItem.rightBarButtonItem = rightButton
            }
            
        }else{
            
            self.title = "Add Gathering"
            
            
            let nextButton = UIButton.init(type: .custom)
            
            nextButton.setTitle("Save", for: UIControlState.normal)
            nextButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
            nextButton.layer.cornerRadius = nextButton.frame.height/2
            nextButton.clipsToBounds = true
            nextButton.addTarget(self, action: #selector(createGatheringbuttonPressed(_:)), for: .touchUpInside)
            let rightButton = UIBarButtonItem.init(customView: nextButton)
            
            
            self.navigationItem.rightBarButtonItem = rightButton
            
            let cancelButton = UIButton.init(type: .custom)
            cancelButton.setTitle("Cancel", for: .normal)
            cancelButton.frame = CGRect.init(x: 0, y: 0, width: 25, height: 25)
            cancelButton.layer.cornerRadius = nextButton.frame.height/2
            cancelButton.clipsToBounds = true
            cancelButton.addTarget(self, action: #selector(stopButtonPressed(_:)), for: .touchUpInside)
            
            
            let leftButton = UIBarButtonItem.init(customView: cancelButton)
            self.navigationItem.leftBarButtonItem = leftButton
        }
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.gatheringTableView.reloadData()
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
    
    @objc func setEditSummary(){
        self.loadSummary = false
        self.summaryBool = false
        self.editSummary = true
        self.setUpNavBar()
        self.cellHeightTime = CellHeight.Third
        self.gatheringTableView.reloadData()
    }
    
    @IBAction func createGatheringbuttonPressed(_ sender: Any) {
        var predictiveDict = [NSMutableDictionary]()
        var predictiveString : String!
        
        
        if self.isPreditiveEnabled {
            
            for result in self.predictiveData {
                let dict = NSMutableDictionary(dictionary: (result as? NSDictionary)!)
                predictiveDict.append(dict)
            }
            
            let data =  try! JSONSerialization.data(withJSONObject: predictiveDict, options: [])
            predictiveString = String(data:data, encoding:.utf8)!
            
        }
        
        
        if self.eventName == "" {
            self.showAlert(title: "Event Title", message: "Please fill the event title.")
            return
        }
        
//        if self.locationName == "" {
//            self.showAlert(title: "Location", message: "Please add location to the event.")
//        }
        
        if self.eventDetails == "" {
            self.showAlert(title: "Event Description", message: "Please enter event description.")
            return
        }
        
        
        
        if self.cellHeightTime == CellHeight.Fourth {
            
            
            
            let userid = setting.value(forKey: "userId") as! NSNumber
            let uid = "\(userid)"
            
            
            
            
            var eventMembers = [NSMutableDictionary]()
            
            for result in self.FriendArray {
                let dict = NSMutableDictionary()
                
                dict["name"] = result.name
                dict["userId"] = result.userId
                
                if let status = result.status {
                    dict["status"] = status
                }
                
                let id = "\((setting.value(forKey: "userId") as? NSNumber)!)"
                if result.userId == id {
                    continue
                }
                if result.photoUrl != nil {
                    dict["picture"] = result.photoUrl
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
                let webservice = WebService()
                
                startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))
                let uploadImage = self.gatheringImage.compressImage(newSizeWidth: 512, newSizeHeight: 512, compressionQuality: 1.0)
                
                webservice.uploadEventImage(image: uploadImage, complete: { (returnedDict) in
                    
                    if returnedDict.value(forKey: "Error") as? Bool == true {
                        self.stopAnimating()
                        self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                        
                    }else{
                        print(returnedDict)
                        
                        let eventPictureUrl = (returnedDict["data"] as! NSDictionary)["eventPicture"]
                        
                        var params : [String:Any]
                        
                        if eventMembers.count > 0 {
                            if self.isPreditiveEnabled == true {
                                params   = ["title":self.eventName,"description":self.eventDetails,"location":(self.selectedLocation != nil && self.selectedLocation.locationName != "No Location for event") ? self.selectedLocation.locationName:"","latitude": (self.selectedLocation != nil && self.selectedLocation.latitude != nil) ? self.selectedLocation.latitude:"","longitude":(self.selectedLocation != nil && self.selectedLocation.longitude != nil) ? self.selectedLocation.longitude:"","source":"Cenes","createdById":uid,"timezone":"Asia/Kolkata","scheduleAs":"Gathering","startTime":self.startTime,"endTime":self.endTime,"eventPicture":eventPictureUrl!,"eventMembers":eventMembers,"isPredictiveOn":1,"predictiveData":predictiveString]
                            }else{
                                params   = ["title":self.eventName,"description":self.eventDetails,"location":(self.selectedLocation != nil && self.selectedLocation.locationName != "No Location for event") ? self.selectedLocation.locationName:"","latitude":(self.selectedLocation != nil && self.selectedLocation.latitude != nil) ? self.selectedLocation.latitude:"","longitude":(self.selectedLocation != nil && self.selectedLocation.longitude != nil) ? self.selectedLocation.longitude:"","source":"Cenes","createdById":uid,"timezone":"Asia/Kolkata","scheduleAs":"Gathering","startTime":self.startTime,"endTime":self.endTime,"eventPicture":eventPictureUrl!,"eventMembers":eventMembers,"isPredictiveOn":0]
                            }
                          
                        }else{
                            
                            if self.isPreditiveEnabled == true {
                                params    = ["title":self.eventName,"description":self.eventDetails,"location":(self.selectedLocation != nil && self.selectedLocation.locationName != "No Location for event") ? self.selectedLocation.locationName:"","latitude":(self.selectedLocation != nil && self.selectedLocation.latitude != nil ) ? self.selectedLocation.latitude:"","longitude":(self.selectedLocation != nil && self.selectedLocation.longitude != nil) ? self.selectedLocation.longitude:"","source":"Cenes","createdById":uid,"timezone":"Asia/Kolkata","scheduleAs":"Gathering","startTime":self.startTime,"endTime":self.endTime,"eventPicture":eventPictureUrl!,"isPredictiveOn":1,"predictiveData":predictiveString]
                            }else{
                                params    = ["title":self.eventName,"description":self.eventDetails,"location":(self.selectedLocation != nil && self.selectedLocation.locationName != "No Location for event") ? self.selectedLocation.locationName:"","latitude":self.selectedLocation.latitude != nil ? self.selectedLocation.latitude:"","longitude":self.selectedLocation.longitude != nil ? self.selectedLocation.longitude:"","source":"Cenes","createdById":uid,"timezone":"Asia/Kolkata","scheduleAs":"Gathering","startTime":self.startTime,"endTime":self.endTime,"eventPicture":eventPictureUrl!,"isPredictiveOn":0]
                            }
                            
                         
                        }
                        
                        if self.editSummary == true{
                            params["eventId"] = self.eventId
                            
                        }
                        
                            WebService().createGathering(uploadDict: params, complete: { (returnedDict) in
                                self.stopAnimating()
                                
                            if returnedDict.value(forKey: "Error") as? Bool == true {
                               
                                self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                                
                            }else{
                                
                                print("Got result from webservice\(returnedDict)")
                                let dict = returnedDict["data"] as? NSDictionary
                                if dict?.value(forKey: "eventId")! != nil {
                                    self.eventId = "\((dict?.value(forKey: "eventId")! as? NSNumber)!)"
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
                     if self.isPreditiveEnabled == true {
                        params = ["title":self.eventName,"description":self.eventDetails,"location":(self.selectedLocation != nil && self.selectedLocation.locationName != "No Location for event") ? self.selectedLocation.locationName:"","latitude": (self.selectedLocation != nil && self.selectedLocation.latitude != nil) ? self.selectedLocation.latitude:"","longitude":(self.selectedLocation != nil &&  self.selectedLocation.longitude != nil) ? self.selectedLocation.longitude:"","source":"Cenes","createdById":uid,"timezone":"Asia/Kolkata","scheduleAs":"Gathering","startTime":self.startTime,"endTime":self.endTime,"eventMembers":eventMembers,"isPredictiveOn":1,"predictiveData":predictiveString]
                     }else{
                        params = ["title":self.eventName,"description":self.eventDetails,"location":(self.selectedLocation != nil && self.selectedLocation.locationName != "No Location for event") ? self.selectedLocation.locationName:"","latitude": (self.selectedLocation != nil && self.selectedLocation.latitude != nil) ? self.selectedLocation.latitude:"","longitude": (self.selectedLocation != nil && self.selectedLocation.longitude != nil) ? self.selectedLocation.longitude:"","source":"Cenes","createdById":uid,"timezone":"Asia/Kolkata","scheduleAs":"Gathering","startTime":self.startTime,"endTime":self.endTime,"eventMembers":eventMembers,"isPredictiveOn":0]
                    }
                    
                    
                }else {
                if self.isPreditiveEnabled == true {
                    params = ["title":self.eventName,"description":self.eventDetails,"location":(self.selectedLocation != nil && self.selectedLocation.locationName != "No Location for event") ? self.selectedLocation.locationName:"","latitude": (self.selectedLocation != nil && self.selectedLocation.latitude != nil) ? self.selectedLocation.latitude:"","longitude":(self.selectedLocation != nil && self.selectedLocation.longitude != nil) ? self.selectedLocation.longitude:"","source":"Cenes","createdById":uid,"timezone":"Asia/Kolkata","scheduleAs":"Gathering","startTime":self.startTime,"endTime":self.endTime,"isPredictiveOn":1,"predictiveData":predictiveString]
                }else{
                    params = ["title":self.eventName,"description":self.eventDetails,"location":(self.selectedLocation != nil && self.selectedLocation.locationName != "No Location for event") ? self.selectedLocation.locationName:"","latitude":(self.selectedLocation != nil && self.selectedLocation.latitude != nil) ? self.selectedLocation.latitude:"","longitude":(self.selectedLocation != nil && self.selectedLocation.longitude != nil) ? self.selectedLocation.longitude:"","source":"Cenes","createdById":uid,"timezone":"Asia/Kolkata","scheduleAs":"Gathering","startTime":self.startTime,"endTime":self.endTime,"isPredictiveOn":0]
                    }
                 
                }
                
                
                if self.editSummary == true{
                    params["eventId"] = self.eventId
                    
                }
                
                params["eventPicture"] = self.gatheringImageURL
                
                startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))
                WebService().createGathering(uploadDict: params, complete: { (returnedDict) in
                    self.stopAnimating()
                    if returnedDict.value(forKey: "Error") as? Bool == true {
                        
                        self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                        
                    }else{
                        print("Got result from webservice\(returnedDict)")
                        let dict = returnedDict["data"] as? NSDictionary
                        if dict?.value(forKey: "eventId")! != nil {
                            self.eventId = "\((dict?.value(forKey: "eventId")! as? NSNumber)!)"
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
            if self.isPreditiveEnabled {
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
            print(dateFormatter.string(from: self.dateTimePicker.date))
            self.gatheringDelegate.setDateTimeValues!(tag: .StartDate, value: dateFormatter.string(from: self.dateTimePicker.date))
        case PickerType.EndDate:
            
            dateFormatter.dateFormat = "MMM dd, YYYY"
            print(dateFormatter.string(from: self.dateTimePicker.date))
            self.gatheringDelegate.setDateTimeValues!(tag: .EndDate, value: dateFormatter.string(from: self.dateTimePicker.date))
            
            
        case PickerType.StartTime:
            dateFormatter.dateFormat = "h:mm a"
            print(dateFormatter.string(from: self.dateTimePicker.clampedDate))
            self.gatheringDelegate.setDateTimeValues!(tag: .StartTime, value: dateFormatter.string(from: self.dateTimePicker.date))
            
        case PickerType.EndTime:
            dateFormatter.dateFormat = "h:mm a"
            print(dateFormatter.string(from: self.dateTimePicker.clampedDate))
            
            self.gatheringDelegate.setDateTimeValues!(tag: .EndTime, value: dateFormatter.string(from: self.dateTimePicker.date))
            
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
        
        if segue.identifier == "showLocation" {
            let locationNavigationVC = segue.destination as? LocationTableViewController
            locationNavigationVC?.delegate = self
        }
    }
    
    func showPicker(show:Bool ,pickDate : Bool){
        if show{
            
            closeCheck = true
            
            
            
            if pickDate {
                self.dateTimePicker.datePickerMode = .date
                
                if self.pickerType == PickerType.StartDate {
                    self.dateTimePicker.minimumDate = Date()
                     self.dateTimePicker.setDate(self.FirstDate, animated: false)
                }else if self.pickerType == PickerType.EndDate {
                    var datecomponent = DateComponents()
                    datecomponent.minute = 1
                    let startDate = Calendar.current.date(byAdding: datecomponent, to: self.FirstDate.clampedDate)
                    self.dateTimePicker.minimumDate = startDate
                    self.dateTimePicker.setDate(self.SecondDate, animated: false)
                }
                
                
            }else{
                self.dateTimePicker.datePickerMode = .time
                self.dateTimePicker.minuteInterval = 1
                if self.pickerType == PickerType.StartTime {
                    
                    var datecomponent = DateComponents()
                    datecomponent.day = 1
                    let newDate = Calendar.current.date(byAdding: datecomponent, to: Date())
                    
                    if newDate! <= self.SecondDate! {
                        self.dateTimePicker.minimumDate = nil
                    }else{
                        self.dateTimePicker.minimumDate = self.FirstDate
                    }
                    
                    self.dateTimePicker.setDate(self.FirstDate, animated: false)
                }else if self.pickerType == PickerType.EndTime {
                    var datecomponent = DateComponents()
                    datecomponent.minute = 1
                    let startDate = Calendar.current.date(byAdding: datecomponent, to: self.FirstDate)
                    
                    
                    datecomponent.day = 1
                    let newDate = Calendar.current.date(byAdding: datecomponent, to: self.FirstDate.clampedDate)
                    
                    if newDate! <= self.SecondDate! {
                        self.dateTimePicker.minimumDate = nil
                    }else{
                        self.dateTimePicker.minimumDate = startDate
                    }
                    
                    self.dateTimePicker.setDate((self.SecondDate)!, animated: false)
                }
                
                
                
                
            }
           
            
            self.pickerOuterView.isHidden = false
            
            
        }else{
            self.pickerOuterView.isHidden = true
            closeCheck = false
        }
    }
    
    func deleteGathering(){
        print("DeleteGathering")
        startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))
        
        WebService().deleteGathering(eventId: self.eventId) { (returnedDict) in
            if returnedDict.value(forKey: "Error") as? Bool == true {
                self.stopAnimating()
                self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                
            }else{
                print(returnedDict)
                self.stopAnimating()
                
                let actionSheetController = UIAlertController(title: "Alert", message: "Gathering Deleted!", preferredStyle: .alert)
                
                let OKButtonAction = UIAlertAction(title: "Ok", style: .default) { action -> Void in
                    print("take")
                    self.navigationController?.popViewController(animated: true)
                }
                actionSheetController.addAction(OKButtonAction)
                
                self.present(actionSheetController, animated: true, completion: nil)
            }
            }
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
    func selectedLocation(location: LocationModel, url:String!) {
        self.selectedLocation = location
        self.locationName = location.locationName
        
            // New
            
            if self.gatheringImage == nil {
                self.gatheringImageURL = url
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


extension CreateGatheringViewController : GatheringTableViewCellFiveDelegate {
    func setCase(caseHeight: CellHeight, cellIndex: IndexPath) {
        
        self.cellHeightTime = caseHeight
        self.gatheringTableView.beginUpdates()
        self.gatheringTableView.endUpdates()
        
        self.gatheringTableView.scrollToRow(at: cellIndex , at: .top, animated: true)
    }
    
    func timePick(cell: GatheringTableViewCellFive, tag: Int) {
        
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

    extension CreateGatheringViewController :UITableViewDataSource,UITableViewDelegate
    {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if self.editSummary == true{
                return 7
            }
            return 6
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            var identifier = "TableViewCell"
            
            switch indexPath.row {
            case 0:
                print("")
                identifier = "GatheringEventTableViewCell"
                let cell: GatheringEventTableViewCell = (tableView.dequeueReusableCell(withIdentifier: identifier) as? GatheringEventTableViewCell)!
                cell.imageDelegate  = self
                cell.indexPathCell = indexPath
                cell.gView = self
                if (self.gatheringImageURL != nil && self.gatheringImage == nil) {
                cell.loadImage()
                }
                return cell
                
            case 1:
                print("")
                identifier = "GatheringTableViewCellTwo"
                let cell: GatheringTableViewCellTwo = (tableView.dequeueReusableCell(withIdentifier: identifier) as? GatheringTableViewCellTwo)!
                cell.gatheringView = self
                
                if self.eventName == "" {
                    cell.eventTitleTextField.text = ""
                }else{
                    cell.eventTitleTextField.text = self.eventName
                }
                
                if self.summaryBool{
                    cell.eventTitleTextField.isUserInteractionEnabled = false
                }else{
                    cell.eventTitleTextField.isUserInteractionEnabled = true
                }
                
                return cell
            case 2:
                print("")
                identifier = "GatheringTableViewCellThree"
                let cell: GatheringTableViewCellThree = (tableView.dequeueReusableCell(withIdentifier: identifier) as? GatheringTableViewCellThree)!
                
                cell.createGatheringView = self
                cell.setShowArray()
                if self.FriendArray.count > 0 {
                    cell.lowerView.isHidden = false
                }else{
                    cell.lowerView.isHidden = true
                }
                cell.reloadFriends()
                return cell
                    
            case 3:
                print("")
                
                
                
                identifier = "GatheringTableViewCellFive"
                let cell: GatheringTableViewCellFive = (tableView.dequeueReusableCell(withIdentifier: identifier) as? GatheringTableViewCellFive)!
                
                cell.cellDelegate = self
                cell.gatheringView = self
                
                cell.cellIndex = indexPath
                
                cell.setFirstDateSecondDate()
                
                switch cellHeightTime! {
                case CellHeight.First:
                cell.setFirstCase()
                    
                case CellHeight.Second:
                cell.setSecondCase()
                
                case CellHeight.Third :
                cell.setThirdCase()
                    
                case CellHeight.Fourth :
                cell.setFourthCase()
                
                case CellHeight.Fifth  :
                cell.setFifthCase()
                default:
                    print("Height fails")
                }
                
                if self.loadSummary == true {
                    cell.loadSummary(startTime: self.startTime, endTime: self.endTime)
                }
                
                
                return cell
            case 4:
                print("")
                identifier = "GatheringTableViewCellOne"
                let cell: GatheringTableViewCellOne = (tableView.dequeueReusableCell(withIdentifier: identifier) as? GatheringTableViewCellOne)!
                
                
                if self.selectedLocation != nil {
                    cell.locationTitle.text = self.selectedLocation.locationName
                }else{
                    cell.locationTitle.text = "Add Location"
                }
                
                if self.editSummary == true {
                    if self.locationName == "No Location for event"{
                        cell.locationTitle.text = "Add location"
                        self.locationName = ""
                    }
                }
                
                
                return cell
            case 5:
                print("")
                identifier = "GAtheringTableViewCellFour"
                let cell: GAtheringTableViewCellFour = (tableView.dequeueReusableCell(withIdentifier: identifier) as? GAtheringTableViewCellFour)!
                cell.gatheringView = self
                
                if self.eventDetails == "" {
                    cell.eventDetailsField.text = ""
                }else{
                    cell.eventDetailsField.text = self.eventDetails
                }
                
                if self.summaryBool{
                    cell.eventDetailsField.isUserInteractionEnabled = false
                }else{
                    cell.eventDetailsField.isUserInteractionEnabled = true
                }
                
                return cell
                
                case 6:
                print("delte cell")
                identifier = "DeleteCell"
                let cell: DeleteCell = (tableView.dequeueReusableCell(withIdentifier: identifier) as? DeleteCell)!
                cell.gatheringView = self
                return cell
            default:
                print("")
                return UITableViewCell()
            }
            
        }
        
        
        
        
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            switch indexPath.row {
               case 0:
                return 127
            case 1:
                return 60
            case 2:
                if self.FriendArray.count > 0 {
                    return 146
                }else{
                    return 64
                }
                
                
            case 3:
                return cellHeightTime!.rawValue
            case 4:
                return 76
            case 5:
                return 44 //632
            case 6 :
                return 64
            default:
                print("")
                return 100
            }

        }
        
        
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            switch indexPath.row {
                
            case 0:
             print("")
            case 1:
               print("")
            case 2:
            print("")
            
            if !self.summaryBool{
                self.navigationController?.navigationBar.barTintColor = UIColor.lightGray
                
                let inviteFriends = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "inviteFriends") as? InviteFriendViewController
            
                inviteFriends?.gatheringView = self
                self.navigationController?.pushViewController(inviteFriends!, animated: true)
//                self.modalPresentationStyle = .overCurrentContext
//                self.present(inviteFriends!, animated: true, completion: nil)
                }
                
            case 3:
            print("")
            case 4:
            print("")
            
//            if self.cellHeightTime == CellHeight.Third {
//            self.cellHeightTime = CellHeight.Fourth
//                self.gatheringTableView.reloadData()
//            }
            if !self.summaryBool{
            self.performSegue(withIdentifier: "showLocation", sender: nil)
            }
            case 5:
            print("")
            
            default:
            print("")
                
            }
        }
    }

