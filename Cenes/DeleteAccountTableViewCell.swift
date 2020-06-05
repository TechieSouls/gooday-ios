//
//  DeleteAccountTableViewCell.swift
//  Deploy
//
//  Created by Cenes_Dev on 18/05/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class DeleteAccountTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var countryBar: UIView!
    
    @IBOutlet weak var countryLabel: UILabel!
    
    @IBOutlet weak var countryCode: UILabel!
    
    @IBOutlet weak var phoneNumber: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var deleteAccountButton: UIButton!
    
    var appSettingsEditViewControllerDelegate: AppSettingsEditViewController!
    var passwordAvailable = true;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        countryLabel.textColor = UIColor(red:0.29, green:0.56, blue:0.89, alpha:0.75);
        let countryBarTap = UITapGestureRecognizer.init(target: self, action: #selector(countryBarPressed));
        countryBar.addGestureRecognizer(countryBarTap);
        
        if (passwordAvailable == false) {
            deleteAccountButton.isEnabled = true;
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func deleteAccountButtonPressed(_ sender: Any) {
        
        deleteAccountButton.backgroundColor =  UIColor(red:0.29, green:0.56, blue:0.89, alpha:0.75);

        if (phoneNumber.text == "") {
            
            appSettingsEditViewControllerDelegate.showAlert(title: "Alert", message: "Phone number cannot be empty.")
        } else if (passwordAvailable == true && password.text == "") {
            appSettingsEditViewControllerDelegate.showAlert(title: "Alert", message: "Password cannot be empty.")
        } else {
            
            var phoneNumberWithoutInitialZero = self.phoneNumber.text!.removeWhitespace();
            let startIndexCharacter = phoneNumberWithoutInitialZero[phoneNumberWithoutInitialZero.startIndex];
            
            //If number has zero, lets truncate it
            if (startIndexCharacter == "0") {
                phoneNumberWithoutInitialZero = String(phoneNumberWithoutInitialZero.suffix(phoneNumberWithoutInitialZero.count - 1))
            }
            
            if (startIndexCharacter == "+") {
                appSettingsEditViewControllerDelegate.showAlert(title: "Alert", message: "Please donot append country code.")
            } else {
                var postData = [String: Any]();
                postData["userId"] = appSettingsEditViewControllerDelegate.loggedInUser.userId!
                postData["phone"] = "\(String(countryCode.text!))\(phoneNumberWithoutInitialZero)";
                if (passwordAvailable == true) {
                    postData["password"] = "\(String(password.text!))";
                }
                appSettingsEditViewControllerDelegate.deleteUserRequest(postData: postData);
            }
        }
    }
    
    @objc func countryBarPressed() {
        appSettingsEditViewControllerDelegate.navigateToCountryList();
    }
    
    func highlightDeleteButton() {
        
        if (phoneNumber.text != "" && passwordAvailable == false) {
            deleteAccountButton.isEnabled = true;
            deleteAccountButton.backgroundColor =  UIColor(red:0.29, green:0.56, blue:0.89, alpha:0.75);
        } else  if (password.text != "" && phoneNumber.text != "") {
            deleteAccountButton.isEnabled = true;
            deleteAccountButton.backgroundColor =  UIColor(red:0.29, green:0.56, blue:0.89, alpha:0.75);
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (textField == phoneNumber) {
            if (passwordAvailable == true) {
                password.becomeFirstResponder();
            } else {
                highlightDeleteButton();
                phoneNumber.resignFirstResponder();
            }
        
        } else if (textField == password) {
            highlightDeleteButton();
            password.resignFirstResponder();
        }
        
        return true;
    }
    
}
