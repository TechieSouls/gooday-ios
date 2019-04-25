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

protocol TimePickerDoneProtocol : class {
    func timePickerDoneButtonPressed(timeInMillis: Int)
    func timePickerCancelButtonPressed()
}
protocol GatheringInfoCellProtocol {
    func imageSelected()
}
class CreateGatheringV2ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var createGathTableView: UITableView!
    
    @IBOutlet weak var timePickerView: UIView!
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    @IBOutlet weak var previewGatheirngButton: UIButton!
    
    let picController = UIImagePickerController();

    var timePickerDoneDelegate: TimePickerDoneProtocol!;
    
    var gatheringInfoCellDelegate: GatheringInfoCellProtocol!;
    
    var createGathDto = CreateGathDto();
    
    var datePanelTableViewCellDelegate: DatePanelTableViewCell!
    
    var gatheringInfoTableViewCellDelegate: GatheringInfoTableViewCell!
    
    var event = Event();
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
        self.tabBarController?.tabBar.isHidden = true;

        createGathTableView.register(UINib(nibName: "DatePanelTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "DatePanelTableViewCell")

        createGathTableView.register(UINib(nibName: "GatheringInfoTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "GatheringInfoTableViewCell")
        
        createGathTableView.register(UINib(nibName: "PredictiveCalendarCellTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PredictiveCalendarCellTableViewCell")
        
        createGathTableView.register(UINib(nibName: "PredictiveInfoTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PredictiveInfoTableViewCell")
        
        createGathTableView.register(UINib(nibName: "SelectedFriendsCollectionTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SelectedFriendsCollectionTableViewCell")
        
        self.setupNavigationBar();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.setupNavigationBar();
        self.navigationController?.navigationBar.isHidden = false

    }
    
    func setupNavigationBar() {

        
        let backButton = UIButton();
        backButton.frame = CGRect(0, 0, 40, 40);
        backButton.setImage(UIImage.init(named: "abondan_event_icon"), for: .normal);
        backButton.addTarget(self, action: #selector(backButtonPressed), for: UIControlEvents.touchUpInside)
        
        let backButtonBarButton = UIBarButtonItem.init(customView: backButton)
        
        navigationItem.leftBarButtonItem = backButtonBarButton;
        
        let textfield = UITextField(frame: CGRect(80, 0, self.navigationController!.navigationBar.frame.size.width, 21.0));
        textfield.delegate = self;
        textfield.placeholder = "Title"
        navigationItem.titleView = textfield;
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
        event.title = updatedTextString as! String;
        
        if (event.title.count != 0) {
            //Code to show hide Event Preview Button.
            createGathDto.trackGatheringDataFilled[CreateGatheringFields.titleField] = true;
            showHidePreviewGatheringButton();
        } else {
            //Code to show hide Event Preview Button.
            createGathDto.trackGatheringDataFilled[CreateGatheringFields.titleField] = false;
            showHidePreviewGatheringButton();
        }
        
        return true;
    }
    
    func takePicture() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            picController.sourceType = UIImagePickerControllerSourceType.camera
            picController.allowsEditing = true
            picController.delegate = self
            picController.mediaTypes = [kUTTypeImage as String]
            self.present(picController, animated: true, completion: nil)
        }
    }
    
    func selectPicture() {
        //self.checkPermission();
        
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
            
           
            gatheringInfoCellDelegate.imageSelected();
            event.imageToUpload = image;
            let uploadImage = event.imageToUpload.compressImage(newSizeWidth: 720, newSizeHeight: 720, compressionQuality: 1.0)
        }
        
        picker.dismiss(animated: true, completion: nil);
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
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func showHidePreviewGatheringButton() {
        let isFormFilled = GatheringManager().allFieldsFilled(createGathDto: createGathDto);
        if (isFormFilled == true) {
            previewGatheirngButton.isHidden = false;
        } else {
            previewGatheirngButton.isHidden = true;
        }
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
        
        let viewController: GatheringInvitationViewController = storyboard?.instantiateViewController(withIdentifier: "GatheringInvitationViewController") as! GatheringInvitationViewController;
        viewController.event = self.event;
        self.navigationController?.pushViewController(viewController, animated: true);
    }
    
    @objc func backButtonPressed() {
        
        UILabel.appearance(whenContainedInInstancesOf:
            [UIAlertController.self]).numberOfLines = 2
        
        UILabel.appearance(whenContainedInInstancesOf:
            [UIAlertController.self]).lineBreakMode = .byWordWrapping
        let alert = UIAlertController(title: "Abondaon Event?", message: "If you decicde to leave this page, all progress will be lost.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Leave", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
            self.navigationController?.popViewController(animated: true);
            self.navigationController?.popViewController(animated: true);
        }))
        alert.addAction(UIAlertAction(title: "Stay", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
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
}
