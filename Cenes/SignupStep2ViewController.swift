//
//  SignupStep2ViewController.swift
//  Cenes
//
//  Created by Macbook on 23/09/18.
//  Copyright © 2018 Cenes Pvt Ltd. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class SignupStep2ViewController: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var keyPadView: UIView!
    
    @IBOutlet weak var lblBox1: UILabel!
    
    @IBOutlet weak var lblBox2: UILabel!
    
    @IBOutlet weak var lblBox3: UILabel!
    
    @IBOutlet weak var lblBox4: UILabel!

    @IBOutlet weak var verificationCodeGuideText: UILabel!
    
    var userService: UserService = UserService();
    var verificationCode: String = "";
    var countryCode: String = "";
    var phoneNumber: String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       // self.view.addSubview(keyPadView);
        //self.setupAutoLayout();
        self.intializeComponents();
        
        self.userService = UserService();
        self.verificationCodeGuideText.text = "Please type the verification code sent to \(phoneNumber).";

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    func intializeComponents() {
        
        self.lblBox1.textAlignment = .center;
        self.lblBox2.textAlignment = .center;
        self.lblBox3.textAlignment = .center;
        self.lblBox4.textAlignment = .center;
        
        self.lblBox1.textColor = UIColor.white;
        self.lblBox2.textColor = UIColor.white;
        self.lblBox3.textColor = UIColor.white;
        self.lblBox4.textColor = UIColor.white;
    }
    
    
    @IBAction func keypadButton1Pressed(_ sender: Any) {
        self.verificationCodePress(number: "1");
    }
    
    @IBAction func keypadButton2Pressed(_ sender: Any) {
        self.verificationCodePress(number: "2");
    }
    
    @IBAction func keypadButton3Pressed(_ sender: Any) {
        self.verificationCodePress(number: "3");
    }
    @IBAction func keypadButton4Pressed(_ sender: Any) {
        self.verificationCodePress(number: "4");
    }
    
    @IBAction func keypadButton5Pressed(_ sender: Any) {
        self.verificationCodePress(number: "5");
    }

    @IBAction func keypadButton6Pressed(_ sender: Any) {
        self.verificationCodePress(number: "6");
    }
    
    @IBAction func keypadButton7Pressed(_ sender: Any) {
        self.verificationCodePress(number: "7");
    }
    
    @IBAction func keypadButton8Pressed(_ sender: Any) {
        self.verificationCodePress(number: "8");
    }
    
    @IBAction func keypadButton9Pressed(_ sender: Any) {
        self.verificationCodePress(number: "9");
    }
    
    @IBAction func keypadButton0Pressed(_ sender: Any) {
        self.verificationCodePress(number: "0");
    }
    
    @IBAction func keypadButtonDelPressed(_ sender: Any) {
        self.verificationCodePress(number: "-");
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func verificationCodePress(number: String){

        if(self.verificationCode.count > 0 && number ==  "-"){
            let index = self.verificationCode.index(self.verificationCode.startIndex, offsetBy: self.verificationCode.count - 1)
            self.verificationCode = String(self.verificationCode.prefix(upTo: index));
            if (self.verificationCode.count == 0) {
                self.lblBox1.text = "";
                self.lblBox2.text = "";
                self.lblBox3.text = "";
                self.lblBox4.text = "";
            } else if (self.verificationCode.count == 1) {
                self.lblBox2.text = "";
                self.lblBox3.text = "";
                self.lblBox4.text = "";
            } else if (self.verificationCode.count == 2) {
                self.lblBox3.text = "";
                self.lblBox4.text = "";
               
            }else if (self.verificationCode.count == 3) {
                self.lblBox4.text = "";
               
            }
        
        }else {
            self.verificationCode += number;
        }
        
        if (self.verificationCode.count == 1) {
            self.lblBox1.text = self.verificationCode;
        } else if (self.verificationCode.count == 2) {
           
            self.lblBox2.text = self.verificationCode.substring(fromIndex: 1)
        }else if (self.verificationCode.count == 3) {
            
            self.lblBox3.text = self.verificationCode.substring(fromIndex: 2)
        }else if (self.verificationCode.count == 4) {
            self.lblBox4.text = self.verificationCode.substring(fromIndex: 3)
        }
        
        //Send Verification Code on Boxes filled with code
        if (self.verificationCode.count == 4) {
            
            self.startAnimating(loadinIndicatorSize, message: "Verifying Code...", type: NVActivityIndicatorType(rawValue: 15))
            
            self.userService.checkVerificationCode(countryCode: self.countryCode, phoneNumber: self.phoneNumber, code: self.verificationCode) { (returnedDict) in
                
                self.stopAnimating()

                if (returnedDict.value(forKey: "success") as! Bool == false) {
                    self.alertMessage(message: (returnedDict.value(forKey: "message") as? String)!);

                } else {
                    let signupSuccessViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignupSuccessViewController") as! SignupSuccessViewController
               
                    signupSuccessViewController.phoneNumber = self.countryCode + self.phoneNumber
                    self.navigationController?.pushViewController(signupSuccessViewController, animated: true)
                }
            };
        }
    }
    
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

extension String {
    
    var length: Int {
        return self.characters.count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
}
