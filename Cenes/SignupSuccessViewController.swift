//
//  SignupSuccessViewController.swift
//  Cenes
//
//  Created by Macbook on 30/09/18.
//  Copyright © 2018 Cenes Pvt Ltd. All rights reserved.
//

import UIKit
import MobileCoreServices
import NVActivityIndicatorView
import FacebookCore
import FBSDKLoginKit
import FacebookLogin

class SignupSuccessViewController: UIViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NVActivityIndicatorViewable, UITextFieldDelegate  {

    
    @IBOutlet weak var textFieldName: UITextField!
    
    @IBOutlet weak var textFieldEmail: UITextField!
    
    @IBOutlet weak var textFieldPassword: UITextField!
    
    @IBOutlet weak var chooseProfilePhoto: UIImageView!
    
    var phoneNumber = "";
    let picController = UIImagePickerController()
    let userService = UserService();
    var photoUploaded: Bool = false;
    var fbLoginBtn : FBSDKLoginButton!;
    var pImage : UIImage!
    var facebookPictureUrl: String? = nil;

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))

        chooseProfilePhoto.isUserInteractionEnabled = true;
        chooseProfilePhoto.addGestureRecognizer(imageTapGesture);
        // Do any additional setup after loading the view.
        
        /*fbLoginBtn.readPermissions = ["public_profile", "email", "user_friends","user_events", "user_mobile_phone"];
        fbLoginBtn.delegate = self*/
        
        textFieldName.delegate = self;
        textFieldEmail.delegate = self;
        textFieldPassword.delegate = self;
        
        textFieldName.setBottomBorder();
        textFieldEmail.setBottomBorder();
        textFieldPassword.setBottomBorder();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onClickNextStepButton(_ sender: Any) {
        if (isFormValid()) {
            signupUser();
        }
    }
    
    @IBAction func onClickSyncWithFacebookButton(_ sender: Any) {
        
       /* let loginManager = LoginManager()
        loginManager.logIn(["public_profile", "email", "user_friends","user_events", "user_mobile_phone"], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in!")
            }
        } */
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                // if user cancel the login
                if (result?.isCancelled)!{
                    return
                }
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    if((FBSDKAccessToken.current()) != nil){
                        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                            if (error == nil){
                                //everything works print the user data
                                let fbDetails = result as! NSDictionary
                                self.textFieldName.text = fbDetails.value(forKey: "name") as? String;
                                self.textFieldEmail.text = fbDetails.value(forKey: "email") as? String;
                                
                                if let imageURL = ((fbDetails["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                                    print(imageURL)
                                    let url = URL(string: imageURL)
                                    let data = NSData(contentsOf: url!)
                                    let image = UIImage(data: data! as Data)
                                    self.chooseProfilePhoto.image = image
                                    self.facebookPictureUrl = imageURL;
                                }
                            }
                        })
                    }
                }
            }
        }
        
    }

    @objc func imageTapped() {
        // Create the AlertController and add its actions like button in ActionSheet
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)
        
        let saveActionButton = UIAlertAction(title: "Take Picture", style: .default) { action -> Void in
                self.takePicture()
            
        }
        actionSheetController.addAction(saveActionButton)
        
        let deleteActionButton = UIAlertAction(title: "Choose From Gallery", style: .default) { action -> Void in
            self.selectPicture()
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
            self.pImage = image;
            self.chooseProfilePhoto.image = image
            self.photoUploaded = true;
        }
        
        picker.dismiss(animated: true, completion: nil);
    }

    func signupUser() {
        
        startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))
        
        var postSignupData: [String: String] = [:];
        postSignupData["email"] = textFieldEmail.text!;
        postSignupData["name"] = textFieldName.text!;
        postSignupData["password"] = textFieldPassword.text!;
        postSignupData["phone"] = self.phoneNumber;
        if (self.facebookPictureUrl != nil) {
            postSignupData["picture"] = self.facebookPictureUrl;
        }
        userService.emailSignUp(postSignupData: postSignupData, complete: { (returnedDict) in
            
            self.stopAnimating()
            
            if returnedDict.value(forKey: "Error") as? Bool == true {
                self.alertMessage(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
            } else {
                WebService().setPushToken();
                
                if (self.photoUploaded == true) {
                    self.uploadImage();
                } else {
                    self.syncDeviceContacts();
                }
            }
        });
    }
    
    func uploadImage() {
        startAnimating(loadinIndicatorSize, message: "Uploading...", type: NVActivityIndicatorType(rawValue: 15))
        let uploadImage = self.chooseProfilePhoto.image?.compressImage(newSizeWidth: 512, newSizeHeight: 512, compressionQuality: 1.0)
        
        WebService().uploadProfilePic(image: uploadImage, complete: {       (returnedDict) in
            
            self.stopAnimating();
            
            if returnedDict.value(forKey: "Error") as? Bool == true {
                self.stopAnimating()
                self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                
            }else{
                let eventPictureUrl = (returnedDict["data"] as! NSDictionary)["photo"] as? String
                
                self.syncDeviceContacts();
            }
        });
    }
    
    func syncDeviceContacts() {
        self.startAnimating(loadinIndicatorSize, message: "Syncing Contacts...", type: NVActivityIndicatorType(rawValue: 15))
        
        UserService().syncDevicePhoneNumbers( complete: { (returnedDict) in
            
            self.stopAnimating()
            setting.setValue(2, forKey: "onboarding")
            let camera = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "onbooardingNavigation") as? UINavigationController
            UIApplication.shared.keyWindow?.rootViewController = camera
        });
    }
    
    func isFormValid() -> Bool {
        guard Util.isnameLenth(name: textFieldName.text!)else{
            
            textFieldName.backgroundColor =  commonColor
            
            alertMessage(title: "Validation",message: "Name is empty")
            
            return false;
        }
        
        guard Util.isValidEmail(testStr: textFieldEmail.text!)else{
            
            textFieldEmail.backgroundColor =  commonColor
            
            alertMessage(title: "Validation",message: "Email is not valid")
            
            return false;
        }
        
        guard Util.isPwdLenth(password: textFieldPassword.text!)else{
            
            textFieldPassword.backgroundColor =  commonColor
            
            alertMessage(title: "Validation",message: "Password should be greater than 3")
            
            return false;
        }
        return true;
    }
    
    func alertMessage (title: String, message :String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
            print ("Ok")
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.backgroundColor = UIColor.clear
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.resignFirstResponder()
    }
    
}

extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
