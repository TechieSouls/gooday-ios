//
//  SignupSetp1ViewController.swift
//  Cenes
//
//  Created by Macbook on 29/09/18.
//  Copyright © 2018 Cenes Pvt Ltd. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class SignupSetp1ViewController: UIViewController, NVActivityIndicatorViewable, UITextFieldDelegate  {

    
    @IBOutlet weak var textPhoneNumber: UITextField!
    
    @IBOutlet weak var btnCountryDropdown: UIButton!
    
    @IBOutlet weak var btnContinue: UIButton!
    
    @IBOutlet weak var firstViewContainer: UIView!
    
    @IBOutlet weak var secondViewContainer: UIView!
    
    var authenticateManager: AuthenticateManager!;
    var countryCode: String = "+00";
    let userService = UserService();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.authenticateManager = AuthenticateManager();
        
        //Lets get the country of user where he is at.
        var countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String;
        let phoneCode = self.authenticateManager.getCountryPhonceCode(countryCode!);
        if (phoneCode != "") {
            countryCode = "+\(phoneCode)";
        }
        
        self.textPhoneNumber.delegate = self;
        
        let blueColor : UIColor = Util.colorWithHexString(hexString: "2C80D8");
        self.textPhoneNumber.layer.borderColor = blueColor.cgColor
        self.textPhoneNumber.layer.borderWidth = 1.0
        self.textPhoneNumber.leftView = UIView(frame: CGRect(x: 0, y: 0, width:15, height: self.textPhoneNumber.frame.height))
        self.textPhoneNumber.leftViewMode = .always
        
        print("my code :\(countryCode)");
        
        self.firstViewContainer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.bounds.height/2)
        self.secondViewContainer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.bounds.height/2)
        
        // Do any additional setup after loading the view.
        self.btnContinue.layer.borderColor = UIColor.orange.cgColor
        self.btnContinue.layer.borderWidth = 1
        self.btnContinue.layer.cornerRadius = 20
        
        // Do any additional setup after loading the view.
        self.btnCountryDropdown.backgroundColor = Util.colorWithHexString(hexString: "2C80D8");
        self.btnCountryDropdown.setTitle(countryCode, for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    
    @IBAction func onClickCountryDropdown(_ sender: Any) {
        
        let signupCountryController = storyboard?.instantiateViewController(withIdentifier: "signupCountryCodeViewController") as! SignupCountryCodeViewController
        navigationController?.pushViewController(signupCountryController, animated: false);
        
    }
    
    
    @IBAction func onClickContinue(_ sender: Any) {
        if (!isValidSSignupStep1()) {
            return;
        }
        self.startAnimating(loadinIndicatorSize, message: "Sending Verification Code..", type: NVActivityIndicatorType(rawValue: 15))
        userService.sendVerificationCode(countryCode: countryCode, phoneNumber: self.textPhoneNumber.text!, complete: { (returnDict) in
            
            self.stopAnimating()
            if (returnDict["success"] as! Bool == true) {
                let signupStep2Controller = self.storyboard?.instantiateViewController(withIdentifier: "signupStep2ViewController") as! SignupStep2ViewController
                signupStep2Controller.phoneNumber = self.textPhoneNumber.text!
                signupStep2Controller.countryCode = self.countryCode; self.navigationController?.pushViewController(signupStep2Controller, animated: true)
            } else {
                self.alertMessage(message: returnDict["message"] as! String);
            }
            
        })
        
    }
    
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
    
  
    func isValidSSignupStep1() -> Bool {
        
        if (countryCode == "+00") {
            
            self.alertMessage(message: "Please choose country code")
            return false;
        }
        
        if (self.textPhoneNumber.text?.count == 0) {
            self.alertMessage(message: "Please enter your number")
            return false;
        }
        return true;
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func alertMessage (message :String)
    {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
            print ("Ok")
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

}
