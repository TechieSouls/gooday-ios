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
    @IBOutlet weak var accountAskLabel: UILabel!
    @IBOutlet weak var displayLabele: UILabel!
    
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
        let buttonText = NSAttributedString(string: "JOIN US WITH FACEBOOK")
        fbLoginBtn = FBSDKLoginButton(frame:fbLoginBtnPlaceholder.frame)
        fbLoginBtn.setAttributedTitle(buttonText, for: .normal)
        fbLoginBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        fbLoginBtn.setImage(nil, for: UIControlState.normal)
        fbLoginBtn.setBackgroundImage(nil, for: .normal)
        fbLoginBtn.backgroundColor = UIColor.clear
        fbLoginBtnPlaceholder.addSubview(fbLoginBtn)
        fbLoginBtn.readPermissions = ["public_profile", "email", "user_friends","user_events"];
        fbLoginBtn.delegate = self

        accountAskLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        accountAskLabel.numberOfLines = 0
        loginBtn.backgroundColor = .clear
        loginBtn.layer.cornerRadius = 5
        loginBtn.layer.borderWidth = 1
        loginBtn.layer.borderColor = UIColor.lightGray.cgColor
        
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
        let request = GraphRequest(graphPath: "me", parameters: ["fields":"id,name,email,picture.type(large)"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: FacebookCore.GraphAPIVersion.defaultVersion)
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
                        
                        self.stopAnimating()
                        setting.setValue(2, forKey: "onboarding")
                        
                        webServ.facebookEvent(facebookAuthToken: tokenStr!,cenesToken: setting.value(forKey: "token") as! String, facebookID: dictValue?["id"]! as! String, complete: { (returnedDict) in
                            
                            if returnedDict.value(forKey: "Error") as? Bool == true {
                                
                                self.showAlert(title: "Error", message:(returnedDict["ErrorMsg"] as? String)!)
                                
                            }
                            
                        })
                        
                        let camera = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "onbooardingNavigation") as? UINavigationController
                        UIApplication.shared.keyWindow?.rootViewController = camera
                    }
                    
                })
                
            case .failed(let error):
                print(error)
                self.stopAnimating()
            }
        }
    }
    
}


