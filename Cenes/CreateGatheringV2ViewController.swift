//
//  CreateGatheringV2ViewController.swift
//  Deploy
//
//  Created by Cenes_Dev on 18/04/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices
import VisualEffectView
import NVActivityIndicatorView
import Mantis
import CoreData

protocol TimePickerDoneProtocol : class {
    func timePickerDoneButtonPressed(timeInMillis: Int)
    func timePickerCancelButtonPressed()
}
protocol GatheringInfoCellProtocol {
    func imageSelected()
    func uploadImageAndGetUrl(imageToUpload: UIImage
    );
    func uploadImageLabelOnly();
}
class CreateGatheringV2ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,CreateGatheringProtocol, NVActivityIndicatorViewable, CreateGatherigV2Protocol, CropViewControllerProtocal {

    
    
    @IBOutlet weak var createGathTableView: UITableView!
    
    @IBOutlet weak var timePickerView: UIView!
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    @IBOutlet weak var previewGatheringBtnView: UIView!
    
    @IBOutlet weak var previewGatheirngButton: UIButton!
    
    let picController = UIImagePickerController();

    var timePickerDoneDelegate: TimePickerDoneProtocol!;
    
    var gatheringInfoCellDelegate: GatheringInfoCellProtocol!;
    
    var createGathDto = CreateGathDto();
    
    var datePanelTableViewCellDelegate: DatePanelTableViewCell!
    
    var gatheringInfoTableViewCellDelegate: GatheringInfoTableViewCell!
    
    var predictiveCalendarViewTableViewCellDelegate: PredictiveCalendarCellTableViewCell!

    var inviteFriendsDto: InviteFriendsDto = InviteFriendsDto();
    
    var event: Event!;
    
    var eventHost: EventMember!;
    
    var textfield = UITextField();
    
    var imageSelectedOption = "";
    
    var loggedInUser: User!;
    
    var fsCalendarElements: FSCalendarElements!
    
    var imageToUpload: UIImage!;
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext? = nil;

        
    var nactvityIndicatorView = NVActivityIndicatorView.init(frame: cgRectSizeLoading, type: NVActivityIndicatorType.ballRotateChase, color: UIColor.white, padding: 0.0);

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tabBarController?.tabBar.isHidden = true;
        timePickerView.backgroundColor = themeColor;
        timePicker.backgroundColor = UIColor.white;
        self.loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        context = self.appDelegate.persistentContainer.viewContext

        createGathTableView.register(UINib(nibName: "DatePanelTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "DatePanelTableViewCell")

        createGathTableView.register(UINib(nibName: "GatheringInfoTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "GatheringInfoTableViewCell")
        
        createGathTableView.register(UINib(nibName: "PredictiveCalendarCellTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PredictiveCalendarCellTableViewCell")
        
        createGathTableView.register(UINib(nibName: "PredictiveInfoTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PredictiveInfoTableViewCell")
        
        createGathTableView.register(UINib(nibName: "SelectedFriendsCollectionTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SelectedFriendsCollectionTableViewCell")
        
        if (event.eventId == nil || event.eventId == 0) {
            event.endTime = 0;
            event.createdById = self.loggedInUser.userId;
        } else {
            var eventMembers: [EventMember] = [EventMember]();
            for eventMem in event.eventMembers! {
                
                eventMembers.append(eventMem);

                if (eventMem.userId == self.loggedInUser.userId) {
                    eventHost = eventMem;
                }
            }
            
            var cenesUserContacts = [UserContact]();
            for eventMem in event.eventMembers! {
                if (eventMem.userContactId != nil) {
                    let cenesUserContact = CenesUserContactModel().fetchUserContactsByUserContactId(userContactId: eventMem.userContactId);
                    cenesUserContacts.append(cenesUserContact);
                }
                
            }
            
            //Converting Event Member into User Contacts
            var userContacts = [UserContact]();
            for eveMem in eventMembers {
                     
                let userContact = UserContact();
                if (eveMem.eventMemberId != nil) {
                    userContact.eventMemberId = eveMem.eventMemberId;
                }
                if let name = eveMem.name {
                    userContact.name = name;
                }
                
                if let userContactId = eveMem.userContactId {
                    userContact.userContactId = Int(userContactId);
                }
                
                if let userId = eveMem.userId {
                    userContact.userId = Int(userId);
                    userContact.friendId = Int(userId);
                }
                
                if let user = eveMem.user {
                    userContact.user = user;
                }
                
                if let photo = eveMem.photo {
                    userContact.photo = photo;
                }
                if let cenesMember = eveMem.cenesMember {
                    userContact.cenesMember = cenesMember;
                }
                
                if let status = eveMem.status {
                    userContact.status = status;
                }
                userContacts.append(userContact);
            }
            inviteFriendsDto.selectedFriendCollectionViewList = userContacts;
            showAllFields();
        }
        self.setupNavigationBar();
        self.fsCalendarElements = FSCalendarElements();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.setupNavigationBar();
        self.navigationController?.navigationBar.isHidden = false
        self.createGathTableView.reloadData();

    }
    
    func setupNavigationBar() {

        
        let backButton = UIButton();
        backButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40);
        backButton.setImage(UIImage.init(named: "abondan_event_icon"), for: .normal);
        backButton.addTarget(self, action: #selector(backButtonPressed), for: UIControlEvents.touchUpInside)
        
        let backButtonBarButton = UIBarButtonItem.init(customView: backButton)
        
        navigationItem.leftBarButtonItem = backButtonBarButton;
        
        textfield = UITextField(frame: CGRect(x: 80, y: 0, width: self.navigationController!.navigationBar.frame.size.width, height: 21.0));
        textfield.delegate = self;
        let attributes = [
            NSAttributedString.Key.foregroundColor.rawValue : UIColor.black,
            NSAttributedString.Key.font.rawValue : UIFont.init(name: "AvenirNext-Bold", size: 18) // Note the !
        ];
        textfield.defaultTextAttributes = attributes // call in viewDidLoad

        if (event.eventId != nil && event.eventId != 0) {
            let attributes = [
                NSAttributedStringKey.foregroundColor: UIColor.black,
                NSAttributedStringKey.font : UIFont(name: "AvenirNext-Bold", size: 18)! // Note the !
            ]
            textfield.attributedText = NSAttributedString(string: "\(event.title!)", attributes:attributes);
        } else {
            
            let attributes = [
                NSAttributedStringKey.foregroundColor: UIColor.lightGray,
                NSAttributedStringKey.font : UIFont(name: "AvenirNext-Bold", size: 18)! // Note the !
            ]
            textfield.attributedPlaceholder = NSAttributedString(string: "Event Name", attributes:attributes)

        }
        navigationItem.titleView = textfield;
        self.addDoneButtonOnKeyboard();
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var updatedTextString : NSString = textField.text as! NSString
        updatedTextString = updatedTextString.replacingCharacters(in: range, with: string) as NSString
        if (updatedTextString.length > 25) {
            return false;
        }
        
        event.title = updatedTextString as! String;
        
        if (event.title!.count != 0) {
            //Code to show hide Event Preview Button.
            createGathDto.trackGatheringDataFilled[CreateGatheringFields.titleField] = true;
            //showHidePreviewGatheringButton();
        } else {
            //Code to show hide Event Preview Button.
            createGathDto.trackGatheringDataFilled[CreateGatheringFields.titleField] = false;
            //showHidePreviewGatheringButton();
        }
        
        return true;
    }
    
    func takePicture() {
        imageSelectedOption = "Camera";
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            picController.sourceType = UIImagePickerControllerSourceType.camera
            //picController.allowsEditing = true
            picController.delegate = self
            picController.mediaTypes = [kUTTypeImage as String]
            self.present(picController, animated: true, completion: nil)
        }
    }
    
    func selectPicture() {
        //self.checkPermission();
        imageSelectedOption = "Gallery";

        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            picController.delegate = self
            picController.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            //picController.allowsEditing = true
            picController.mediaTypes = [kUTTypeImage as String]
            self.present(picController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
           
            /*gatheringInfoCellDelegate.imageSelected();
            event.imageToUpload = image;
            let uploadImage = event.imageToUpload.compressImage(newSizeWidth: 450, newSizeHeight: 900, compressionQuality: 1.0)
             */
            picker.dismiss(animated: true, completion: nil);

            /*let cropper = UIImageCropper(cropRatio: 2/3)
            cropper.delegate = self
            cropper.picker = nil
            cropper.image = image
            cropper.cropButtonText = "Choose";
            cropper.cancelButtonText = "Cancel"
            self.present(cropper, animated: true, completion: nil)*/
            
            /*let imageCropper = self.storyboard?.instantiateViewController(withIdentifier: "GatheringImagePickerViewController") as! GatheringImagePickerViewController
            imageCropper.imageToCrop = image;
            imageCropper.createGatherigV2ProtocoinglDelegate = self;
            self.present(imageCropper, animated: true, completion: nil)*/
            
            /*let imageCropper = self.storyboard?.instantiateViewController(withIdentifier: "MyImageCropperViewController") as! MyImageCropperViewController
            imageCropper.imageToCrop = image;
            imageCropper.createGatherigV2ProtocolDelegate = self;
            self.present(imageCropper, animated: true, completion: nil)*/
            
            let cropViewController = Mantis.cropViewController(image: image)
            cropViewController.delegate = self
            self.present(cropViewController, animated: true)
        }
        
    }
    
    func openShareSheetForCoverImage() {
        //let storyBoard = UIStoryboard.init(name: "Main", bundle: nil);
        //storyBoard.instantiateViewController(withIdentifier: "");
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
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func showHidePreviewGatheringButton(show: Bool) {
        //let isFormFilled = GatheringManager().allFieldsFilled(createGathDto: createGathDto);
        if (show == true) {
            previewGatheringBtnView.isHidden = false;
        } else {
            previewGatheringBtnView.isHidden = true;
        }
    }
    
    func showAllFields() {
        GatheringManager().makeAllFieldsFilled(createGathDto: createGathDto);
        previewGatheringBtnView.isHidden = false;
    }
    
    
    /** This is when user click on +  button to choose or edit the guests. */
    func openGuestListViewController() {
        let viewController: FriendsViewController = storyboard?.instantiateViewController(withIdentifier: "FriendsViewController") as! FriendsViewController;
        viewController.inviteFriendsDto = self.inviteFriendsDto;
        viewController.isFirstTime = false;
        viewController.eventId = event.eventId
        viewController.createGatheringProtocolDelegate = self;
        self.navigationController?.pushViewController(viewController, animated: true);
    }
    
    func friendsDonePressed(eventMembers: [EventMember]) {
        self.event.eventMembers = [EventMember]();
        for eventMem in eventMembers {
            if (eventMem.eventId == nil && self.event.eventId != nil && self.event.eventId != 0 && eventMem.eventMemberId != nil) {
                eventMem.eventId = self.event.eventId;
            }
            self.event.eventMembers.append(eventMem);
        }
        self.createGathTableView.reloadData();
        //If Predictive was on then, we would have to refesh the predictive calendar
        if (self.predictiveCalendarViewTableViewCellDelegate != nil && self.event.isPredictiveOn == true) {
            self.predictiveCalendarViewTableViewCellDelegate.showPredictions();
        }
    }
    
    func removeBlurredBackgroundView(viewToBlur: UIView) {
        
        for subview in viewToBlur.subviews {
            if subview.isKind(of: VisualEffectView.self) {
                subview.removeFromSuperview()
            }
        }
    }
    
    func addBlurBackgroundView(viewToBlur: UIView) -> Void {
        let bcColor = UIColor.init(red: 181/256, green: 181/256, blue: 182/256, alpha: 1)
        let visualEffectView = VisualEffectView(frame: CGRect(x: 0, y: 0, width: viewToBlur.frame.width, height: viewToBlur.frame.height))
        
        // Configure the view with tint color, blur radius, etc
        visualEffectView.colorTint = bcColor
        visualEffectView.colorTintAlpha = 0.5
        visualEffectView.blurRadius = 5
        visualEffectView.scale = 1
        
        viewToBlur.addSubview(visualEffectView)
    }
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        textfield.inputAccessoryView = doneToolbar
    }
    
    func showLoading() {
        self.startAnimating()
    }
    func hideLoading() {
        self.stopAnimating()
    }

    @IBAction func timePickerCancelPressed(_ sender: Any) {
        timePickerView.isHidden = true;
        timePickerDoneDelegate.timePickerCancelButtonPressed();

    }
    
    @IBAction func timePickerDonePressed(_ sender: Any) {
        timePickerDoneDelegate.timePickerDoneButtonPressed(timeInMillis: Int(timePicker.clampedDate.millisecondsSince1970));
        timePickerView.isHidden = true;
    }
    
    
    @IBAction func previewGatheringButtonPressed(_ sender: Any) {
        
        var isValid = true;
        
        if (self.createGathDto.trackGatheringDataFilled[CreateGatheringFields.titleField] == false) {
            isValid = false;
            self.showAlert(title: "Alert", message: "Please enter Event title.");
        } else if (self.createGathDto.trackGatheringDataFilled[CreateGatheringFields.startTimeField] == false) {
            
            isValid = false;
            self.showAlert(title: "Alert", message: "Please select start time");
        }  else if (self.createGathDto.trackGatheringDataFilled[CreateGatheringFields.endTimeField] == false) {
            
            isValid = false;
            self.showAlert(title: "Alert", message: "Please select end time");
        }   else if (self.createGathDto.trackGatheringDataFilled[CreateGatheringFields.endTimeField] == false) {
            
            isValid = false;
            self.showAlert(title: "Alert", message: "Please select event date");
        } else if (event.eventMembers!.count > 1) {
            
            if (self.createGathDto.trackGatheringDataFilled[CreateGatheringFields.locationField] == false) {
                
                isValid = false;
                self.showAlert(title: "Alert", message: "Please select event location");
                
            } else if (self.createGathDto.trackGatheringDataFilled[CreateGatheringFields.messageField] == false) {
                
                isValid = false;
                self.showAlert(title: "Alert", message: "Please add description");
            } else if (self.createGathDto.trackGatheringDataFilled[CreateGatheringFields.imageField] == false) {
                
                isValid = false;
                self.showAlert(title: "Alert", message: "Please select event picture");
                
            }
        }
        
        if (isValid == true) {
            if (self.event.eventId != nil && self.event.eventId != 0) {
                var hostExists = false;
                for eve in self.event.eventMembers! {
                    if ((eve.eventMemberId != nil && eve.eventMemberId == eventHost.eventMemberId) || (eve.userId != nil && eve.userId == eventHost.userId)) {
                        hostExists = true;
                    }
                }
                if (hostExists == false) {
                    self.event.eventMembers.append(eventHost);
                }
            }
            
            if (event.createdById == nil || event.createdById == 0) {
                event.createdById = self.loggedInUser.userId;
            }
            
            let viewController: GatheringInvitationViewController = storyboard?.instantiateViewController(withIdentifier: "GatheringInvitationViewController") as! GatheringInvitationViewController;
            viewController.event = self.event;
            if (viewController.event != nil && viewController.event.eventId != 0) {
                viewController.event.requestType = EventRequestType.EditEvent;
            }
            self.navigationController?.pushViewController(viewController, animated: true);
            
        }
    }
    
    @objc func backButtonPressed() {
        
        let alert = UIAlertController(title: "Abandon Event?", message: "If you decide to leave this page, all \nprogress will be lost.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Leave", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
            self.navigationController?.popToRootViewController(animated: false);
        }))
        alert.addAction(UIAlertAction(title: "Stay", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        // number of lines
        UILabel.appearance(whenContainedInInstancesOf: [UIAlertController.self]).numberOfLines = 0
        // for font
        UILabel.appearance(whenContainedInInstancesOf: [UIAlertController.self]).font = UIFont.systemFont(ofSize: 10.0)
    }
    @objc func doneButtonAction(){
        textfield.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "createGathMessageSeague") {
            let destinationVC = segue.destination as! CreateGatheringMessageViewController;
            if (event.description != nil) {
                destinationVC.descriptionMsg = event.description;
            }
            destinationVC.messageProtocolDelete = gatheringInfoTableViewCellDelegate;
        } else if (segue.identifier == "createGatheringLocationSeague") {
            let destinationVC = segue.destination as! CreateGatheringLocationViewController;
            destinationVC.selectedLocationProtocolDelegate = gatheringInfoTableViewCellDelegate;
        }
    }
    
    func didCropImage(originalImage: UIImage?, croppedImage: UIImage?) {
        gatheringInfoCellDelegate.imageSelected();
        if (imageSelectedOption == "Gallery") {
            self.imageToUpload = croppedImage!.fixedOrientation();

        } else if (imageSelectedOption == "Camera") {
            self.imageToUpload = croppedImage!.fixedOrientation().imageRotatedByDegrees(degrees: 90);
        }
         //let uploadImage = event.imageToUpload.compressImage(newSizeWidth: 450, newSizeHeight: 900, compressionQuality: 1.0)
        
    }
    
    //optional
    func didCancel() {
        self.dismiss(animated: true, completion: nil)
        print("did cancel")
    }
    
    func imageAfterCrop(cropperdImage: UIImage) {
        gatheringInfoCellDelegate.imageSelected();
        self.imageToUpload = cropperdImage.fixedOrientation().imageRotatedByDegrees(degrees: 90);
        gatheringInfoCellDelegate.uploadImageAndGetUrl(imageToUpload: self.imageToUpload);
    }
    
    func didGetCroppedImage(image: UIImage) {
        
        if (self.gatheringInfoCellDelegate != nil) {
            self.gatheringInfoCellDelegate.imageSelected();
            //event.imageToUpload = UIImage(data: UIImageJPEGRepresentation(image, UIImage.JPEGQuality.lowest.rawValue)!);
            self.imageToUpload = image.compressImage(newSizeWidth: 768, newSizeHeight: 1308, compressionQuality: Float(UIImage.JPEGQuality.highest.rawValue));
            
            if (Connectivity.isConnectedToInternet) {
                gatheringInfoCellDelegate.uploadImageAndGetUrl(imageToUpload: self.imageToUpload);
            } else {
                
                self.event.eventPictureBinary = UIImagePNGRepresentation(image)!;
                gatheringInfoCellDelegate.uploadImageLabelOnly();
            }
        } else {
            self.showAlert(title: "Error", message: "Cannot upload from screenshot")
        }
    }
}
