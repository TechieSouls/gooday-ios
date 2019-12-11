//
//  PhoneVerificationStep2ViewController.swift
//  Deploy
//
//  Created by Cenes_Dev on 23/05/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class PhoneVerificationStep2ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var phoneNumber: UILabel!
    
    @IBOutlet weak var verificationCodeField: UITextField!
    
    
    @IBOutlet weak var codeField1: UITextField!
    
    @IBOutlet weak var resendCodeText: UILabel!
    
    @IBOutlet weak var resendCodeTimer: UILabel!
    
    var timer = Timer();
    var phoneNumberStr: String = "";
    var seconds = 30;
    var verificationCodeTypedIn : String = "";
    var countryCode: String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = themeColor;
        if (phoneNumberStr != "") {
            phoneNumber.text = "\(countryCode)\(phoneNumberStr)";
        }
        resendCodeText.isUserInteractionEnabled = false;
        codeField1.addTarget(self, action: #selector(userPressedKey(textField:)), for: UIControlEvents.editingChanged);
        
        codeField1.becomeFirstResponder();
        
        self.hideKeyboardWhenTappedAround();
    }
    override func viewDidAppear(_ animated: Bool) {
        runTimer();
    }

    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar();
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func setupNavigationBar() {
        
        self.navigationController?.navigationBar.isHidden = false;
        
        let backButton = UIButton.init(type: .custom)
        backButton.setImage(#imageLiteral(resourceName: "abondan_event_icon"), for: UIControlState.normal)
        backButton.setImage(#imageLiteral(resourceName: "abondan_event_icon"), for: UIControlState.selected)
        backButton.addTarget(self, action:#selector(backButtonPressed), for: UIControlEvents.touchUpInside)
        backButton.frame = CGRect.init(x: 0, y: 0, width: 25, height: 25)
        let backBarButton = UIBarButtonItem.init(customView: backButton)
        
        self.navigationItem.leftBarButtonItem = backBarButton
    }
    
    
    @objc func userPressedKey(textField: UITextField) {
        
        if (textField.text?.count == 4) {
            textField.resignFirstResponder();
            
            setting.setValue("\(self.countryCode)\(self.phoneNumberStr)", forKey: "verifiedPhone")

            var postData = [String: Any]();
            postData["countryCode"] = self.countryCode;
            postData["code"] = textField.text!;
            postData["phone"] = self.phoneNumberStr;
            
            
            UserService().postCheckVerificationCodeWithoutToken(postData: postData, complete: {(response) in
                
                let success = response.value(forKey: "success") as! Bool;
                if (success == false) {
                    let message = response.value(forKey: "message") as! String;
                    self.showAlert(title: "Alert", message: message);
                    self.codeField1.becomeFirstResponder();
                    
                } else {
                    self.timer.invalidate();
                    
                    setting.setValue("\(self.countryCode)\(self.phoneNumberStr)", forKey: "verifiedPhone")
                    setting.setValue(UserSteps.PhoneVerification, forKey: "footprints")
                    UIApplication.shared.keyWindow?.rootViewController = ChoiceViewController.MainViewController()
                }
            });
        }
        
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds = seconds - 1;
        if (seconds < 10) {
            resendCodeTimer.text = "00:0\(seconds)";
        } else {
            resendCodeTimer.text = "00:\(seconds)";
        }
        
        if (seconds == 0) {
            timer.invalidate();
            resendCodeText.isUserInteractionEnabled = true;
            resendCodeText.textColor = UIColor(red: 245/255, green: 166/255, blue: 36/255, alpha: 1)
            
            var tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(resendTextPressed))
            resendCodeText.addGestureRecognizer(tapGesture);
        }
    }
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true);
    }
    
    @objc func resendTextPressed() {
        
        resendCodeText.isUserInteractionEnabled = false;
        resendCodeText.textColor = UIColor.lightGray
        timer = Timer();
        seconds = 30;
        runTimer();
        
        var postData = [String: Any]();
        postData["countryCode"] = "\(countryCode)";
        postData["phone"] = "\(phoneNumberStr)";
        
        DispatchQueue.global(qos: .background).async {
            UserService().postVerificationCodeWithoutToken(postData: postData, complete: {(response) in
                
            });
        }
    }
}
