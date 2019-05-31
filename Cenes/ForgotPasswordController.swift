//
//  ForgotPasswordController.swift
//  Cenes
//
//  Created by Redblink on 16/01/18.
//  Copyright © 2018 Redblink Pvt Ltd. All rights reserved.
//

import UIKit

class ForgotPasswordController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var newPasswordView: UIView!
    
    @IBOutlet weak var newPasswordField: UITextField!
    
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    @IBOutlet weak var backButtton: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let backButtonTap = UITapGestureRecognizer.init(target: self, action: #selector(backButtonPressed));
        backButtton.addGestureRecognizer(backButtonTap);
        
        let emailGradient = CAGradientLayer()
        emailGradient.frame = CGRect.init(0, emailTF.frame.height-1, emailTF.frame.width, 1)
        emailGradient.colors = [UIColor.white.cgColor, UIColor(red:0.29, green:0.56, blue:0.89, alpha:0.75).cgColor, UIColor.white.cgColor]
        emailGradient.startPoint = CGPoint(x: 0, y: 1);
        emailGradient.endPoint = CGPoint(x: 1, y: 1);
        
        emailTF.layer.insertSublayer(emailGradient, at: 0);
        emailTF.becomeFirstResponder();
        
        
        
        let passwordGradient = CAGradientLayer()
        passwordGradient.frame = CGRect.init(0, newPasswordField.frame.height-1, newPasswordField.frame.width, 1)
        passwordGradient.colors = [UIColor.white.cgColor, UIColor(red:0.29, green:0.56, blue:0.89, alpha:0.75).cgColor, UIColor.white.cgColor]
        passwordGradient.startPoint = CGPoint(x: 0, y: 1);
        passwordGradient.endPoint = CGPoint(x: 1, y: 1);
        newPasswordField.layer.insertSublayer(passwordGradient, at: 0);
        
        
        let confimrPasswordGradient = CAGradientLayer()
        confimrPasswordGradient.frame = CGRect.init(0, confirmPasswordField.frame.height-1, confirmPasswordField.frame.width, 1)
        confimrPasswordGradient.colors = [UIColor.white.cgColor, UIColor(red:0.29, green:0.56, blue:0.89, alpha:0.75).cgColor, UIColor.white.cgColor]
        confimrPasswordGradient.startPoint = CGPoint(x: 0, y: 1);
        confimrPasswordGradient.endPoint = CGPoint(x: 1, y: 1);
        confirmPasswordField.layer.insertSublayer(confimrPasswordGradient, at: 0);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true);
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == emailTF) {
            if (emailTF.text == "") {
                self.showAlert(title: "Alert", message: "Email cannot be empty")
            } else {
                
                emailTF.resignFirstResponder();
                
                let queryStr = "email=\(emailTF.text!)";
                UserService().getForgetPasswordEmail(queryStr:queryStr , complete: {(response) in
                    
                    let success = response.value(forKey: "success") as! Bool;
                    if (success == true) {
                        
                        self.backButtton.isHidden = true;
                        
                        self.emailTF.isHidden = true;
                        self.newPasswordView.isHidden = false;
                        self.newPasswordField.becomeFirstResponder();
                        
                        DispatchQueue.main.async {
                            UserService().sendForgetPasswordEmail(queryStr: queryStr, complete: {(response) in
                                
                            });
                        }
                    } else {
                        self.emailTF.becomeFirstResponder();
                        let message = response.value(forKey: "message") as! String;
                        self.showAlert(title: "Alert", message: message)
                    }
                })
            }
        } else if (textField == newPasswordField) {
            confirmPasswordField.becomeFirstResponder();
        } else if (textField == confirmPasswordField) {
            
            if (newPasswordField.text != confirmPasswordField.text) {
                
                self.showAlert(title: "Passwords Donot Match", message: "")
                
            } else if (newPasswordField.text!.count < 8 ||  newPasswordField.text!.count > 16) {
                self.showAlert(title: "Check Password \nRequirements", message: "")
                
            } else {
                
                let decimalCharacters = CharacterSet.decimalDigits
                let decimalRange = newPasswordField.text!.rangeOfCharacter(from: decimalCharacters)
                if decimalRange == nil {
                    self.showAlert(title: "Check Password \nRequirements", message: "")
                    return false;
                }
                
                let letters = CharacterSet.letters
                let charactersRange = newPasswordField.text!.rangeOfCharacter(from: letters)
                if (charactersRange == nil) {
                    self.showAlert(title: "Check Password \nRequirements", message: "")
                    return false;
                }
                
                do {
                    let regex = try NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: .caseInsensitive)
                    let result = regex.firstMatch(in: newPasswordField.text!, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, newPasswordField.text!.count))
                    
                    if (result == nil) {
                        self.showAlert(title: "Check Password \nRequirements", message: "")
                        return false;
                    }
                    
                } catch {
                    debugPrint(error.localizedDescription)
                    return false
                }

                var postData = [String: Any]();
                postData["email"] = emailTF.text!;
                postData["password"] = newPasswordField.text!;
                postData["requestFrom"] = "App";

                UserService().updatePasswordWithoutToken(postData: postData, complete: {(response) in
                    
                    let success = response.value(forKey: "success") as! Bool;
                    
                    if (success == true) {
                        
                        let alertController = UIAlertController(title: "Reset Successful", message: "", preferredStyle: UIAlertControllerStyle.alert)
                        
                        let okAction = UIAlertAction(title: "LOGIN", style: .default) { (UIAlertAction) in
                            print ("Ok")
                            self.navigationController?.popViewController(animated: false)
                        }
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        let message = response.value(forKey: "message") as! String;
                        self.showAlert(title: "Alert", message: message);

                    }
                });
                
                return true;
            }
        }
        return false;
    }

}
