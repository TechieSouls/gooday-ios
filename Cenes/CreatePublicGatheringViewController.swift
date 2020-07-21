//
//  CreatePublicGatheringViewController.swift
//  Cenes
//
//  Created by Cenes_Dev on 30/06/2020.
//  Copyright © 2020 Cenes Pvt Ltd. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices
import VisualEffectView
import NVActivityIndicatorView
import Mantis

protocol GatheringImageTableViewCellDelegate {
    func imageSelected(selectedImg: UIImage);
}

class CreatePublicGatheringViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NVActivityIndicatorViewable, CropViewControllerDelegate {

    @IBOutlet weak var createPublicGathTableView: UITableView!
    @IBOutlet weak var previewBtn: UIButton!

    
    var gatheringImageTableViewCellDelegate: GatheringImageTableViewCell!
    var event: Event!;
    let picController = UIImagePickerController();
    var imageSelectedOption = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createPublicGathTableView.register(UINib(nibName: "GatheringImageTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "GatheringImageTableViewCell")

        createPublicGathTableView.register(UINib(nibName: "GatheringCategoryAndDescTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "GatheringCategoryAndDescTableViewCell")
        
        createPublicGathTableView.register(UINib(nibName: "DatePanelTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "DatePanelTableViewCell")

        createPublicGathTableView.register(UINib(nibName: "PublicGatheringInfoTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PublicGatheringInfoTableViewCell");
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true;
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @objc func openShareSheetForCoverImage() {
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
    
    func takePicture() {
        imageSelectedOption = "Camera";
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            picController.sourceType = UIImagePickerController.SourceType.camera
            //picController.allowsEditing = true
            picController.delegate = self
            picController.mediaTypes = [kUTTypeImage as String]
            self.present(picController, animated: true, completion: nil)
        }
    }
    
    func selectPicture() {
        //self.checkPermission();
        imageSelectedOption = "Gallery";

        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            picController.delegate = self
            picController.sourceType = UIImagePickerController.SourceType.photoLibrary;
            //picController.allowsEditing = true
            picController.mediaTypes = [kUTTypeImage as String]
            self.present(picController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

            if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
                picker.dismiss(animated: true, completion: nil);
                let cropViewController = Mantis.cropViewController(image: image)
                cropViewController.delegate = self
                cropViewController.modalPresentationStyle = .fullScreen
                self.present(cropViewController, animated: true)
            }
            
        }
    
    
    func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage, transformation: Transformation) {
           cropViewController.dismiss(animated: true, completion: {
               
            if (self.gatheringImageTableViewCellDelegate != nil) {
                self.gatheringImageTableViewCellDelegate.imageSelected(selectedImg: cropped);
                }
           });
    }
    func cropViewControllerDidFailToCrop(_ cropViewController: CropViewController, original: UIImage) {}
    func cropViewControllerDidCancel(_ cropViewController: CropViewController, original: UIImage) {
           cropViewController.dismiss(animated: true, completion: {
               
           });
    }
    
    @IBAction func previewBtnPressed(sender: UIButton) {
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "PublicGatheringPreviewViewController") as! PublicGatheringPreviewViewController;
        viewController.event = self.event;
        self.navigationController?.pushViewController(viewController, animated: true);
    }
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }

}


extension CreatePublicGatheringViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "GatheringImageTableViewCell", for: indexPath) as! GatheringImageTableViewCell;
                
                if (event == nil || (event.eventId == nil && event.eventPicture == nil) || event.eventPicture == nil) {
                    cell.gatheringImage.isHidden = true;
                    cell.gatheringImagePlaceholder.isHidden = false;
                } else {
                    cell.gatheringImage.isHidden = false;
                    cell.gatheringImagePlaceholder.isHidden = true;
                }
                
                let imageUploadTapListener = UITapGestureRecognizer.init(target: self, action: #selector(openShareSheetForCoverImage));
                cell.gatheringImagePlaceholder  .addGestureRecognizer(imageUploadTapListener);
                
                self.gatheringImageTableViewCellDelegate = cell;
                return cell;
            
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "GatheringCategoryAndDescTableViewCell", for: indexPath) as! GatheringCategoryAndDescTableViewCell;
                return cell;
            case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DatePanelTableViewCell", for: indexPath) as! DatePanelTableViewCell;
            return cell;
            case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PublicGatheringInfoTableViewCell", for: indexPath) as! PublicGatheringInfoTableViewCell;
            return cell;
            default:
                return UITableViewCell();
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
            case 0:
                
                return self.view.frame.width + (self.view.frame.width * 20)/100;
            
            case 1:

                return 267;
            
            case 2:

                return 125;
            
            case 3:

                return 100;

            default:
                return 0;
        }
    }
}
