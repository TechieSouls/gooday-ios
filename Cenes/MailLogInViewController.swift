//
//  MailLogInViewController.swift
//  Cenes
//
//  Created by Sabita Rani Samal on 7/18/17.
//  Copyright © 2017 Sabita Rani Samal. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import NVActivityIndicatorView
import Alamofire

class MailLogInViewController: UIViewController,NVActivityIndicatorViewable {
    
    @IBOutlet weak var user: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var isMailId = false
    var nactvityIndicatorView = NVActivityIndicatorView.init(frame: cgRectSizeLoading, type: NVActivityIndicatorType.lineScaleParty, color: UIColor.white, padding: 0.0);
    
    @IBOutlet weak var fbLoginBtnPlaceholder: UIButton!
    var fbLoginBtn : FBLoginButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        user.delegate = self
        password.delegate = self
        
        // start here
        //cusom uielements
        let buttonText = NSAttributedString(string: "LOGIN WITH FACEBOOK")
        fbLoginBtn = FBLoginButton(frame:fbLoginBtnPlaceholder.frame)
        fbLoginBtn.setAttributedTitle(buttonText, for: .normal)
        fbLoginBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        fbLoginBtn.setImage(nil, for: UIControlState.normal)
        fbLoginBtn.setBackgroundImage(nil, for: .normal)
        fbLoginBtn.backgroundColor = UIColor.clear
        fbLoginBtnPlaceholder.addSubview(fbLoginBtn)
        
        fbLoginBtn.permissions = ["public_profile", "email", "user_friends","user_events"];
        fbLoginBtn.delegate = self
        configureTextField(withImage: #imageLiteral(resourceName: "loginusername"), textfield: user)
        configureTextField(withImage: #imageLiteral(resourceName: "loginPasswords"), textfield: password)
        
        
    }
    
    override func viewWillLayoutSubviews() {
        fbLoginBtn.frame = self.fbLoginBtnPlaceholder.bounds
    }
    
    private func configureTextField(withImage: UIImage, textfield: UITextField) {
        let imageView = UIImageView.init(image: withImage)
        imageView.frame = CGRect(x: 5, y: 0, width: 60, height: 40)
        imageView.contentMode = .center
        
        textfield.leftView = imageView
        textfield.leftViewMode = .always
        
        //textfield.backgroundColor = UIColor.white
    }
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        
        self.user.resignFirstResponder()
        self.password.resignFirstResponder()
        
        guard Util.isnameLenth(name: user.text!)else{
            
            user.backgroundColor =  commonColor
            
            alertMessage(message: "Name is empty")
            
            return
        }
        
        if Util.isValidEmail(testStr: user.text!){
            
            isMailId = true
        }
        
        guard Util.isPwdLenth(password: password.text!)else{
            
            password.backgroundColor =  commonColor
            alertMessage(message: "password should be greater than 5")
            
            return
        }
        
        let webServ = WebService()
        
        
        startAnimating(loadinIndicatorSize, message: "Loading...", type: self.nactvityIndicatorView.type)
        // new hud
        
        webServ.emailSignIn(email: user.text!, password: password.text!, complete: { (returnedDict) in
            
          
             self.stopAnimating()
            if returnedDict.value(forKey: "Error") as? Bool == true {
                self.alertMessage(message: (returnedDict["ErrorMsg"] as? String)!)
                
            }else{
                
                WebService().setPushToken();
                
                let refreshAlert = UIAlertController(title: "Sync Contacts", message: "Would you like to sync contacts.", preferredStyle: UIAlertControllerStyle.alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                    //print("Handle Ok logic here")
                    self.startAnimating(loadinIndicatorSize, message: "Loading...", type: self.nactvityIndicatorView.type)
                    
                    UserService().syncDevicePhoneNumbers( complete: { (returnedDict) in
                        
                        self.stopAnimating()
                        
                        self.moveToOnbaordingOnEmailLogin();

                    });
                }))
                
                refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                    //print("Handle Cancel Logic here")
                    
                    self.moveToOnbaordingOnEmailLogin()
                }))
                self.present(refreshAlert, animated: true, completion: nil)
            }
        })
    }
    
    func alertMessage (message :String)
    {
        let alertController = UIAlertController(title: "Validation", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
            print ("Ok")
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
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
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        print("Inside Forgot Password")
    }
}
extension MailLogInViewController: UITextFieldDelegate{
    
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

extension MailLogInViewController : LoginButtonDelegate {
    ///FBSDKLoginButtonDelegate method implimentation
    
    func loginButton(_ loginButton: FBLoginButton!, didCompleteWith result: LoginManagerLoginResult!, error: Error!) {
        
        guard (error == nil) else {return}
        
        if ((AccessToken.current) != nil) {
            // User is logged in, do work such as go to next view controller.
            getFBUserInfo()
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton!) {
        
    }
    
    func getFBUserInfo() {
        startAnimating(loadinIndicatorSize, message: "Loading...", type: self.nactvityIndicatorView.type)

        let request = GraphRequest(graphPath: "me", parameters: ["fields":"id,name,email,gender,picture.type(large)"]);
        request.start(completionHandler: { (connection, result, error) -> Void in
            
            if ((error) != nil) {
                print(error)
                self.stopAnimating()

            } else {
                let dictValue = result as! [String: Any];
                let tokenStr = AccessToken.current!.tokenString
                imageFacebookURL = ((dictValue["picture"] as! [String: Any])["data"] as! [String: Any])["url"] as! String;
                let webServ = WebService()
                webServ.facebookSignUp(facebookAuthToken:tokenStr, facebookID: dictValue["id"]! as! String , complete: { (returnedDict) in
                    
                    self.stopAnimating()

                    if returnedDict.value(forKey: "Error") as? Bool == true {
                        self.alertMessage(message: (returnedDict["ErrorMsg"] as? String)!)
                    } else{
                    
                        let refreshAlert = UIAlertController(title: "Sync Contacts", message: "Would you like to sync contacts.", preferredStyle: UIAlertControllerStyle.alert)
                        
                        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                            //print("Handle Ok logic here")
                            
                            self.startAnimating(loadinIndicatorSize, message: "Loading...", type: self.nactvityIndicatorView.type)

                            UserService().syncDevicePhoneNumbers( complete: { (returnedDict) in
                                
                                self.stopAnimating()
                                
                                //self.moveToBoardingStepsOnFbLogin(webServ: webServ,returnedDict: returnedDict,tokenStr: tokenStr!,dictValue :dictValue!)
                            });
                            
                           
                        }))
                        
                        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                            //print("Handle Cancel Logic here")
                            
                            //self.moveToBoardingStepsOnFbLogin(webServ: webServ,returnedDict: returnedDict,tokenStr: tokenStr!,dictValue :dictValue!)
                        }))
                        self.present(refreshAlert, animated: true, completion: nil)
                    }
                    
                })
            }
        });
    }
    
    func moveToBoardingStepsOnFbLogin(webServ: WebService,returnedDict: NSMutableDictionary,tokenStr: String,dictValue :[String: Any]) {
        setting.setValue(2, forKey: "onboarding")
        
        webServ.facebookEvent(facebookAuthToken: tokenStr,cenesToken: setting.value(forKey: "token") as! String, facebookID: dictValue["id"]! as! String, complete: { (returnedDict) in
            
            
            if returnedDict.value(forKey: "Error") as? Bool == true {
                
                self.alertMessage(message: (returnedDict["ErrorMsg"] as? String)!)
                
            }
            
        })
        
        let dict = returnedDict.value(forKey: "data") as? NSDictionary
        
        let isNew = dict?.value(forKey: "isNew") as? Bool
        
        if isNew != nil {
            
            DispatchQueue.main.async {
                UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController()
                WebService().setPushToken()
            }
            
            let url = dict?.value(forKey: "photo") as? String
            if url != nil && url != "" {
                if url != nil && url != "" {
                    let webServ = WebService()
                    webServ.profilePicFromFacebook(url: url!, completion: { image in
                        DispatchQueue.main.async {
                            print("Image Downloaded")
                            appDelegate?.profileImageSet(image: image!)
                            appDelegate?.cenesTabBar?.loadViewIfNeeded()
                            let index = appDelegate?.cenesTabBar?.selectedIndex
                            let navController = appDelegate?.cenesTabBar?.viewControllers?[index!] as! UINavigationController
                            navController.viewControllers.first?.viewDidLayoutSubviews()
                        }
                    })
                }
            }
        }else{
            self.stopAnimating()
            let camera = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "onbooardingNavigation") as? UINavigationController
            UIApplication.shared.keyWindow?.rootViewController = camera
        }
    }
    
    func moveToOnbaordingOnEmailLogin() {
        setting.setValue(2, forKey: "onboarding")
        
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController()
            WebService().setPushToken()
        }
        
        
        
        let url = setting.value(forKey:"photo") as? String
        
        if url != nil && url != "" {
            let webServ = WebService()
            webServ.profilePicFromFacebook(url: url!, completion: { image in
                DispatchQueue.main.async {
                    print("Image Downloaded")
                    appDelegate?.profileImageSet(image: image!)
                    appDelegate?.cenesTabBar?.loadViewIfNeeded()
                    let index = appDelegate?.cenesTabBar?.selectedIndex
                    let navController = appDelegate?.cenesTabBar?.viewControllers?[index!] as! UINavigationController
                    navController.viewControllers.first?.viewDidLayoutSubviews()
                }
            })
        }
    }
    
}
