//
//  SignInViewController.swift
//  Cenes
//
//  Created by Macbook on 13/10/18.
//  Copyright © 2018 Cenes Pvt Ltd. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class SignInViewController: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable {

    
    @IBOutlet weak var emailTxtField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var backButton: UIImageView!
    
    var nactvityIndicatorView = NVActivityIndicatorView.init(frame: cgRectSizeLoading, type: NVActivityIndicatorType.lineScaleParty, color: UIColor.white, padding: 0.0);
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let emailGradient = CAGradientLayer()
        emailGradient.frame = CGRect.init(0, emailTxtField.frame.height-1, emailTxtField.frame.width, 1)
        emailGradient.colors = [UIColor.white.cgColor, UIColor(red:0.29, green:0.56, blue:0.89, alpha:0.75).cgColor, UIColor.white.cgColor]
        emailGradient.startPoint = CGPoint(x: 0, y: 1);
        emailGradient.endPoint = CGPoint(x: 1, y: 1);

        emailTxtField.layer.insertSublayer(emailGradient, at: 0);
        
        let passwordGradient = CAGradientLayer()
        passwordGradient.frame = CGRect.init(0, passwordTextField.frame.height-1, passwordTextField.frame.width, 1)
        passwordGradient.colors = [UIColor.white.cgColor, UIColor(red:0.29, green:0.56, blue:0.89, alpha:0.75).cgColor, UIColor.white.cgColor]
        passwordGradient.startPoint = CGPoint(x: 0, y: 1);
        passwordGradient.endPoint = CGPoint(x: 1, y: 1);
        
        passwordTextField.layer.insertSublayer(passwordGradient, at: 0);
        
        let backTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(backButtonPressed));
        backButton.addGestureRecognizer(backTapGesture);
        
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
                    self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                    
                } else {
                    WebService().setPushToken();
                    UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController()
                }
            })
        }
        
        return false;
    }
    
    @IBAction func onLoginClicked(_ sender: Any) {
        
        self.emailTxtField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        
        if Util.isValidEmail(testStr: emailTxtField.text!) == false {
            
            emailTxtField.backgroundColor =  commonColor
            
            alertMessage(message: "Email is empty")
            
            return
        }
        
        guard Util.isPwdLenth(password: passwordTextField.text!)else{
            
            passwordTextField.backgroundColor =  commonColor
            alertMessage(message: "password should be greater than 5")
            
            return
        }
        
        let userService = UserService()
        self.startAnimating(loadinIndicatorSize, message: "Loading...", type: self.nactvityIndicatorView.type)
        // new hud
        
        userService.emailSignIn(email: emailTxtField.text!, password: passwordTextField.text!, complete: { (returnedDict) in
            
            
            self.stopAnimating()
            if returnedDict.value(forKey: "Error") as? Bool == true {
                self.alertMessage(message: (returnedDict["ErrorMsg"] as? String)!)
                
            }else{
                
                WebService().setPushToken();
                
                UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController()

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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
