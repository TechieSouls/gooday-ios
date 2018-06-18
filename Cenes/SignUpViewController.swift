//
//  SignUpViewController.swift
//  Cenes
//  This is for signing up page with email id
//  Created by Sabita Rani Samal on 7/6/17.
//  Copyright © 2017 Sabita Rani Samal. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class SignUpViewController: UIViewController,NVActivityIndicatorViewable {
    
    
    @IBOutlet weak var nameTextField: UITextField!

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var buttonView: UIView!
    
    @IBOutlet weak var textFieldView: UIView!
    var keyBoard = false
    
    @IBOutlet weak var buttonViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var buttonViewTop: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        signupButton.backgroundColor = commonColor
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        //buttonViewTop.constant = CGFloat(BOTTOM_BEFORE_KEYBOARD)
        
        configureTextField(withImage: #imageLiteral(resourceName: "loginusername"), textfield: nameTextField)
        configureTextField(withImage: #imageLiteral(resourceName: "loginPasswords"), textfield: passwordTextField)
        configureTextField(withImage: #imageLiteral(resourceName: "loginemail"), textfield: emailTextField)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                    self.buttonViewBottom.constant = keyboardSize.height
            
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
            self.buttonViewBottom.constant  = 187
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func configureTextField(withImage: UIImage, textfield: UITextField) {
        let imageView = UIImageView.init(image: withImage)
        imageView.frame = CGRect(x: 5, y: 0, width: 60, height: 40)
        imageView.contentMode = .center
        
        textfield.leftView = imageView
        textfield.leftViewMode = .always
        
        //textfield.backgroundColor = UIColor.white
    }
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        
        guard Util.isnameLenth(name: nameTextField.text!)else{
    
            nameTextField.backgroundColor =  commonColor
            
            alertMessage(message: "Name is empty")
            
            return
        }
        
        guard Util.isValidEmail(testStr: emailTextField.text!)else{
            
            emailTextField.backgroundColor =  commonColor
            
            alertMessage(message: "Email is not valid")
            
            return
        }
        
        guard Util.isPwdLenth(password: passwordTextField.text!)else{
            
            passwordTextField.backgroundColor =  commonColor
            
            alertMessage(message: "password should be greater than 3")
            
            return
        }
        
        let webServ = WebService()
        
        startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))
        
        webServ.emailSignUp(email: emailTextField.text!, name:nameTextField.text! , password: passwordTextField.text!, username: nameTextField.text!, complete: { (returnedDict) in
            
            self.stopAnimating()
            
            if returnedDict.value(forKey: "Error") as? Bool == true {
                
                self.alertMessage(message: (returnedDict["ErrorMsg"] as? String)!)
                
            }else{
            
            setting.setValue(2, forKey: "onboarding")
            let camera = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "onbooardingNavigation") as? UINavigationController
            UIApplication.shared.keyWindow?.rootViewController = camera
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
extension SignUpViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return false
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.backgroundColor = UIColor.clear
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.resignFirstResponder()
    }

}
