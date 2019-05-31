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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        countryLabel.textColor = UIColor(red:0.29, green:0.56, blue:0.89, alpha:0.75);
        let countryBarTap = UITapGestureRecognizer.init(target: self, action: #selector(countryBarPressed));
        countryBar.addGestureRecognizer(countryBarTap);
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func deleteAccountButtonPressed(_ sender: Any) {
        
        if (phoneNumber.text == "") {
            
            appSettingsEditViewControllerDelegate.showAlert(title: "Alert", message: "Phone number cannot be empty.")
        } else if (password.text == "") {
            appSettingsEditViewControllerDelegate.showAlert(title: "Alert", message: "Password cannot be empty.")
        } else {
            
            var postData = [String: Any]();
            postData["phone"] = "\(String(countryCode.text!))\(phoneNumber.text!)";
            postData["password"] = "\(String(password.text!))";
            appSettingsEditViewControllerDelegate.deleteUserRequest(postData: postData);
        }
    }
    
    @objc func countryBarPressed() {
        appSettingsEditViewControllerDelegate.navigateToCountryList();
    }
    
    func highlightDeleteButton() {
        
        if (password.text != "" && phoneNumber.text != "") {
            deleteAccountButton.isEnabled = true;
            deleteAccountButton.backgroundColor =  UIColor(red:0.29, green:0.56, blue:0.89, alpha:0.75);
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (textField == phoneNumber) {
            
            password.becomeFirstResponder();
        
        } else if (textField == password) {
            highlightDeleteButton();
            password.resignFirstResponder();
        }
        
        return true;
    }
    
}
