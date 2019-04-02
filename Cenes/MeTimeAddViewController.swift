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

class MeTimeAddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NVActivityIndicatorViewable, UITextFieldDelegate {

    @IBOutlet weak var meTimeCard: UIView!
    
    @IBOutlet weak var backButtonView: UIView!
    
    @IBOutlet weak var withoutimageView: UIView!
    
    @IBOutlet weak var titletextField: UITextField!  //Title
    
    @IBOutlet weak var lblMeTimeTitle: UILabel!
    
    @IBOutlet weak var startTimeView: UIView!
    @IBOutlet weak var startTimeLabel: UILabel!
   
    @IBOutlet weak var endTimeView: UIView!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    
    
    @IBOutlet weak var timepPickerView: UIView!
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    @IBOutlet weak var cancelTimePickerBtn: UIButton!
    
    @IBOutlet weak var doneTimePickerButton: UIButton!
    
    @IBOutlet weak var meTimeImageView: UIImageView!
    
    @IBOutlet weak var sunday: UIButton!
    @IBOutlet weak var monday: UIButton!
    @IBOutlet weak var tuesday: UIButton!
    @IBOutlet weak var wednesday: UIButton!
    @IBOutlet weak var thursday: UIButton!
    @IBOutlet weak var friday: UIButton!
    @IBOutlet weak var saturday: UIButton!
    
    var metimeRecurringEvent = MetimeRecurringEvent();
    
    var dateSelected = "";
    var daySelectUnselectMap:[String: Bool] = [:];
    var loggedInUser = User();
    let picController = UIImagePickerController();
    var imageToUpload: UIImage!;
    var newMeTimeViewControllerDelegate: NewMeTimeViewController!;
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView();

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissMeTimeAddScreen))
        backButtonView.addGestureRecognizer(tap)
        
        //Image View
        meTimeImageView.setRounded();
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
        titletextField.borderStyle = UITextBorderStyle.none
        titletextField.layer.addSublayer(bottomLine)
        //show keyboard
        titletextField.delegate = self;
        
        //MeTime Title Label
        let lblMeTimeTitleTapGesture = UITapGestureRecognizer(target: self, action: #selector(lblMeTimeTitleTapped))
        lblMeTimeTitle.addGestureRecognizer(lblMeTimeTitleTapGesture)
        
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(photoIconClicked))
        withoutimageView.addGestureRecognizer(imageTapGesture)
        
        startTimeView.layer.borderWidth = 2;
        startTimeView.layer.borderColor = UIColor.white.cgColor
        startTimeView.layer.cornerRadius = 25
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(startTimeViewPressed))
        startTimeView.addGestureRecognizer(tapGesture)

        endTimeView.layer.borderWidth = 2;
        endTimeView.layer.borderColor = UIColor.white.cgColor;
        endTimeView.layer.cornerRadius = 25
        let endTapGesture = UITapGestureRecognizer(target: self, action: #selector(endTimeViewPressed))
        endTimeView.addGestureRecognizer(endTapGesture)

        btnSave.backgroundColor = cenesLabelBlue
        btnDelete.backgroundColor = cenesLabelBlue
        
        
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.meTimeCard.frame
        rectShape.position = self.meTimeCard.center
        rectShape.path = UIBezierPath(roundedRect: self.meTimeCard.bounds, byRoundingCorners:  [ .topRight , .topLeft], cornerRadii: CGSize(width: 30, height: 30)).cgPath
        
        self.meTimeCard.layer.backgroundColor = cenesLabelBlue.cgColor
        //Here I'm masking the textView's layer with rectShape layer
        self.meTimeCard.layer.mask = rectShape
        
        self.setupDayButtons(button: sunday);
        self.setupDayButtons(button: monday);
        self.setupDayButtons(button: tuesday);
        self.setupDayButtons(button: wednesday);
        self.setupDayButtons(button: thursday);
        self.setupDayButtons(button: friday);
        self.setupDayButtons(button: saturday);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.showMeTimeCardView();
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
        print(self.timePicker.clampedDate.millisecondsSince1970)
        print(self.timePicker.clampedDate.millisecondsSince1970)
        if (self.dateSelected == "startTime") {
            self.metimeRecurringEvent.startTime = self.timePicker.clampedDate.millisecondsSince1970;
            self.startTimeLabel.text = "START  \(self.timePicker.clampedDate.hmma())";
        } else if (self.dateSelected == "endTime") {
            self.metimeRecurringEvent.endTime = self.timePicker.clampedDate.millisecondsSince1970;
            self.endTimeLabel.text = "FINISH  \(self.timePicker.clampedDate.hmma())";

        }
    }
    
    @IBAction func btnDeletePressed(_ sender: Any) {

        if (self.metimeRecurringEvent.recurringEventId != nil) {
            
            self.startLoading();
            
            let queryStr = "recurringEventId=\(String(metimeRecurringEvent.recurringEventId))";
            MeTimeService().deleteMeTimeByRecurringEventId(queryStr: queryStr, token: self.loggedInUser.token, complete: {(response) in
                
                self.stopLoading();
                self.newMeTimeViewControllerDelegate.loadMeTimeData();
                self.hideMetimeCardView();
                
            });
        } else {
            self.hideMetimeCardView();
        }
    }
    
    @IBAction func btnSavePressed(_ sender: Any) {
        
        if (self.titletextField.text != nil && self.titletextField.text != "") {
            self.metimeRecurringEvent.title = self.titletextField.text;
        } else {
            self.metimeRecurringEvent.title = nil;
        }
        
        if (daySelectUnselectMap.count > 0) {
            
            var meTimeRecurringPatterns = [MeTimeRecurringPattern]();
            for (day, bool) in daySelectUnselectMap {
                let pattern = MeTimeRecurringPattern();
                pattern.dayOfWeek = MeTimeManager().dayNameAndKeyMap(dayName: day);
                meTimeRecurringPatterns.append(pattern);
            }
            self.metimeRecurringEvent.patterns = meTimeRecurringPatterns;
        }
        let validationResponse = MeTimeManager().validateMeTimeSave(meTimeRecurringEvent: metimeRecurringEvent);
        
        if (validationResponse != "") {
            let alert = UIAlertController(title: validationResponse, message: nil, preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        } else {
            print(self.metimeRecurringEvent.toString());
            self.metimeRecurringEvent.createdById = self.loggedInUser.userId;
            
            if Connectivity.isConnectedToInternet {
                self.startLoading();
                
                MeTimeService().saveMeTime(postData: self.metimeRecurringEvent.toDictionary(), token: self.loggedInUser.token, complete: {(response) in
                    
                    self.stopLoading();
                    
                    if (response.value(forKey: "status") != nil) {
                        let status = response.value(forKey: "status") as! String;
                        if (status == "success") {
                            
                            let recurringEvent = response.value(forKey: "recurringEvent") as! NSDictionary;
                            self.metimeRecurringEvent.recurringEventId = recurringEvent.value(forKey: "recurringEventId") as! Int32;
                            self.uploadMeTimeImage();
                            
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
    
    @IBAction func dayCirclePressed(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        switch button.tag {
        case 0:
            self.handleDayCirclePressed(button: button, label: "Sunday");
            break;
        case 1:
            self.handleDayCirclePressed(button: button, label: "Monday");
            break;
        case 2:
            self.handleDayCirclePressed(button: button, label: "Tuesday");
            break;
        case 3:
            self.handleDayCirclePressed(button: button, label: "Wednesday");
            break;
        case 4:
            self.handleDayCirclePressed(button: button, label: "Thursday");
            break;
        case 5:
            self.handleDayCirclePressed(button: button, label: "Friday");
            break;
        case 6:
            self.handleDayCirclePressed(button: button, label: "Saturday");
            break;
        default:
            print("Unknown language")
            return
        }
    }
    
    func showTimePicker() -> Void {
        let currentDate = Date();
        self.timePicker.setDate(currentDate, animated: true);
        
        self.timepPickerView.isHidden = false;
    }
    
    func hideTimePicker() -> Void {
        self.timepPickerView.isHidden = true;
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
            self.withoutimageView.isHidden = true;
            
            
            DispatchQueue.main.async {
                self.meTimeImageView.isHidden = false;
                self.meTimeImageView.image = image;
            }
            self.imageToUpload = image;
            let uploadImage = self.imageToUpload.compressImage(newSizeWidth: 212, newSizeHeight: 212, compressionQuality: 1.0)
        }
        
        picker.dismiss(animated: true, completion: nil);
    }
    
    func uploadMeTimeImage() ->  Void {
        
        if (self.imageToUpload != nil) {
            MeTimeService().uploadMeTimeImage(image: self.imageToUpload, recurringEventId: metimeRecurringEvent.recurringEventId, token: self.loggedInUser.token, complete: {(response) in
                self.newMeTimeViewControllerDelegate.loadMeTimeData();
                self.hideMetimeCardView();
            })
        } else {
            self.newMeTimeViewControllerDelegate.loadMeTimeData();
            self.hideMetimeCardView();
        }
    }
    
    func populateMeTimeCard() -> Void {
        
        self.titletextField.text = self.metimeRecurringEvent.title;
        self.lblMeTimeTitle.text =  self.metimeRecurringEvent.title;
        
        if (self.metimeRecurringEvent.photo != nil) {
            let imageUrl = "\(apiUrl)\(self.metimeRecurringEvent.photo!)";
            self.meTimeImageView.isHidden = false;
            self.withoutimageView.isHidden = true;
            self.meTimeImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage.init(named: "profile icon"));
        }
        
        if (self.metimeRecurringEvent.startTime != nil) {
            
            for pattern in self.metimeRecurringEvent.patterns {
                
                if (pattern.dayOfWeek == 1) {
                    sunday.backgroundColor = selectedColor;
                    daySelectUnselectMap["Sunday"] = true;
                } else if (pattern.dayOfWeek == 2) {
                    
                    daySelectUnselectMap["Monday"] = true;
                    monday.backgroundColor = selectedColor;
                } else if (pattern.dayOfWeek == 3) {
                    
                    daySelectUnselectMap["Tuesday"] = true;
                    tuesday.backgroundColor = selectedColor;
                } else if (pattern.dayOfWeek == 4) {
                    
                    daySelectUnselectMap["Wednesday"] = true;
                    wednesday.backgroundColor = selectedColor;
                } else if (pattern.dayOfWeek == 5) {
                    
                    daySelectUnselectMap["Thursday"] = true;
                    thursday.backgroundColor = selectedColor;
                } else if (pattern.dayOfWeek == 6) {
                    
                    daySelectUnselectMap["Friday"] = true;
                    friday.backgroundColor = selectedColor;
                } else if (pattern.dayOfWeek == 7) {
                    
                    daySelectUnselectMap["Saturday"] = true;
                    saturday.backgroundColor = selectedColor;
                }
            }
            
            self.startTimeLabel.text = "START  \(Date(millis: self.metimeRecurringEvent.startTime).hmma())";
            self.endTimeLabel.text = "FINISH  \(Date(millis: self.metimeRecurringEvent.endTime).hmma())";

        }
    }
    
    func startLoading() -> Void {
        
        var cgPoint: CGPoint = self.backButtonView.center;
        cgPoint.y = cgPoint.y/2
        self.activityIndicator.center = cgPoint;
        self.activityIndicator.hidesWhenStopped = true;
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray;
        self.backButtonView.addSubview(activityIndicator);
        
        activityIndicator.startAnimating();
        UIApplication.shared.beginIgnoringInteractionEvents();
    }
    
    func stopLoading() -> Void {
        self.activityIndicator.stopAnimating();
        UIApplication.shared.endIgnoringInteractionEvents();
    }
    
    func showMeTimeCardView() -> Void {
        self.meTimeCard.center.y += self.meTimeCard.bounds.height;
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn],
                       animations: {
                        self.meTimeCard.center.y -= self.meTimeCard.bounds.height
                        self.meTimeCard.layoutIfNeeded()
        }, completion: nil)
        self.meTimeCard.isHidden = false;
        if (self.metimeRecurringEvent.recurringEventId != nil) {
            self.lblMeTimeTitle.isHidden = false;
            self.titletextField.isHidden = true;
            self.populateMeTimeCard();
        } else {
            self.lblMeTimeTitle.isHidden = true;
            self.titletextField.isHidden = false;
            self.titletextField.becomeFirstResponder();
        }
    }
    
    func hideMetimeCardView() -> Void{
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

