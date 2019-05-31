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
    
    @IBOutlet weak var codeField2: UITextField!
    @IBOutlet weak var codeField3: UITextField!
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
        codeField1.becomeFirstResponder();
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                print("Backspace was pressed")
                if (self.verificationCodeTypedIn.count > 0) {
                    self.verificationCodeTypedIn = self.verificationCodeTypedIn.substring(toIndex: self.verificationCodeTypedIn.count - 1);
                }
            }
        }

        if let text = textField.text as NSString? {
            self.verificationCodeTypedIn = text.replacingCharacters(in: range, with: string)
            //self.verificationCodeTypedIn = self.verificationCodeTypedIn + string;
        }
        
        let attributedText = NSMutableAttributedString(string: self.verificationCodeTypedIn)
        attributedText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.orange, range: NSRange(location: 0, length: attributedText.length))
        
        var greyText = "";
        if (verificationCodeTypedIn.count == 1) {
            greyText = "000";
        } else if (verificationCodeTypedIn.count == 2) {
            greyText = "00";
        } else if (verificationCodeTypedIn.count == 3) {
            greyText = "0";
        } else if (verificationCodeTypedIn.count == 4) {
            greyText = "";
        }
        
        
        let attributedGreyText = NSMutableAttributedString(string: greyText)
        attributedGreyText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.gray, range: NSRange(location: 0, length: attributedGreyText.length))
        
        let mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(attributedText);
        mutableAttributedString.append(attributedGreyText);
        
        //codeField1.text = self.verificationCodeTypedIn;
        //codeField1.attributedText = NSAttributedString.init(string: "");
        //codeField1.attributedText = mutableAttributedString;
        if (self.verificationCodeTypedIn.count < 4) {
            return true;
        } else  if (self.verificationCodeTypedIn.count == 4) {
            codeField1.resignFirstResponder();
            
            var postData = [String: Any]();
            postData["countryCode"] = self.countryCode;
            postData["code"] = self.verificationCodeTypedIn;
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
                    setting.setValue(3, forKey: "onboarding")
                    UIApplication.shared.keyWindow?.rootViewController = ChoiceViewController.MainViewController()
                }
            });
            return true;
        }
        return false;
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
            var postData = [String: Any]();
            postData["countryCode"] = "\(countryCode)";
            postData["phone"] = "\(phoneNumberStr)";
            
            DispatchQueue.global(qos: .background).async {
                UserService().postVerificationCodeWithoutToken(postData: postData, complete: {(response) in
                    
                });
            }
            
        }
    }
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true);
    }
    
}
