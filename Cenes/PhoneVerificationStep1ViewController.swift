//
//  PhoneVerificationStep1ViewController.swift
//  Deploy
//
//  Created by Cenes_Dev on 23/05/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class PhoneVerificationStep1ViewController: UIViewController, AppSettingsProtocol, UITextFieldDelegate {

    @IBOutlet weak var countryDropdownBar: UIView!
    
    @IBOutlet weak var countryLabel: UILabel!
    
    @IBOutlet weak var countryCodeLabel: UILabel!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var getAccessButton: UIButton!
    
    @IBOutlet weak var getAccessView: UIView!
    
    var countryCodeService: CountryCodeService!
    
    class func MainViewController() -> UINavigationController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhoneVerificationNav") as! UINavigationController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let countryDropdownBarTap = UITapGestureRecognizer.init(target: self, action: #selector(countryDropdownBarPressed))
        countryDropdownBar.addGestureRecognizer(countryDropdownBarTap);
        
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
        })
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
    
    
    @IBAction func getAccessButtonPressed(_ sender: Any) {
        
        var postData = [String: Any]();
        postData["countryCode"] = "\(self.countryCodeService.getPhoneCode())";
        postData["phone"] = "\(self.phoneNumberTextField.text!)";
        
        UserService().postVerificationCodeWithoutToken(postData: postData, complete: {(response) in
            
            let success = response.value(forKey: "success") as! Bool;
            if (success == true) {
                
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "PhoneVerificationStep2ViewController") as! PhoneVerificationStep2ViewController;
                viewController.countryCode = "\(self.countryCodeService.getPhoneCode())";
                viewController.phoneNumberStr =  "\(self.phoneNumberTextField.text!)";
                self.navigationController?.pushViewController(viewController, animated: true);
                
            } else {
                let message = response.value(forKey: "message") as! String;
                self.showAlert(title: "Alert", message: message)
            }
        });
        
        
        
    }
}
