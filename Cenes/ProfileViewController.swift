//
//  ProfileViewController.swift
//  Cenes
//
//  Created by Redblink on 06/11/17.
//  Copyright © 2017 Redblink Pvt Ltd. All rights reserved.
//

import UIKit
import MobileCoreServices
import SideMenu
import NVActivityIndicatorView

class ProfileViewController: UIViewController,UIImagePickerControllerDelegate ,UINavigationControllerDelegate,NVActivityIndicatorViewable {

    @IBOutlet weak var profileImage: UIImageView!
    
    var pImage : UIImage!
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var genderTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    var profileImageUser = UIImage(named: "profile icon")
    
    var image : UIImage!
    
    @IBOutlet weak var backViewBottomConstraint: NSLayoutConstraint!
    
    let picController = UIImagePickerController()
    var picChange = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
        nameTF.text = setting.value(forKey: "name") as? String
        emailTF.text = setting.value(forKey: "email") as? String
        
        if setting.value(forKey:"gender") != nil {
           genderTF.text =  setting.value(forKey:"gender") as? String
        }
        
        // Do any additional setup after loading the view.
        //self.navigationItem.hidesBackButton = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyBoard))
        self.view.addGestureRecognizer(tapGesture)
        if(image == nil)
        {
            
            if setting.value(forKey: "photo") != nil {
                let webServ = WebService()
                webServ.profilePicFromFacebook(url: setting.value(forKey: "photo")! as! String, completion: { image in
                    self.profileImageUser = image
                    self.setUpNavBar()
                })
            }
        }else{
            self.profileImageUser? = image
            self.profileImage.image = image
        }
        self.setUpNavBar()
        self.nameTF.addPaddingToTextFieldProfileView()
        self.emailTF.addPaddingToTextFieldProfileView()
        self.genderTF.addPaddingToTextFieldProfileView()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpNavBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setUpNavBar()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func hideKeyBoard(){
        self.nameTF?.resignFirstResponder()
        self.emailTF?.resignFirstResponder()
        self.genderTF?.resignFirstResponder()
        
    }
    
    
    
    
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
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
        self.pImage = image
        self.profileImage.image = image
        picChange = true
    }
    
    picker.dismiss(animated: true, completion: nil);
}


    func setUpNavBar(){
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            topItem.backBarButtonItem?.tintColor = UIColor.white
        }
//        let profileButton = UIButton.init(type: .custom)
//        let image = self.profileImageUser?.compressImage(newSizeWidth: 35, newSizeHeight: 35, compressionQuality: 1.0)
//        profileButton.imageView?.contentMode = .scaleAspectFill
//        profileButton.setBackgroundImage(image, for: UIControlState.normal)
//        profileButton.frame = CGRect.init(x: 0, y: 0, width: 35, height: 35)
//        profileButton.layer.cornerRadius = profileButton.frame.height/2
//        profileButton.clipsToBounds = true
//        profileButton.addTarget(self, action: #selector(profileButtonPressed), for: .touchUpInside)
//
//
//        let barButton = UIBarButtonItem.init(customView: profileButton)
//        self.navigationItem.leftBarButtonItem = barButton
        
        let doneButton = UIButton.init(type: .custom)
         doneButton.setTitle("Done", for: .normal)
         doneButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
         doneButton.layer.cornerRadius = doneButton.frame.height/2
         doneButton.clipsToBounds = true
         doneButton.addTarget(self, action: #selector(doneBarButtonPressed), for: .touchUpInside)

        
         let doneBarButton = UIBarButtonItem.init(customView: doneButton)
        
        
         self.navigationItem.rightBarButtonItem = doneBarButton
        
        
        
         /*let calendarButton = UIButton.init(type: .custom)
         
         calendarButton.setImage(Ionicons.iosCalendarOutline.image(25, color: UIColor.white), for: UIControlState.normal)
         //calendarButton.setImage(Ionicons.iosCalendarOutline.image(25, color: commonColor), for: UIControlState.selected)
         calendarButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
         calendarButton.layer.cornerRadius = calendarButton.frame.height/2
         calendarButton.clipsToBounds = true
         calendarButton.addTarget(self, action: #selector(calendarBarButtonPressed), for: .touchUpInside)
         
         let calendarBarButton = UIBarButtonItem.init(customView: calendarButton)
         
         let widthConstraint = calendarButton.widthAnchor.constraint(equalToConstant: 30)
         let heightConstraint = calendarButton.heightAnchor.constraint(equalToConstant: 30)
         heightConstraint.isActive = true
         widthConstraint.isActive = true
         
         self.navigationItem.rightBarButtonItems = [calendarBarButton,notificationBarButton]
         */
    }
    
    @objc func calendarBarButtonPressed(){
        
    }
    
    @objc func doneBarButtonPressed(){
        print("Done button pressed")
        
        self.hideKeyBoard()
        
        if self.picChange == true{
            
            startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))
            let uploadImage = self.profileImage.image?.compressImage(newSizeWidth: 512, newSizeHeight: 512, compressionQuality: 1.0)
            
            WebService().uploadProfilePic(image: uploadImage, complete: { (returnedDict) in
                
                if returnedDict.value(forKey: "Error") as? Bool == true {
                    self.stopAnimating()
                    self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                    
                }else{
                    
                    print(returnedDict)
                    let eventPictureUrl = (returnedDict["data"] as! NSDictionary)["photo"] as? String
                    
                    self.picChange = false
                    WebService().updateProfile(email: self.emailTF.text!, name: self.nameTF.text!, gender: self.genderTF.text!, photoUrl: eventPictureUrl!, complete: { (returnedDict) in
                        self.stopAnimating()
                        if returnedDict.value(forKey: "Error") as? Bool == true {
                            self.showAlert(title: "Eror", message: (returnedDict["ErrorMsg"] as? String)!)
                            
                        }else{
                            
                            
                            
                            appDelegate?.profileImageSet(image: uploadImage!)
                            self.profileImageUser = uploadImage!
                            self.setUpNavBar()
                            setting.setValue(self.nameTF.text!, forKey: "name")
                            setting.setValue(self.emailTF.text!, forKey: "email")
                            setting.setValue(self.genderTF.text!, forKey: "gender")
                            setting.setValue(eventPictureUrl, forKey: "photo")
                            
                            let alertController = UIAlertController(title: "Success", message: "Profile Updated", preferredStyle: UIAlertControllerStyle.alert)
                            
                            let okAction = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
                                print ("Ok")
                                self.navigationController?.popViewController(animated: true)
                            }
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
                            

                        }
                        
                    })
                }
            })
            
        }else{
            
            startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))
            
            WebService().updateProfile(email: self.emailTF.text!, name: self.nameTF.text!, gender: genderTF.text!, photoUrl: "", complete: { (returnedDict) in
                self.stopAnimating()
                if returnedDict.value(forKey: "Error") as? Bool == true {
                    self.showAlert(title: "Eror", message: (returnedDict["ErrorMsg"] as? String)!)
                    
                    
                }else{
                    
                    let alertController = UIAlertController(title: "Success", message: "Profile Updated", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let okAction = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
                        print ("Ok")
                        self.navigationController?.popViewController(animated: true)
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                    setting.setValue(self.nameTF.text!, forKey: "name")
                    setting.setValue(self.emailTF.text!, forKey: "email")
                    setting.setValue(self.genderTF.text!, forKey: "gender")
                }
                
            })
        }
        
    }
    
    @objc func profileButtonPressed(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

  @IBAction  func chooseGender(){
        self.hideKeyBoard()
        let actionSheetController = UIAlertController(title: "Gender", message: nil, preferredStyle: .actionSheet)
        
        let maleButton = UIAlertAction(title: "Male", style: .default) { action -> Void in
           self.genderTF.text = "Male"
        }
        actionSheetController.addAction(maleButton)
        
        let femaleButton = UIAlertAction(title: "Female", style: .default) { action -> Void in
            print("choose")
           self.genderTF.text = "Female"
        }
        actionSheetController.addAction(femaleButton)
    
        let transButton = UIAlertAction(title: "Trans", style: .default) { action -> Void in
        print("choose")
        self.genderTF.text = "Trans"
        }
        actionSheetController.addAction(transButton)
    
        let othersButton = UIAlertAction(title: "Other", style: .default) { action -> Void in
        print("choose")
        self.genderTF.text = "Other"
        }
        actionSheetController.addAction(othersButton)
    
        
        let deleteActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            print("Cancel")
            
        }
        actionSheetController.addAction(deleteActionButton)
        self.present(actionSheetController, animated: true, completion: nil)
    }
}

extension ProfileViewController : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
         if textField == emailTF{
            self.backViewBottomConstraint.constant = 250
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTF {
            self.backViewBottomConstraint.constant = 174
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
        
    }
}




