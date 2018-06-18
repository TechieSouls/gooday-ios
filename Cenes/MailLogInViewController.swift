//
//  MailLogInViewController.swift
//  Cenes
//
//  Created by Sabita Rani Samal on 7/18/17.
//  Copyright © 2017 Sabita Rani Samal. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FacebookCore
import FBSDKLoginKit
import NVActivityIndicatorView

class MailLogInViewController: UIViewController,NVActivityIndicatorViewable {
    
    @IBOutlet weak var user: UITextField!
    @IBOutlet weak var password: UITextField!
    var isMailId = false
    
    @IBOutlet weak var fbLoginBtnPlaceholder: UIButton!
    var fbLoginBtn : FBSDKLoginButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        user.delegate = self
        password.delegate = self
        
        // start here
        //cusom uielements
        let buttonText = NSAttributedString(string: "LOGIN WITH FACEBOOK")
        fbLoginBtn = FBSDKLoginButton(frame:fbLoginBtnPlaceholder.frame)
        fbLoginBtn.setAttributedTitle(buttonText, for: .normal)
        fbLoginBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        fbLoginBtn.setImage(nil, for: UIControlState.normal)
        fbLoginBtn.setBackgroundImage(nil, for: .normal)
        fbLoginBtn.backgroundColor = UIColor.clear
        fbLoginBtnPlaceholder.addSubview(fbLoginBtn)
        
        fbLoginBtn.readPermissions = ["public_profile", "email", "user_friends","user_events"];
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
        startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))
        // new hud
        
        webServ.emailSignIn(email: user.text!, password: password.text!, complete: { (returnedDict) in
            
          
            
            if returnedDict.value(forKey: "Error") as? Bool == true {
                 self.stopAnimating()
                self.alertMessage(message: (returnedDict["ErrorMsg"] as? String)!)
                
            }else{
            
                setting.setValue(2, forKey: "onboarding")
                
                self.stopAnimating()
                
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

extension MailLogInViewController : FBSDKLoginButtonDelegate {
    ///FBSDKLoginButtonDelegate method implimentation
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        guard (error == nil) else {return}
        
        if ((FBSDKAccessToken.current()) != nil) {
            // User is logged in, do work such as go to next view controller.
            getFBUserInfo()
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    func getFBUserInfo() {
        startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))

        let request = GraphRequest(graphPath: "me", parameters: ["fields":"id,name,email,gender,picture.type(large)"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: FacebookCore.GraphAPIVersion.defaultVersion)
        request.start { (response, result) in
            switch result {
            case .success(let value):
                let dictValue = value.dictionaryValue
                let tokenStr = FBSDKAccessToken.current().tokenString
                imageFacebookURL = ((dictValue?["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String
                let webServ = WebService()
                webServ.facebookSignUp(facebookAuthToken:tokenStr!, facebookID: dictValue?["id"]! as! String , complete: { (returnedDict) in
                    
                    
                    
                    
                    if returnedDict.value(forKey: "Error") as? Bool == true {
                        self.stopAnimating()
                        self.alertMessage(message: (returnedDict["ErrorMsg"] as? String)!)
                        
                    }
                    else{
                    
                    setting.setValue(2, forKey: "onboarding")
                    
                    webServ.facebookEvent(facebookAuthToken: tokenStr!,cenesToken: setting.value(forKey: "token") as! String, facebookID: dictValue?["id"]! as! String, complete: { (returnedDict) in
                        
                        
                        if returnedDict.value(forKey: "Error") as? Bool == true {
                            
                            self.alertMessage(message: (returnedDict["ErrorMsg"] as? String)!)
                            
                            }
                        
                        })
                    
                        let dict = returnedDict.value(forKey: "data") as? NSDictionary
                        
                        let isNew = dict?.value(forKey: "isNew") as? Bool
                        
                        if isNew != nil {
                            
                            self.stopAnimating()
                            
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
                    
                })
                
            case .failed(let error):
                print(error)
                self.stopAnimating()
            }
        }
    }
    
}
