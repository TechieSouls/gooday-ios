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
    
    var nactvityIndicatorView = NVActivityIndicatorView.init(frame: cgRectSizeLoading, type: NVActivityIndicatorType.lineScaleParty, color: UIColor.white, padding: 0.0);
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        emailTxtField.delegate = self
        passwordTextField.delegate = self
        
        let whiteColor : UIColor = UIColor.white
        self.emailTxtField.layer.borderColor = UIColor.black.cgColor
        self.emailTxtField.layer.borderWidth = 1.0
        self.emailTxtField.leftView = UIView(frame: CGRect(x: 0, y: 0, width:15, height: self.emailTxtField.frame.height))
        self.emailTxtField.leftViewMode = .always
    
    
        self.passwordTextField.layer.borderColor = UIColor.black.cgColor
        self.passwordTextField.layer.borderWidth = 1.0
        self.passwordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width:15, height: self.passwordTextField.frame.height))
        self.passwordTextField.leftViewMode = .always

    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
