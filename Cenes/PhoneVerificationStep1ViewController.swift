//
//  PhoneVerificationStep1ViewController.swift
//  Deploy
//
//  Created by Cenes_Dev on 23/05/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit
import MessageUI

class PhoneVerificationStep1ViewController: UIViewController, AppSettingsProtocol, UITextFieldDelegate, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var countryDropdownBar: UIView!
    
    @IBOutlet weak var countryLabel: UILabel!
    
    @IBOutlet weak var countryCodeLabel: UILabel!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var getAccessButton: UIButton!
    
    @IBOutlet weak var getAccessView: UIView!
    
    @IBOutlet weak var termsAndConditionsLabel: UILabel!
    
    @IBOutlet weak var privacyPolicyLabel: UILabel!

    @IBOutlet weak var helpAndFeedbackImg: UIImageView!

    var countryCodeService: CountryCodeService!
    
    class func MainViewController() -> UINavigationController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhoneVerificationNav") as! UINavigationController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tandctapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tandcPressed));
        termsAndConditionsLabel.addGestureRecognizer(tandctapGesture);
        
        let privacypolicyGesture = UITapGestureRecognizer.init(target: self, action: #selector(privacyPolicyPressed));
        privacyPolicyLabel.addGestureRecognizer(privacypolicyGesture);

        let countryDropdownBarTap = UITapGestureRecognizer.init(target: self, action: #selector(countryDropdownBarPressed))
        countryDropdownBar.addGestureRecognizer(countryDropdownBarTap);
        
        self.helpAndFeedbackImg.isHidden = true;
        let bugTapGuesture = UITapGestureRecognizer.init(target: self, action: #selector(bugButtonPressed));
        self.helpAndFeedbackImg.addGestureRecognizer(bugTapGuesture);
        
        addDoneButtonOnKeyboard();
        
        let countryCodeServices = CountryCodeService().getLibraryMasterCountriesEnglish();
        
        HttpService().getMethodWithoutToken(url: "https://api6.ipify.org/?format=json", complete: {(response) in
            
            if (response.value(forKey: "ip") != nil) {
                let ipAddress = response.value(forKey: "ip") as! String;
                
                
                let queryStr = "ipAddress=\(String(ipAddress))";
                UserService().getCountryByIpAddressWithoutToken(queryStr: queryStr, complete: {(response) in
                    
                    let success = response.value(forKey: "success") as! Bool;
                    var countryCode = "";
                    if (success == true) {
                        let countryDict = response.value(forKey: "data") as! NSDictionary;
                        countryCode = countryDict.value(forKey: "iso_code") as! String;
                    } else {
                        countryCode = ((Locale.current as NSLocale).object(forKey: .countryCode) as? String)!;
                    }
                    
                    for countryCodeServiceObj in countryCodeServices {
                        if (countryCode.uppercased() == countryCodeServiceObj.getNameCode().uppercased()) {
                            self.countryCodeService = countryCodeServiceObj;
                            break;
                        }
                    }
                    
                    self.selectedCountry(countryCodeService: self.countryCodeService);
                })
            }
        });
    }
    
    override func viewWillAppear(_ animated: Bool) {
        countryLabel.textColor = UIColor(red:0.29, green:0.56, blue:0.89, alpha:1);
        self.navigationController?.navigationBar.isHidden = true;
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func selectedCountry(countryCodeService: CountryCodeService) {
        countryLabel.text = countryCodeService.getName();
        countryCodeLabel.text = countryCodeService.getPhoneCode();
        self.countryCodeService = countryCodeService;
    }
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let cancel: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(self.doneButtonAction))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [cancel, flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        phoneNumberTextField.inputAccessoryView = doneToolbar
    }
    
    @objc func bugButtonPressed() {
        self.helpAndFeedbackIconPressed(mfMailComposerDelegate: self);
    }
    
    @objc func doneButtonAction(){
        phoneNumberTextField.resignFirstResponder()
        if (phoneNumberTextField.text != "") {
            getAccessView.backgroundColor = UIColor(red:0.29, green:0.56, blue:0.89, alpha:0.75);
        }
    }
    
    @objc func cancelButtonAction(){
        phoneNumberTextField.resignFirstResponder()
    }
    
    @objc func countryDropdownBarPressed() {
        
        let viewController = storyboard?.instantiateViewController(withIdentifier: "CountriesViewController") as! CountriesViewController;
        viewController.appSettingsProtocolDelegate = self;
        self.navigationController?.pushViewController(viewController, animated: true);
    }
    
    @objc func tandcPressed() {
        if let url = URL(string: termsandconditionsLink) {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func privacyPolicyPressed() {
        if let url = URL(string: privacyPolicyLink) {
            UIApplication.shared.open(url)
        }
    }

    @IBAction func getAccessButtonPressed(_ sender: Any) {
        
        if (self.countryCodeService != nil) {
            
            var phoneNumberWithoutInitialZero = self.phoneNumberTextField.text!
            let startIndexCharacter = phoneNumberWithoutInitialZero[phoneNumberWithoutInitialZero.startIndex];
            
            //If number has zero, lets truncate it
            if (startIndexCharacter == "0") {
                phoneNumberWithoutInitialZero = String(phoneNumberWithoutInitialZero.suffix(phoneNumberWithoutInitialZero.count - 1))
            }
            
            self.getAccessButton.isUserInteractionEnabled = false;
            var postData = [String: Any]();
            postData["countryCode"] = "\(self.countryCodeService.getPhoneCode())";
            postData["phone"] = "\(phoneNumberWithoutInitialZero)";
            
            setting.setValue("\(self.countryCodeService.nameCode)", forKey: "countryCode")

            UserService().postVerificationCodeWithoutToken(postData: postData, complete: {(response) in
                self.getAccessButton.isUserInteractionEnabled = true;

                let success = response.value(forKey: "success") as! Bool;
                if (success == true) {
                    
                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "PhoneVerificationStep2ViewController") as! PhoneVerificationStep2ViewController;
                    viewController.countryCode = "\(self.countryCodeService.getPhoneCode())";
                    viewController.phoneNumberStr =  "\(phoneNumberWithoutInitialZero)";
                    self.navigationController?.pushViewController(viewController, animated: true);
                    
                } else {
                    let message = response.value(forKey: "message") as! String;
                    self.showAlert(title: "Alert", message: message)
                }
            });
        }
        
    }
}
