//
//  ChoiceViewController.swift
//  Cenes
//
//  Created by Macbook on 15/09/18.
//  Copyright © 2018 Cenes Pvt Ltd. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import Mixpanel

class ChoiceViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInDelegate, GIDSignInUIDelegate {
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("Done");
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Done")
    }
    

    @IBOutlet weak var signupMobileBtn: UIButton!
    
    @IBOutlet weak var firstViewContainer: UIView!
    
    @IBOutlet weak var secondViewContainer: UIView!
    
    
    @IBOutlet weak var threeButtonsView: UIView!
    
    @IBOutlet weak var facebookViewBtn: UIView!
    
    @IBOutlet weak var googleViewBtn: UIView!
    
    @IBOutlet weak var emailViewBtn: UIView!
    
    @IBOutlet weak var termsAndConditionsText: UILabel!

    var fbLoginBtn : FBSDKLoginButton!
    var signinType = "Facebook";
    
    class func MainViewController() -> UINavigationController{
        
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "nav") as! UINavigationController
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.firstViewContainer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height/2)
        //self.secondViewContainer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height/2)
        
        // Do any additional setup after loading the view.
        /*self.signupMobileBtn.layer.borderColor = UIColor.orange.cgColor
        self.signupMobileBtn.layer.borderWidth = 1
        self.signupMobileBtn.layer.cornerRadius = 20*/
        
        facebookViewBtn.roundedView();
        googleViewBtn.roundedView();
        emailViewBtn.roundedView();
        
        let threeButtonsViewGradient = CAGradientLayer()
        threeButtonsViewGradient.frame = CGRect.init(x: 0, y: 0, width: threeButtonsView.frame.width, height: 1)
        threeButtonsViewGradient.colors = [UIColor.white.cgColor, UIColor(red:0.29, green:0.56, blue:0.89, alpha:0.75).cgColor, UIColor(red:0.91, green:0.49, blue:0.48, alpha:0.75).cgColor, UIColor(red:0.78, green:0.42, blue:0.74, alpha:0.75).cgColor, UIColor.white.cgColor]
        threeButtonsViewGradient.startPoint = CGPoint(x: 0, y: 1);
        threeButtonsViewGradient.endPoint = CGPoint(x: 1, y: 1);
        
        threeButtonsView.layer.insertSublayer(threeButtonsViewGradient, at: 0);
        
        
        let facebookTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(facebookViewPressed));
        facebookViewBtn.addGestureRecognizer(facebookTapGesture);
        
        let googleTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(googleViewPressed));
        googleViewBtn.addGestureRecognizer(googleTapGesture);
        
        let emailTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(emailViewPressed));
        emailViewBtn.addGestureRecognizer(emailTapGesture);
        
        // Initialize Google sign-in
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().clientID = Util.GOOGLE_SERVER_ID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.login")
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.me")

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        //navigationController?.setNavigationBarHidden(true, animated: true)
        self.view.backgroundColor = themeColor;
        self.navigationController?.navigationBar.isHidden = true;
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 248.0/255.0, green: 159.0/255.0, blue: 30.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 142.0/255.0, green: 115.0/255.0, blue: 179.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        self.view.layer.addSublayer(gradientLayer)
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func facebookViewPressed() {
    
        fbLoginBtn = FBSDKLoginButton();
        fbLoginBtn.delegate = self;
        
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        loginManager.logIn(withReadPermissions: [ "public_profile" , "email"], from: nil) {
            (result, error) -> Void in
            //if we have an error display it and abort
            if let error = error {
                print(error.localizedDescription)
                return
            }
            //make sure we have a result, otherwise abort
            guard let result = result else { return }
            //if cancelled nothing todo
            if result.isCancelled { return }
            else {
                self.getFBUserData(facebookId: result.token.userID , accessToken: result.token.tokenString);
            }
        }
    }
    
    @objc func googleViewPressed() {
        //GIDSignIn.sharedInstance()?.signOut();
        GIDSignIn.sharedInstance()?.signIn();
    }
    
    @objc func emailViewPressed() {
        
        let viewController = storyboard?.instantiateViewController(withIdentifier: "SignupSuccessViewController") as! SignupSuccessViewController;
        self.navigationController?.pushViewController(viewController, animated: true);
    }
    
    

    //function is fetching the user data
    func getFBUserData(facebookId: String, accessToken: String) {
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "\(facebookId)", parameters: ["fields": "id, name, gender, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    print(result)
                    
                    var postData = [String: Any]();
                    postData["authType"] = "facebook";
                    postData["facebookId"] = facebookId;
                    postData["facebookAuthToken"] = facebookId;

                    let resultDic = result as! NSDictionary
                    
                    print("\n\n  fetched user: \(result)")
                    if (resultDic.value(forKey:"name") != nil) {
                        let userName = resultDic.value(forKey:"name") as! String;
                        postData["name"] = userName;
                    }
                    
                    var userEmailVar = "";
                    if (resultDic.value(forKey:"email") != nil) {
                        let userEmail = resultDic.value(forKey:"email") as! String;
                        postData["email"] = userEmail;
                        userEmailVar = userEmail;
                    }
                    
                    if (resultDic.value(forKey:"gender") != nil) {
                        let gender = resultDic.value(forKey:"gender") as! String;
                        postData["gender"] = gender.capitalized;
                    }
                    
                    if let profilePictureObj = resultDic.value(forKey: "picture") as? NSDictionary {
                        let data = profilePictureObj.value(forKey: "data") as! NSDictionary
                        let pictureUrlString  = data.value(forKey: "url") as! String
                        postData["photo"] = pictureUrlString;
                    }
                    if let phone = setting.value(forKey: "verifiedPhone") {
                        postData["phone"] = phone;
                    }
                
                    if let country = setting.value(forKey: "countryCode") {
                        postData["country"] = country;
                    }
                    
                    //Mixpanel for Facebook Sigup Begins
                    Mixpanel.mainInstance().track(event: "Signup",
                                                  properties:[ "SignupType" : "\(self.signinType)", "SignupBegins" : "True", "UserEmail": "\(userEmailVar)"]);
                    
                    
                    self.loginSocialRequest(postData: postData);
                }
            })
        }
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email

            
            var postData = [String: Any]();
            postData["authType"] = "google";
            postData["googleId"] = user.userID;
            postData["googleAuthToken"] = user.authentication.idToken;
            
            if (user.profile.name != nil) {
                postData["name"] = user.profile.name;
            }
            
            var emailVar = "";
            if (user.profile.email != nil) {
                postData["email"] = user.profile.email;
                emailVar = user.profile.email;
            }
            
            if (user.profile.hasImage == true) {
                let dimension = round(200 * UIScreen.main.scale)
                let pic = user.profile.imageURL(withDimension: UInt(dimension));
                let url = pic?.absoluteString;
                postData["photo"] = url;
            }
            if let phone = setting.value(forKey: "verifiedPhone") {
                postData["phone"] = phone;
            }
            
            if let country = setting.value(forKey: "countryCode") {
                postData["country"] = country;
            }
            self.signinType = "Google";
            //Mixpanel for Facebook Sigup Begins
            Mixpanel.mainInstance().track(event: "Signup",
                                          properties:[ "SignupType" : "\(self.signinType)", "Action":"Signup Begins", "UserEmail": "\(emailVar)"]);
            
            
            loginSocialRequest(postData: postData);
        }
    }
    
    func loginSocialRequest(postData: [String: Any]) {
        
        UserService().emailSignupRequest(postData: postData, complete: {(response) in
            
            let success = response.value(forKey: "success") as! Bool;
            if (success == true) {
                
                
                let loggedInUserDict = response.value(forKey: "data") as! NSDictionary;
                setting.setValue(loggedInUserDict.value(forKey: "name"), forKey: "name");
                setting.setValue(loggedInUserDict.value(forKey: "userId"), forKey: "userId");
                
                if let photo = loggedInUserDict.value(forKey: "photo") as? String {
                    setting.setValue(photo, forKey: "photo");
                }
                
                var emailVar = "";
                if loggedInUserDict.value(forKey: "email") as? String != nil {
                    setting.setValue(loggedInUserDict.value(forKey: "email"), forKey: "email");
                    emailVar = loggedInUserDict.value(forKey: "email") as! String;
                }
                
                if loggedInUserDict.value(forKey: "gender") as? String != nil {
                    setting.setValue(loggedInUserDict.value(forKey: "gender"), forKey: "gender");
                }
                
                if loggedInUserDict.value(forKey: "phone") as? String != nil {
                    setting.setValue(loggedInUserDict.value(forKey: "phone"), forKey: "phone");
                }
                setting.setValue(loggedInUserDict.value(forKey: "token"), forKey: "token");
                
                //Registering Device Token
                DispatchQueue.global(qos: .background).async {
                    WebService().setPushToken();
                }
                
                setting.setValue(UserSteps.Authentication, forKey: "footprints")

                //Mixpanel for Facebook Sigup Begins
                Mixpanel.mainInstance().track(event: "Signup",
                                              properties:[ "SignupType" : "Facebook", "Action":"Signup Success", "UserEmail": "\(emailVar)"]);
                
                let isNew = loggedInUserDict.value(forKey: "isNew") as! Bool;
                if (isNew == false) {
                    setting.setValue(loggedInUserDict.value(forKey: "dateOfBirthStr"), forKey: "dateOfBirthStr");
                    UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController()
                } else {
                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SignupSuccessStep2ViewController") as! SignupSuccessStep2ViewController;
                    self.navigationController?.pushViewController(viewController, animated: true);
                }
                
            } else {
                
                let message = response.value(forKey: "message") as! String;
                if (response.value(forKey: "errorCode") != nil) {
                    let errorCode = response.value(forKey: "errorCode") as! Int;
                    if (errorCode == 1001) {
                        
                        let phoneNumberToDisplay = "\(String((postData["phone"] as! String).prefix(4)))xxxx\((postData["phone"] as! String).suffix(3))";
                        
                        let alertBody = "Do you want to update your phone number to \(phoneNumberToDisplay) ??";
                        
                        let alertController = UIAlertController(title: message, message: alertBody, preferredStyle: UIAlertControllerStyle.alert)
                        
                        let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) { (UIAlertAction) in
                            print ("Ok")
                            
                            alertController.dismiss(animated: true, completion: nil);
                            
                            self.confirmAlert(postData: postData);
                        }
                        
                        
                        let noAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel) { (UIAlertAction) in
                            print ("No")
                        }
                        alertController.addAction(okAction)
                        alertController.addAction(noAction)
                        self.present(alertController, animated: true, completion: nil)

                    }
                } else {
                    self.showAlert(title: "Alert", message: message);
                }
            }
        });
    }
    
    func confirmAlert(postData: [String: Any]) {
        
        
        let emailToVerify = (postData["email"] as! String).split(separator: "@")[1];
        
        let emailPrefix = (postData["email"] as! String).split(separator: "@")[0];
        
        let prefixChars = emailPrefix.prefix(2);
        var suffixChars = "";
        for _ in 1...(emailPrefix.count-2) {
            suffixChars = suffixChars + "*";
        }
        
        let confirmMessage = "A verificaiton email has been sent to \(prefixChars)\(suffixChars)@\(emailToVerify)";
        let confirmAlertController = UIAlertController(title: "Verification", message: confirmMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default) { (UIAlertAction) in
            print ("Ok")
            
            var updatPostData = [String: Any]();
            updatPostData["email"] = postData["email"];
            updatPostData["phone"] = postData["phone"];

            UserService().sendPhoneNumberUpdateEmail(postData: updatPostData, complete:{(response) in
                
                setting.removeObject(forKey: "verifiedPhone");
                setting.setValue(UserSteps.OnBoardingScreens, forKey: "footprints");
                UIApplication.shared.keyWindow?.rootViewController = PhoneVerificationStep1ViewController.MainViewController()
                
            });
        }
        
        confirmAlertController.addAction(confirmAction)

        self.present(confirmAlertController, animated: true, completion: nil)
    }
}

