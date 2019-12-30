//
//  SignInViewController.swift
//  Cenes
//
//  Created by Macbook on 13/10/18.
//  Copyright © 2018 Cenes Pvt Ltd. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import MessageUI
class SignInViewController: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable, MFMailComposeViewControllerDelegate {

    
    @IBOutlet weak var emailTxtField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var backButton: UIImageView!
    
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    @IBOutlet weak var helpAndFeedbackImg: UIImageView!

    
    var existingEmail = "";
    
    var nactvityIndicatorView = NVActivityIndicatorView.init(frame: cgRectSizeLoading, type: NVActivityIndicatorType.lineScaleParty, color: UIColor.white, padding: 0.0);
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let emailGradient = CAGradientLayer()
        emailGradient.frame = CGRect.init(x: 0, y: emailTxtField.frame.height-1, width: emailTxtField.frame.width, height: 1)
        emailGradient.colors = [UIColor.white.cgColor, UIColor(red:0.29, green:0.56, blue:0.89, alpha:0.75).cgColor, UIColor.white.cgColor]
        emailGradient.startPoint = CGPoint(x: 0, y: 1);
        emailGradient.endPoint = CGPoint(x: 1, y: 1);

        emailTxtField.layer.insertSublayer(emailGradient, at: 0);
        
        let passwordGradient = CAGradientLayer()
        passwordGradient.frame = CGRect.init(x: 0, y: passwordTextField.frame.height-1, width: passwordTextField.frame.width, height: 1)
        passwordGradient.colors = [UIColor.white.cgColor, UIColor(red:0.29, green:0.56, blue:0.89, alpha:0.75).cgColor, UIColor.white.cgColor]
        passwordGradient.startPoint = CGPoint(x: 0, y: 1);
        passwordGradient.endPoint = CGPoint(x: 1, y: 1);
        
        passwordTextField.layer.insertSublayer(passwordGradient, at: 0);
        
        let backTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(backButtonPressed));
        backButton.addGestureRecognizer(backTapGesture);
        
        self.hideKeyboardWhenTappedAround();
        
        if (existingEmail != "") {
            emailTxtField.text = existingEmail;
        }
        
        let bugTapGuesture = UITapGestureRecognizer.init(target: self, action: #selector(bugButtonPressed));
        self.helpAndFeedbackImg.addGestureRecognizer(bugTapGuesture);
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = themeColor;
        self.navigationController?.navigationBar.shouldRemoveShadow(true);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true);
    }
    
    @objc func bugButtonPressed() {
        self.helpAndFeedbackIconPressed(mfMailComposerDelegate: self);
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == emailTxtField) {
            passwordTextField.becomeFirstResponder();
        } else if (textField == passwordTextField) {
            
            if (emailTxtField.text == "") {
                showAlert(title: "Email is empty", message: "");
                return false;
            }
            
            if (passwordTextField.text == "") {
                showAlert(title: "Password is empty", message: "");
                return false;
            }
                        
            UserService().emailSignIn(email: emailTxtField.text!, password: passwordTextField.text!, complete: { (returnedDict) in
                
                if returnedDict.value(forKey: "Error") as? Bool == true {
                    
                    if (returnedDict.value(forKey: "ErrorCode") != nil) {
                        
                        let errorCode = returnedDict.value(forKey: "ErrorCode") as! Int;
                        if (errorCode == 1001) {
                            
                            let phone = setting.value(forKey: "verifiedPhone") as! String;
                            
                            let phoneNumberToDisplay = "\(String(phone.prefix(4)))xxxx\(phone.suffix(3))";
                            
                            let alertBody = "Do you want to update your phone number to \(phoneNumberToDisplay) ??";
                            
                            let alertController = UIAlertController(title: returnedDict.value(forKey: "ErrorMsg") as! String, message: alertBody, preferredStyle: UIAlertControllerStyle.alert)
                            
                            let okAction = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in
                                print ("Ok")
                                
                                alertController.dismiss(animated: true, completion: nil);
                                
                                self.confirmAlert(email: self.emailTxtField.text!);
                            }
                            
                            
                            let noAction = UIAlertAction(title: "No", style: .default) { (UIAlertAction) in
                                print ("No")
                                setting.setValue(UserSteps.PhoneVerification, forKey: "footprints");
                                UIApplication.shared.keyWindow?.rootViewController = ChoiceViewController.MainViewController()
                            }
                            alertController.addAction(okAction)
                            alertController.addAction(noAction)
                            self.present(alertController, animated: true, completion: nil)
                            
                        }
                    } else {
                        self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                    }
                } else {
                    
                    DispatchQueue.global(qos: .background).async {
                        self.syncDeviceContacts();
                        WebService().setPushToken();
                    }
                    setting.setValue(UserSteps.Authentication, forKey: "footprints")

                    UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController()
                }
            })
        }
        
        return false;
    }
    
    func syncDeviceContacts() {
        // your code here
        UserService().syncDevicePhoneNumbers( complete: { (returnedDict) in
            
        });
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
        let viewController = storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordController") as! ForgotPasswordController;
        self.navigationController?.pushViewController(viewController, animated: true);
    }
    
    @IBAction func loginBtnClicked(_ sender: Any) {
        
        if (emailTxtField.text == "") {
            showAlert(title: "Email is empty", message: "");
        } else if (passwordTextField.text == "") {
            showAlert(title: "Password is empty", message: "");
        } else {
            
            UserService().emailSignIn(email: emailTxtField.text!, password: passwordTextField.text!, complete: { (returnedDict) in
                
                if returnedDict.value(forKey: "Error") as? Bool == true {
                    
                    if (returnedDict.value(forKey: "ErrorCode") != nil) {
                    
                        let errorCode = returnedDict.value(forKey: "ErrorCode") as! Int;
                        if (errorCode == 1001) {
                            
                            let phone = setting.value(forKey: "verifiedPhone") as! String;
                            
                            let phoneNumberToDisplay = "\(String(phone.prefix(4)))xxxx\(phone.suffix(3))";
                            
                            let alertBody = "Do you want to update your phone number to \(phoneNumberToDisplay) ??";
                            
                            let alertController = UIAlertController(title: returnedDict.value(forKey: "ErrorMsg") as! String, message: alertBody, preferredStyle: UIAlertControllerStyle.alert)
                            
                            let okAction = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in
                                print ("Ok")
                                
                                alertController.dismiss(animated: true, completion: nil);
                                
                                self.confirmAlert(email: self.emailTxtField.text!);
                            }
                            
                            
                            let noAction = UIAlertAction(title: "No", style: .default) { (UIAlertAction) in
                                print ("No")
                                setting.setValue(UserSteps.PhoneVerification, forKey: "footprints");
                                UIApplication.shared.keyWindow?.rootViewController = ChoiceViewController.MainViewController()
                            }
                            alertController.addAction(okAction)
                            alertController.addAction(noAction)
                            self.present(alertController, animated: true, completion: nil)

                        }
                    } else {
                        
                        self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                    }
                } else {
                    
                    DispatchQueue.global(qos: .background).async {
                        self.syncDeviceContacts();
                        WebService().setPushToken();
                    }
                    setting.setValue(UserSteps.Authentication, forKey: "footprints")
                    
                    let user = User().loadUserDataFromUserDefaults(userDataDict: setting);
                    if (user.name == nil || user.name == "") {
                        
                        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SignupSuccessStep2ViewController") as! SignupSuccessStep2ViewController;
                        self.navigationController?.pushViewController(viewController, animated: true);
                        
                    } else {
                        UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController()

                    }
                }
            });
            
        }
    }
    
    func confirmAlert(email: String) {
        
        let emailToVerify = email.split(separator: "@")[1];
        
        let emailPrefix = email.split(separator: "@")[0];
        
        let prefixChars = emailPrefix.prefix(2);
        var suffixChars = "";
        for n in 1...(emailPrefix.count-2) {
            suffixChars = suffixChars + "*";
        }
        
        let confirmMessage = "A verification email has been sent to \(prefixChars)\(suffixChars)@\(emailToVerify)";
        let confirmAlertController = UIAlertController(title: "", message: confirmMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (UIAlertAction) in
            print ("Ok");
            
            var updatPostData = [String: Any]();
            updatPostData["email"] = email;
            updatPostData["phone"] = setting.value(forKey: "verifiedPhone") as! String;

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
