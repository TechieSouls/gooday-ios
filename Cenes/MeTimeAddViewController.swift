//
//  MeTimeAddViewController.swift
//  Deploy
//
//  Created by Cenes_Dev on 20/03/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import MobileCoreServices
import Photos
import CoreData
import Mixpanel

class MeTimeAddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NVActivityIndicatorViewable, UITextFieldDelegate, UIScrollViewDelegate, MeTimeAddViewControllerProtocol {

    @IBOutlet weak var meTimeCard: UIView!
    
    @IBOutlet weak var backButtonView: UIView!
    
    @IBOutlet weak var withoutimageView: UIView!
    
    @IBOutlet weak var titletextField: UITextField!  //Title
    
    @IBOutlet weak var lblMeTimeTitle: UILabel!
    
   /* @IBOutlet weak var startTimeView: UIView!
    @IBOutlet weak var startTimeLabel: UILabel!
   
    @IBOutlet weak var endTimeView: UIView!
    @IBOutlet weak var endTimeLabel: UILabel!*/
    
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var timepPickerView: UIView!
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    @IBOutlet weak var cancelTimePickerBtn: UIButton!
    
    @IBOutlet weak var doneTimePickerButton: UIButton!
    
    @IBOutlet weak var meTimeImageView: UIImageView!
    
    @IBOutlet weak var metimeScrollView: UIScrollView!;
    
    @IBOutlet weak var uipageControlDots: UIPageControl!;

    /*@IBOutlet weak var sunday: UIButton!
    @IBOutlet weak var monday: UIButton!
    @IBOutlet weak var tuesday: UIButton!
    @IBOutlet weak var wednesday: UIButton!
    @IBOutlet weak var thursday: UIButton!
    @IBOutlet weak var friday: UIButton!
    @IBOutlet weak var saturday: UIButton!*/
    
    @IBOutlet weak var photoUploadSpinner: UIActivityIndicatorView!
    
    var metimeRecurringEvent: MetimeRecurringEvent!;
    var meTimeDaysView: MeTimeDaysView!;
    var meTimeFriendsView: MeTimeFriendsView!;
    
    var dateSelected = "";
    var daySelectUnselectMap:[String: Bool] = [:];
    var loggedInUser = User();
    let picController = UIImagePickerController();
    var imageToUpload: UIImage!;
    var newMeTimeViewControllerDelegate: NewMeTimeViewController!;
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView();
    var context: NSManagedObjectContext!;
    var metimeFiels = MeTimeFields();
    var inviteFriendsDto: InviteFriendsDto = InviteFriendsDto();

    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext;

        self.hideKeyboardWhenTappedAround();
        
        // Do any additional setup after loading the view.
        loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissMeTimeAddScreen))
        backButtonView.addGestureRecognizer(tap)
        
        photoUploadSpinner.isHidden = true;
        //Image View
        meTimeImageView.setRounded();
        meTimeImageView.contentMode = .scaleAspectFill
        meTimeImageView.layer.borderWidth = 2;
        meTimeImageView.layer.borderColor = UIColor.white.cgColor;
        let meTimeImageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(photoIconClicked))
        meTimeImageView.addGestureRecognizer(meTimeImageViewTapGesture)
        
        //Without Image View
        withoutimageView.roundedView()
        withoutimageView.layer.borderWidth = 2;
        withoutimageView.layer.borderColor = UIColor.white.cgColor;
        
        //Text Field
        let bottomLine = CALayer()
        bottomLine.frame = CGRect.init(x: 0, y: titletextField.frame.size.height - 1, width: titletextField.frame.size.width, height: 1)
        bottomLine.backgroundColor = UIColor.white.cgColor
        titletextField.borderStyle = UITextField.BorderStyle.none
        titletextField.layer.addSublayer(bottomLine)
        //show keyboard
        titletextField.delegate = self;
        
        //MeTime Title Label
        let lblMeTimeTitleTapGesture = UITapGestureRecognizer(target: self, action: #selector(lblMeTimeTitleTapped))
        lblMeTimeTitle.addGestureRecognizer(lblMeTimeTitleTapGesture)
        
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(photoIconClicked))
        withoutimageView.addGestureRecognizer(imageTapGesture)
        
        configurePageControl();
        
        metimeScrollView.frame = CGRect.init(x: metimeScrollView.frame.origin.x, y: metimeScrollView.frame.origin.y, width: self.meTimeCard.frame.width, height: metimeScrollView.frame.height);
        uipageControlDots.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControl.Event.valueChanged)

        meTimeDaysView = MeTimeDaysView.instanceFromNib() as! MeTimeDaysView;
        meTimeDaysView.frame = CGRect.init(x: 0, y: 0, width: metimeScrollView.frame.width, height: metimeScrollView.frame.height);
        meTimeDaysView.metimeAddViewController = self;
        metimeScrollView.addSubview(meTimeDaysView);
        
        //MeTime Friend View
        meTimeFriendsView = MeTimeFriendsView.instanceFromNib() as! MeTimeFriendsView;
        meTimeFriendsView.frame = CGRect.init(x: metimeScrollView.frame.width, y: 0, width: metimeScrollView.frame.width - 20, height: metimeScrollView.frame.height);
        
        let placeholderTapGesture = UITapGestureRecognizer(target: self, action: #selector(profilePicPlaceholderPressed))
        meTimeFriendsView.profilePicPlaceholder.addGestureRecognizer(placeholderTapGesture)

        let plusIconTapGesture = UITapGestureRecognizer(target: self, action: #selector(profilePicPlaceholderPressed))
        meTimeFriendsView.addMoreFriendsIcon.addGestureRecognizer(plusIconTapGesture);
        
        meTimeFriendsView.recurringEventMembers = [RecurringEventMember]();
        metimeScrollView.addSubview(meTimeFriendsView);
        metimeScrollView.contentSize.width = 2*metimeScrollView.frame.width;
        
        /*startTimeView.layer.borderWidth = 2;
        startTimeView.layer.borderColor = UIColor.white.cgColor
        startTimeView.layer.cornerRadius = 25*/
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(startTimeViewPressed))
        meTimeDaysView.startTimeView.addGestureRecognizer(tapGesture)

        /*endTimeView.layer.borderWidth = 2;
        endTimeView.layer.borderColor = UIColor.white.cgColor;
        endTimeView.layer.cornerRadius = 25*/
        let endTapGesture = UITapGestureRecognizer(target: self, action: #selector(endTimeViewPressed))
        meTimeDaysView.endTimeView.addGestureRecognizer(endTapGesture)

        btnSave.backgroundColor = cenesLabelBlue
        btnDelete.backgroundColor = cenesLabelBlue
        
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.meTimeCard.frame
        rectShape.position = self.meTimeCard.center
        rectShape.path = UIBezierPath(roundedRect: self.meTimeCard.bounds, byRoundingCorners:  [ .topRight , .topLeft], cornerRadii: CGSize(width: 30, height: 30)).cgPath
        
        self.meTimeCard.layer.backgroundColor = cenesLabelBlue.cgColor
        //Here I'm masking the textView's layer with rectShape layer
        self.meTimeCard.layer.mask = rectShape
        self.meTimeCard.center.y += self.meTimeCard.bounds.height;

        self.setupDayButtons(button: meTimeDaysView.sunday);
        self.setupDayButtons(button: meTimeDaysView.monday);
        self.setupDayButtons(button: meTimeDaysView.tuesday);
        self.setupDayButtons(button: meTimeDaysView.wednesday);
        self.setupDayButtons(button: meTimeDaysView.thursday);
        self.setupDayButtons(button: meTimeDaysView.friday);
        self.setupDayButtons(button: meTimeDaysView.saturday);
        
        if (metimeRecurringEvent == nil) {
            metimeRecurringEvent = MetimeRecurringEvent();
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: {
            self.showMeTimeCardView();
        });
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidLayoutSubviews() {
        uipageControlDots.transform = CGAffineTransform(scaleX: 2, y: 2)
    }

    @objc func profilePicPlaceholderPressed() {
        
        //self.view.isHidden = true;
        if (metimeRecurringEvent.recurringEventMembers.count > 0) {
            self.inviteFriendsDto = InviteFriendsDto();
            let userContact = UserContact();
            userContact.cenesMember = "Yes";
            userContact.friendId = Int(loggedInUser.userId);
            userContact.userId = Int(loggedInUser.userId);
            userContact.cenesName = loggedInUser.name;
            userContact.name = loggedInUser.name;
            userContact.photo = loggedInUser.photo;
            userContact.phone = loggedInUser.phone;
            userContact.user = loggedInUser;
            self.inviteFriendsDto.selectedFriendCollectionViewList.append(userContact);
            
            for recurringEventMember in metimeRecurringEvent.recurringEventMembers {
                
                let userContact = UserContact();
                userContact.cenesMember = "Yes";
                userContact.friendId = Int(recurringEventMember.userId);
                userContact.userId = Int(recurringEventMember.userId);
                if let userContactTmp = recurringEventMember.userContact {
                    userContact.userContactId = userContactTmp.userContactId;
                    userContact.cenesName = userContactTmp.name;
                    userContact.name = userContactTmp.name;
                    userContact.photo = userContactTmp.photo;
                    userContact.phone = userContactTmp.phone;
                    userContact.user = userContactTmp.user;
                }
                self.inviteFriendsDto.selectedFriendCollectionViewList.append(userContact);
                self.inviteFriendsDto.checkboxStateHolder[userContact.userContactId] = true;
            }
        }
        
        
        let friendsViewController = self.storyboard?.instantiateViewController(withIdentifier: "FriendsViewController") as! FriendsViewController;
        friendsViewController.inviteFriendsDto = inviteFriendsDto;
        friendsViewController.meTimeAddViewControllerProtocolDelegate = self;
        self.present(friendsViewController, animated: true, completion: nil);
        
    }
    
    @objc func startTimeViewPressed() {
        self.showTimePicker();
        self.dateSelected = "startTime";
    }
    @objc func endTimeViewPressed() {
        self.showTimePicker()
        self.dateSelected = "endTime";
    }
    
    @objc func dismissMeTimeAddScreen() {
        self.hideMetimeCardView();
    }
    
    /**
     * We will show the text field and hide the Label.
     **/
    @objc func lblMeTimeTitleTapped() {
        self.titletextField.isHidden = false;
        self.lblMeTimeTitle.isHidden = true;
        
        self.titletextField.becomeFirstResponder();
    }
    
    @IBAction func cancelTimePickerBtnPressed(_ sender: Any) {
        self.hideTimePicker();
    }
    
    @IBAction func doneTimePickerBtnPressed(_ sender: Any) {
        self.hideTimePicker();
      //  print(self.timePicker.clampedDate.millisecondsSince1970)
      //  print(self.timePicker.clampedDate.millisecondsSince1970)
        if (self.dateSelected == "startTime") {
          //  print(MetimeRecurringEventModel().findAllMetimeRecurringEvents().count);
            self.metimeRecurringEvent.startTime = self.timePicker.clampedDate.millisecondsSince1970;
           // print(MetimeRecurringEventModel().findAllMetimeRecurringEvents().count);
            self.meTimeDaysView.startTimeLabel.text = "START  \(self.timePicker.clampedDate.hmma())";
            if (metimeFiels.endTime == false) {
                let endDate = Calendar.current.date(byAdding: .minute, value: 60, to: Date(millis: self.metimeRecurringEvent.startTime));
                self.metimeRecurringEvent.endTime = endDate?.millisecondsSince1970;
                self.meTimeDaysView.endTimeLabel.text = "FINISH  \(endDate!.hmma())";
                metimeFiels.endTime = true;
            }
            
        } else if (self.dateSelected == "endTime") {
            metimeFiels.endTime = true;
          //  print(MetimeRecurringEventModel().findAllMetimeRecurringEvents().count);
            self.metimeRecurringEvent.endTime = self.timePicker.clampedDate.millisecondsSince1970;
            self.meTimeDaysView.endTimeLabel.text = "FINISH  \(self.timePicker.clampedDate.hmma())";
          //  print("FINISH  \(MetimeRecurringEventModel().findAllMetimeRecurringEvents().count)");

        }
    }
    
    @IBAction func btnDeletePressed(_ sender: Any) {

        if (self.metimeRecurringEvent.recurringEventId != nil && self.metimeRecurringEvent.recurringEventId != 0) {
            self.startLoading();
            
            let queryStr = "recurringEventId=\(String(metimeRecurringEvent.recurringEventId))";
            MeTimeService().deleteMeTimeByRecurringEventId(queryStr: queryStr, token: self.loggedInUser.token, complete: {(response) in
                
                self.stopLoading();
                
                sqlDatabaseManager.deleteMetimeRecurringEventByRecurringEventId(recurringEventId: self.metimeRecurringEvent.recurringEventId);
                //MetimeRecurringEventModel().deleteMetimeEventByMetimeRecurringId(recurringEventId: self.metimeRecurringEvent.recurringEventId);
                
                self.newMeTimeViewControllerDelegate.loadMeTimeData();
                self.hideMetimeCardView();
                
            });
        } else {
            self.hideMetimeCardView();
        }
    }
    
    @IBAction func btnSavePressed(_ sender: Any) {
        
        self.metimeRecurringEvent.createdById = self.loggedInUser.userId;

        if (daySelectUnselectMap.count > 0) {
            self.metimeRecurringEvent.patterns = [MeTimeRecurringPattern]();
            for (day, bool) in daySelectUnselectMap {
                let pattern = MeTimeRecurringPattern();
                pattern.dayOfWeek = Int(MeTimeManager().dayNameAndKeyMap(dayName: day));
                self.metimeRecurringEvent.patterns.append(pattern);
            }
        }
        if (self.titletextField.text != nil && self.titletextField.text != "") {
            self.metimeRecurringEvent.title = self.titletextField.text!;

        } else {
            self.metimeRecurringEvent.title = nil;
        }
    
        let validationResponse = MeTimeManager().validateMeTimeSave(meTimeRecurringEvent: metimeRecurringEvent);
        
        if (validationResponse != "") {
            let alert = UIAlertController(title: validationResponse, message: nil, preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        } else {
            
            if Connectivity.isConnectedToInternet {
                self.startLoading();
                
                Mixpanel.mainInstance().track(event: "MeTime",
                                              properties:[ "Action" : "MeTime Create Begins", "Title":"\(self.metimeRecurringEvent.title!)", "UserEmail": "\(loggedInUser.email!)", "UserName": "\(loggedInUser.name!)"]);
                
                let meTimerecurringPatternDict = self.metimeRecurringEvent.toDictionary();
                print(meTimerecurringPatternDict);
                MeTimeService().saveMeTime(postData: meTimerecurringPatternDict, token: self.loggedInUser.token, complete: {(response) in
                    
                    self.stopLoading();
                    
                    if (response.value(forKey: "status") != nil) {
                        let status = response.value(forKey: "status") as! String;
                        if (status == "success") {
                            
                            Mixpanel.mainInstance().track(event: "MeTime",
                                                          properties:[ "Action" : "MeTime Create Success", "Title":"\(self.metimeRecurringEvent.title!)", "UserEmail": "\(self.loggedInUser.email!)", "UserName": "\(self.loggedInUser.name!)"]);
                            
                            
                            if (response.value(forKey: "recurringEvent") != nil) {
                                let recurringEvent = response.value(forKey: "recurringEvent") as! NSDictionary;
                                    
                                if (self.metimeRecurringEvent.recurringEventId != nil) {
                                   
                                    sqlDatabaseManager.deleteMetimeRecurringEventByRecurringEventId(recurringEventId: self.metimeRecurringEvent.recurringEventId);
                                    //MetimeRecurringEventModel().deleteMetimeEventByMetimeRecurringId(recurringEventId: recurringEvent.value(forKey: "recurringEventId") as! Int32);
                                }

                                self.metimeRecurringEvent = MetimeRecurringEvent().loadMetimeRecurringEvent(meTimeDict: recurringEvent);
                                
                                sqlDatabaseManager.saveMeTimeRecurringEvent(metimeRecurringEvent: self.metimeRecurringEvent);
                                //self.metimeRecurringEvent = MetimeRecurringEventModel().saveMetimeRecurringEventMOFromDictionary(metimeRecurringEventDict: recurringEvent);
                                self.newMeTimeViewControllerDelegate.loadMeTimeData();
                                self.hideMetimeCardView();
                            } else {
                                self.showAlert(title: "Alert", message: "There is some error while saving MeTime.");
                            }
                        }
                    } else {
                        let alert = UIAlertController(title: "Error", message: response["message"] as! String, preferredStyle: .alert);
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                });
            } else {
                let alert = UIAlertController(title: "Alert", message: "No Internet Connectivity", preferredStyle: .alert);
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    
    @IBAction func timePicketChanged(_ sender: Any) {
        let dateFormatter = DateFormatter()//3
        dateFormatter.dateFormat = "h:mm"
        print(dateFormatter.string(from: self.timePicker.date))//11
        print(self.timePicker.date.toMillis())//11

    }
    
    func showTimePicker() -> Void {
        let currentDate = Date();
        self.timePicker.setDate(currentDate, animated: true);
        
        self.timepPickerView.isHidden = false;
        self.timepPickerView.frame = CGRect.init( x: self.timepPickerView.frame.origin.x, y: self.view.frame.height - self.timepPickerView.frame.height, width: self.timepPickerView.frame.width, height: self.timepPickerView.frame.height);
        self.meTimeCard.frame = CGRect.init(x: self.meTimeCard.frame.origin.x, y: self.view.frame.height - (self.timepPickerView.frame.height + self.meTimeCard.frame.height), width: self.meTimeCard.frame.width, height: self.meTimeCard.frame.height);
    }
    
    func hideTimePicker() -> Void {
        self.timepPickerView.isHidden = true;
        self.meTimeCard.frame = CGRect.init(x: self.meTimeCard.frame.origin.x, y: self.view.frame.height - (self.meTimeCard.frame.height), width: self.meTimeCard.frame.width, height: self.meTimeCard.frame.height);
    }
    
    func setupDayButtons(button: UIButton) -> Void {
        button.roundedView();
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .clear
    }
    
    func selectDay(button: UIButton) -> Void {
        button.backgroundColor = selectedColor
    }
    
    func unselectDay(button: UIButton) -> Void {
        button.backgroundColor = .clear
    }
    
    func handleDayCirclePressed(button: UIButton, label: String) -> Void {
        
        if (daySelectUnselectMap[label] == nil) {
            daySelectUnselectMap[label] = true;
            self.selectDay(button: button);
        } else {
            daySelectUnselectMap.removeValue(forKey: label);
            self.unselectDay(button: button);
        }
        print(daySelectUnselectMap)
    }
    
    @objc func photoIconClicked() {
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // create an action
        let uploadPhotoAction: UIAlertAction = UIAlertAction(title: "Upload Photo", style: .default) { action -> Void in
            self.selectPicture();
                    }
        uploadPhotoAction.setValue(selectedColor, forKey: "titleTextColor")
        let takePhotoAction: UIAlertAction = UIAlertAction(title: "Take Photo", style: .default) { action -> Void in
            self.takePicture();
        }
        takePhotoAction.setValue(cenesLabelBlue, forKey: "titleTextColor")
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        actionSheetController.addAction(uploadPhotoAction)
        actionSheetController.addAction(takePhotoAction)
        actionSheetController.addAction(cancelAction)
        
        // present an actionSheet...
        addActionSheetForiPad(actionSheet: actionSheetController)
        present(actionSheetController, animated: true, completion: nil)
    }
    
    func takePicture() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            self.picController.sourceType = UIImagePickerController.SourceType.camera
            self.picController.allowsEditing = true
            self.picController.delegate = self
            self.picController.mediaTypes = [kUTTypeImage as String]
            present(picController, animated: true, completion: nil)
        }
    }
    
    func selectPicture() {
        //self.checkPermission();
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            self.picController.delegate = self
            self.picController.sourceType = UIImagePickerController.SourceType.photoLibrary;
            self.picController.allowsEditing = true
            self.picController.mediaTypes = [kUTTypeImage as String]
            self.present(picController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
            self.withoutimageView.isHidden = true;
            
            
            DispatchQueue.main.async {
                self.meTimeImageView.isHidden = false;
                self.meTimeImageView.image = image;
            }
            self.imageToUpload = image;
            let uploadImage = self.imageToUpload.compressImage(newSizeWidth: 212, newSizeHeight: 212, compressionQuality: 1.0);
            
            if (self.metimeRecurringEvent.recurringEventId != nil) {
                self.uploadMeTimeImage();
            } else {
                self.getUploadImageLink();
            }
        }
        
        picker.dismiss(animated: true, completion: nil);
    }
    
    func uploadMeTimeImage() ->  Void {
        
        if (self.imageToUpload != nil) {
            self.view.isUserInteractionEnabled = false;
            self.photoUploadSpinner.isHidden = false;
            self.photoUploadSpinner.startAnimating();
            
            MeTimeService().uploadMeTimeImage(image: self.imageToUpload, recurringEventId: metimeRecurringEvent.recurringEventId, token: self.loggedInUser.token, complete: {(response) in
                
                self.view.isUserInteractionEnabled = true;
                self.photoUploadSpinner.isHidden = true;
                self.photoUploadSpinner.stopAnimating();
                
                    let recurringEventId = response.value(forKey: "recurringEventId") as? Int32;
                if (recurringEventId != nil) {
                        
                        self.metimeRecurringEvent.photo = (response.value(forKey: "photo") as! String);
                    sqlDatabaseManager.deleteMetimeRecurringEventByRecurringEventId(recurringEventId: self.metimeRecurringEvent.recurringEventId);
                    
                    sqlDatabaseManager.saveMeTimeRecurringEvent(metimeRecurringEvent: self.metimeRecurringEvent) ;
                    self.newMeTimeViewControllerDelegate.loadMeTimeData();
                    self.newMeTimeViewControllerDelegate.meTimeItemsTableView.reloadData();
                    }
                });
        }
    }
    
    func getUploadImageLink() ->  Void {
        
        if (self.imageToUpload != nil) {
            
            self.view.isUserInteractionEnabled = false;
            self.photoUploadSpinner.isHidden = false;
            self.photoUploadSpinner.startAnimating();
            
            MeTimeService().uploadMeTimeImageVersion2(image: self.imageToUpload, userId: loggedInUser.userId, token: self.loggedInUser.token, complete: {(response) in
                self.view.isUserInteractionEnabled = true;
                self.photoUploadSpinner.isHidden = true;
                self.photoUploadSpinner.stopAnimating();

                let success = response.value(forKey: "success") as! Bool;
                if (success == true) {
                    
                    let photoUrl = response.value(forKey: "data") as! String;
                    self.metimeRecurringEvent.photo = photoUrl;
                }
                   
            });
        }
    }
    
    func populateMeTimeCard() -> Void {
        
        if (self.metimeRecurringEvent.title != nil ) {
            
            self.titletextField.text = self.metimeRecurringEvent.title;
            self.lblMeTimeTitle.text =  self.metimeRecurringEvent.title;
        }
        
        if (self.metimeRecurringEvent.photo != nil) {
            let imageUrl = "\(imageUploadDomain)\(self.metimeRecurringEvent.photo!)";
            self.meTimeImageView.isHidden = false;
            self.withoutimageView.isHidden = true;
            self.meTimeImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage.init(named: "profile icon"));
        }
        
        if (self.metimeRecurringEvent.startTime != nil) {
            
            for pattern in self.metimeRecurringEvent.patterns {
                
                if (pattern.dayOfWeek == 1) {
                    self.meTimeDaysView.sunday.backgroundColor = selectedColor;
                    daySelectUnselectMap["Sunday"] = true;
                } else if (pattern.dayOfWeek == 2) {
                    
                    daySelectUnselectMap["Monday"] = true;
                    self.meTimeDaysView.monday.backgroundColor = selectedColor;
                } else if (pattern.dayOfWeek == 3) {
                    
                    daySelectUnselectMap["Tuesday"] = true;
                    self.meTimeDaysView.tuesday.backgroundColor = selectedColor;
                } else if (pattern.dayOfWeek == 4) {
                    
                    daySelectUnselectMap["Wednesday"] = true;
                    self.meTimeDaysView.wednesday.backgroundColor = selectedColor;
                } else if (pattern.dayOfWeek == 5) {
                    
                    daySelectUnselectMap["Thursday"] = true;
                    self.meTimeDaysView.thursday.backgroundColor = selectedColor;
                } else if (pattern.dayOfWeek == 6) {
                    
                    daySelectUnselectMap["Friday"] = true;
                    self.meTimeDaysView.friday.backgroundColor = selectedColor;
                } else if (pattern.dayOfWeek == 7) {
                    
                    daySelectUnselectMap["Saturday"] = true;
                    self.meTimeDaysView.saturday.backgroundColor = selectedColor;
                }
            }
            
            self.meTimeDaysView.startTimeLabel.text = "START  \(Date(millis: self.metimeRecurringEvent.startTime).hmma())";
            self.meTimeDaysView.endTimeLabel.text = "FINISH  \(Date(millis: self.metimeRecurringEvent.endTime).hmma())";

        }
        
        if (metimeRecurringEvent.recurringEventMembers.count > 0) {
            
            let userContact = UserContact();
            userContact.cenesMember = "Yes";
            userContact.friendId = Int(loggedInUser.userId);
            userContact.userId = Int(loggedInUser.userId);
            userContact.cenesName = loggedInUser.name;
            userContact.name = loggedInUser.name;
            userContact.photo = loggedInUser.photo;
            userContact.phone = loggedInUser.phone;
            userContact.user = loggedInUser;
            self.inviteFriendsDto.selectedFriendCollectionViewList.append(userContact);
            
            for recurringEventMember in metimeRecurringEvent.recurringEventMembers {
                
                let userContact = UserContact();
                userContact.cenesMember = "Yes";
                userContact.friendId = Int(recurringEventMember.userId);
                userContact.userId = Int(recurringEventMember.userId);
                if let userContactTmp = recurringEventMember.userContact {
                    userContact.userContactId = userContactTmp.userContactId;
                    userContact.cenesName = userContactTmp.name;
                    userContact.name = userContactTmp.name;
                    userContact.photo = userContactTmp.photo;
                    userContact.phone = userContactTmp.phone;
                    userContact.user = userContactTmp.user;
                }
               
                if (userContact.userContactId != nil) {
                    self.inviteFriendsDto.selectedFriendCollectionViewList.append(userContact);
                    self.inviteFriendsDto.checkboxStateHolder[userContact.userContactId] = true;
                }
            }
        
        }
    }
    
    func startLoading() -> Void {
        
        var cgPoint: CGPoint = self.backButtonView.center;
        cgPoint.y = cgPoint.y/2
        self.activityIndicator.center = cgPoint;
        self.activityIndicator.hidesWhenStopped = true;
        self.activityIndicator.style = UIActivityIndicatorView.Style.gray;
        self.backButtonView.addSubview(activityIndicator);
        
        activityIndicator.startAnimating();
        UIApplication.shared.beginIgnoringInteractionEvents();
    }
    
    func stopLoading() -> Void {
        self.activityIndicator.stopAnimating();
        UIApplication.shared.endIgnoringInteractionEvents();
    }
    
    func showMeTimeCardView() -> Void {
        //self.meTimeCard.isHidden = false;
        //self.meTimeCard.center.y += self.meTimeCard.bounds.height;
        if (self.metimeRecurringEvent != nil && self.metimeRecurringEvent.recurringEventId != nil) {
            self.lblMeTimeTitle.isHidden = false;
            self.titletextField.isHidden = true;
            self.populateMeTimeCard();
        } else {
            self.lblMeTimeTitle.isHidden = true;
            self.titletextField.isHidden = false;
            self.titletextField.becomeFirstResponder();
        }
        UIView.animate(withDuration: 0.2, delay: 0.5, options: [.curveEaseIn, .curveLinear, .layoutSubviews],
                       animations: {
                        
                        let diff = self.meTimeCard.center.y - self.meTimeCard.bounds.height;
                        print("Diff : ", diff, " and Center Y : ",self.meTimeCard.center.y, "Height : ",self.meTimeCard.bounds.height, "After Multiple : ",self.meTimeCard.center.y * (0.9*0.61));
                        
                        self.meTimeCard.center.y -= self.meTimeCard.bounds.height;
                        self.meTimeCard.layoutIfNeeded();
                        
        }, completion: {(_ completed: Bool) -> Void in
            
        });
    }
    
    func hideMetimeCardView() -> Void {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear],
                       animations: {
                        self.meTimeCard.center.y += self.meTimeCard.bounds.height
                        self.meTimeCard.layoutIfNeeded()
                        
        },  completion: {(_ completed: Bool) -> Void in
            self.meTimeCard.isHidden = true
            self.newMeTimeViewControllerDelegate.tabBarController?.tabBar.isHidden = false;
            self.newMeTimeViewControllerDelegate.removeBlurredBackgroundView();
            self.dismiss(animated: false, completion: nil);
        })
    }
    
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        self.uipageControlDots.numberOfPages = 2
        self.uipageControlDots.currentPage = 0
    }
    
    // MARK : TO CHANGE WHILE CLICKING ON PAGE CONTROL
    @objc func changePage(sender: AnyObject) {
        let x = CGFloat(uipageControlDots.currentPage) * metimeScrollView.frame.size.width
        metimeScrollView.setContentOffset(CGPoint(x: x,y :0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        self.uipageControlDots.currentPage = Int(pageNumber)
        if (pageNumber == 1) {
            if (metimeRecurringEvent.recurringEventMembers.count > 0) {
                meTimeFriendsView.recurringEventMembers = metimeRecurringEvent.recurringEventMembers;
                meTimeFriendsView.profilePicBackgroundView.isHidden = true;
                meTimeFriendsView.metimeFriendlistView.isHidden = false;
                meTimeFriendsView.friendlistCollectionView.reloadData();
            }
        }
    }

    func friendsDonePressed(eventMembers: [EventMember]) {
        print("Friends Done Pressed.....");
        self.metimeRecurringEvent.recurringEventMembers = [RecurringEventMember]();
        if (eventMembers.count > 1) {
            self.inviteFriendsDto = InviteFriendsDto();
            for eventMemberTmp in eventMembers {
                if (eventMemberTmp.userId == loggedInUser.userId) {
                    continue;
                }
                let recurringEventMember = RecurringEventMember();
                recurringEventMember.userId = eventMemberTmp.userId;
                recurringEventMember.user = eventMemberTmp.user;
                recurringEventMember.userContact = eventMemberTmp.userContact;
                self.metimeRecurringEvent.recurringEventMembers.append(recurringEventMember);
                
                    
                let userContact = UserContact();
                userContact.cenesMember = "Yes";
                userContact.friendId = Int(eventMemberTmp.userId);
                userContact.userId = Int(eventMemberTmp.userId);
                if let userContactTmp = recurringEventMember.userContact {
                    userContact.userContactId = userContactTmp.userContactId;
                    userContact.cenesName = userContactTmp.name;
                    userContact.name = userContactTmp.name;
                    userContact.photo = userContactTmp.photo;
                    userContact.phone = userContactTmp.phone;
                    userContact.user = userContactTmp.user;
                }
                self.inviteFriendsDto.selectedFriendCollectionViewList.append(userContact);
                self.inviteFriendsDto.checkboxStateHolder[userContact.userContactId] = true;
            }
            
            meTimeFriendsView.metimeFriendlistView.isHidden = false;
            meTimeFriendsView.profilePicBackgroundView.isHidden = true;
            
            meTimeFriendsView.recurringEventMembers = self.metimeRecurringEvent.recurringEventMembers;
            meTimeFriendsView.friendlistCollectionView.reloadData();
        } else {
            
            self.inviteFriendsDto = InviteFriendsDto();
            meTimeFriendsView.metimeFriendlistView.isHidden = true;
            meTimeFriendsView.profilePicBackgroundView.isHidden = false;
            //meTimeFriendsView.recurringEventMembers = self.metimeRecurringEvent.recurringEventMembers;
            //meTimeFriendsView.friendlistCollectionView.reloadData();
        }
    }
}

extension MeTimeAddViewController: UITextViewDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        
        if (textField.text != "") {
            self.lblMeTimeTitle.text = textField.text;
            textField.isHidden = true;
            self.lblMeTimeTitle.isHidden = false;
        }
        return true;
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
