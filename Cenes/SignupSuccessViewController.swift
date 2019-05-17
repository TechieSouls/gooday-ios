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

    
    @IBOutlet weak var topRoundedView: UIView!
    @IBOutlet weak var textFieldName: UITextField!
    
    @IBOutlet weak var textFieldEmail: UITextField!
    
    @IBOutlet weak var textFieldPassword: UITextField!
    
    @IBOutlet weak var textFieldConfirmPassword: UITextField!
    
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    @IBOutlet weak var chooseProfilePhoto: UIImageView!
    @IBOutlet weak var backButton: UIImageView!

    @IBOutlet weak var signupButton: UIButton!
    
    
    var user = User();
    var phoneNumber = "";
    let picController = UIImagePickerController()
    let userService = UserService();
    var photoUploaded: Bool = false;
    var fbLoginBtn : FBSDKLoginButton!;
    var pImage : UIImage!
    var facebookPictureUrl: String? = nil;
    var nactvityIndicatorView = NVActivityIndicatorView.init(frame: cgRectSizeLoading, type: NVActivityIndicatorType.lineScaleParty, color: UIColor.white, padding: 0.0);
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))

        //chooseProfilePhoto.isUserInteractionEnabled = true;
        //chooseProfilePhoto.addGestureRecognizer(imageTapGesture);
        // Do any additional setup after loading the view.
        
        /*fbLoginBtn.readPermissions = ["public_profile", "email", "user_friends","user_events", "user_mobile_phone"];
        fbLoginBtn.delegate = self*/
        topRoundedView.roundedView();
        
        let emailGradient = CAGradientLayer()
        emailGradient.frame = CGRect.init(0, textFieldEmail.frame.height-1, textFieldEmail.frame.width, 1)
        emailGradient.colors = [UIColor.white.cgColor, UIColor(red:0.78, green:0.42, blue:0.74, alpha:0.75).cgColor, UIColor.white.cgColor]
        emailGradient.startPoint = CGPoint(x: 0, y: 1);
        emailGradient.endPoint = CGPoint(x: 1, y: 1);
        
        textFieldEmail.layer.insertSublayer(emailGradient, at: 0);
        
        let passwordGradient = CAGradientLayer()
        passwordGradient.frame = CGRect.init(0, textFieldPassword.frame.height-1, textFieldPassword.frame.width, 1)
        passwordGradient.colors = [UIColor.white.cgColor, UIColor(red:0.78, green:0.42, blue:0.74, alpha:0.75).cgColor, UIColor.white.cgColor]
        passwordGradient.startPoint = CGPoint(x: 0, y: 1);
        passwordGradient.endPoint = CGPoint(x: 1, y: 1);
        
        textFieldPassword.layer.insertSublayer(passwordGradient, at: 0);
        
        
        let confirmGradient = CAGradientLayer()
        confirmGradient.frame = CGRect.init(0, textFieldConfirmPassword.frame.height-1, textFieldConfirmPassword.frame.width, 1)
        confirmGradient.colors = [UIColor.white.cgColor, UIColor(red:0.78, green:0.42, blue:0.74, alpha:0.75).cgColor, UIColor.white.cgColor]
        confirmGradient.startPoint = CGPoint(x: 0, y: 1);
        confirmGradient.endPoint = CGPoint(x: 1, y: 1);
        
        textFieldConfirmPassword.layer.insertSublayer(confirmGradient, at: 0);
        
        let backTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(backButtonPressed));
        backButton.addGestureRecognizer(backTapGesture);
        
        textFieldPassword.isEnabled = false;
        textFieldConfirmPassword.isEnabled = false;
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

    
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        
        
        if (textFieldEmail.text != nil && isValidEmail(testStr: textFieldEmail.text!)) {
            var postData = [String: Any]();
            postData["email"] = textFieldEmail.text!;
            postData["password"] = textFieldPassword.text!
            
            UserService().emailSignupRequest(postData: postData, complete: {(response) in
                print(response);
                
                let success = response.value(forKey: "success") as! Bool;
                
                if (success == false) {
                    self.showAlert(title: "Error", message: response.value(forKey: "message") as! String);
                } else {
                    
                    let data = response.value(forKey: "data") as! NSDictionary;
                    
                    setting.setValue(data.object(forKey: "userId"), forKey: "userId")
                    setting.setValue(data.object(forKey: "token"), forKey: "token")
                    setting.setValue(data.object(forKey: "email"), forKey: "email")
                    setting.setValue(data.object(forKey: "password"), forKey: "password")

                    
                    //Registering Device Token
                    DispatchQueue.global(qos: .background).async {
                        WebService().setPushToken();
                    }
                    
                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SignupSuccessStep2ViewController") as! SignupSuccessStep2ViewController;
                    self.navigationController?.pushViewController(viewController, animated: true);
                }
            });
        } else {
            if (textFieldEmail.text != nil && !isValidEmail(testStr: textFieldEmail.text!)) {
                self.showAlert(title: "Error", message: "Invalid Email Format")
            }
        }
    }
    
    @IBAction func loginButtinPressed(_ sender: Any) {
        let sininViewController = storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        self.navigationController?.pushViewController(sininViewController, animated: true)
        
    }
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
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true);
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
        
        startAnimating(loadinIndicatorSize, message: "Loading...", type: self.nactvityIndicatorView.type)
        
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
        startAnimating(loadinIndicatorSize, message: "Uploading...", type: self.nactvityIndicatorView.type)
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
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

    
    func syncDeviceContacts() {
        self.startAnimating(loadinIndicatorSize, message: "Syncing Contacts...", type: self.nactvityIndicatorView.type)
        
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
        
        if (textField == textFieldEmail) {
            
            if (textFieldEmail.text != "") {
                
                user.email = textFieldEmail.text!;
                
                let queryStr = "email=\(textFieldEmail.text!)";
                UserService().findUserByEmail(queryStr: queryStr, token: "", complete: {(response) in
                    
                    let success = response.value(forKey: "success") as! Bool;
                    if (success == false) {
                        //self.showAlert(title: "Already Exists", message: "");
                        
                        let escapedString = self.textFieldEmail.text!.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)

                        var message = "We found an account for";
                        message = message + "\n\(escapedString!). Would you";
                        message = message + "\nlike to login instead?";
                        
                        let alertController = UIAlertController(title: "This Account Already Exists", message: message, preferredStyle: UIAlertControllerStyle.alert);
                        
                        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (UIAlertAction) in
                            print ("Cancel")
                        }
                        let loginAction = UIAlertAction(title: "Login", style: .default) { (UIAlertAction) in
                            print ("Login");
                            let sininViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
                            sininViewController.existingEmail = self.textFieldEmail.text!;
                            self.navigationController?.pushViewController(sininViewController, animated: true)
                        }
                        alertController.addAction(cancelAction)
                        alertController.addAction(loginAction)
                        self.present(alertController, animated: true, completion: nil)
                        
                        
                    } else {
                        self.textFieldPassword.isEnabled = true;
                        self.textFieldPassword.becomeFirstResponder();
                    }
                });
            } else {
                textFieldPassword.becomeFirstResponder();
            }
            
        } else if (textField == textFieldPassword) {
            self.textFieldConfirmPassword.isEnabled = true;
            textFieldConfirmPassword.becomeFirstResponder();
        } else if (textField == textFieldConfirmPassword) {
            
            if (textFieldPassword.text == "") {
                showAlert(title: "Password Empty", message: "");
            } else if (textFieldPassword.text != textFieldConfirmPassword.text) {
                showAlert(title: "Password Don't Match", message: "");
            } else {
                
                user.password = textFieldPassword.text!;
                textFieldConfirmPassword.resignFirstResponder()
            }
        }
        return true;
    }
    
}
