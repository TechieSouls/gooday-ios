//
//  LoginViewController.swift
//  Cenes
//
//  Created by Sabita Rani Samal on 7/5/17.
//  Copyright © 2017 Sabita Rani Samal. All rights reserved.
//


import UIKit
import FBSDKLoginKit
import FacebookCore
import NVActivityIndicatorView

class LoginViewController: UIViewController,NVActivityIndicatorViewable {
   
    @IBOutlet weak var fbLoginBtnPlaceholder: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
//    @IBOutlet weak var accountAskLabel: UILabel!
    @IBOutlet weak var emailBtn: UIButton!
    //    @IBOutlet weak var displayLabele: UILabel!
    
    var fbLoginBtn : FBSDKLoginButton!
    
    class func MainViewController() -> UINavigationController{
        
         return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "nav") as! UINavigationController
        
    }
    
    
    override func viewWillLayoutSubviews() {
        fbLoginBtn.frame = self.fbLoginBtnPlaceholder.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // start here
        //cusom uielements
        
        fbLoginBtnPlaceholder.layer.cornerRadius = 12
        fbLoginBtnPlaceholder.layer.borderWidth = 1.5
        fbLoginBtnPlaceholder.layer.borderColor = UIColor.white.cgColor
        
        
        emailBtn.layer.cornerRadius = 12
        emailBtn.layer.borderWidth = 1.5
        emailBtn.layer.borderColor = UIColor.white.cgColor
        
        loginBtn.layer.cornerRadius = 12
        loginBtn.layer.borderWidth = 1.5
        loginBtn.layer.borderColor = UIColor.white.cgColor
        
        let buttonText = NSAttributedString(string: "Join us with Facebook")
        fbLoginBtn = FBSDKLoginButton(frame:fbLoginBtnPlaceholder.frame)
        fbLoginBtn.setAttributedTitle(buttonText, for: .normal)
        fbLoginBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        fbLoginBtn.setImage(nil, for: UIControlState.normal)
        fbLoginBtn.setBackgroundImage(nil, for: .normal)
        fbLoginBtn.backgroundColor = UIColor.clear
        fbLoginBtnPlaceholder.addSubview(fbLoginBtn)
        fbLoginBtn.readPermissions = ["public_profile", "email", "user_friends","user_events"];
        fbLoginBtn.delegate = self

//        accountAskLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
//        accountAskLabel.numberOfLines = 0
//        loginBtn.backgroundColor = .clear
     
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
             // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
 
}

extension LoginViewController : FBSDKLoginButtonDelegate {
    ///FBSDKLoginButtonDelegate method implimentation
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        guard (error == nil) else {return}
        
        if ((FBSDKAccessToken.current()) != nil) {
            // User is logged in, do work such as go to next view controller.
            getFBUserInfo()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    func getFBUserInfo() {
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
                        self.showAlert(title: "Error", message:(returnedDict["ErrorMsg"] as? String)!)
                        
                    }
                    else{
                        
                        
                        setting.setValue(2, forKey: "onboarding")
                        
                        
                        webServ.facebookEvent(facebookAuthToken: tokenStr!,cenesToken: setting.value(forKey: "token") as! String, facebookID: dictValue?["id"]! as! String, complete: { (returnedDict) in
                            
                            if returnedDict.value(forKey: "Error") as? Bool == true {
                                
                                self.showAlert(title: "Error", message:(returnedDict["ErrorMsg"] as? String)!)
                                
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
                break
            case .failed(let error):
                print(error)
                self.stopAnimating()
            }
        }
    }
    
}


