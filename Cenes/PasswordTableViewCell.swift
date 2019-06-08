//
//  PasswordTableViewCell.swift
//  Deploy
//
//  Created by Cenes_Dev on 06/05/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class PasswordTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var currentPasswordField: UITextField!

    @IBOutlet weak var newPasswordField: UITextField!
    
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    @IBOutlet weak var passwordDescriptionText: UILabel!
    
    
    var editPersonalDetailsViewControllerDelegate: EditPersonalDetailsViewController!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.backgroundColor = themeColor;
        
        currentPasswordField.backgroundColor = UIColor.white;
        newPasswordField.backgroundColor = UIColor.white;
        confirmPasswordField.backgroundColor = UIColor.white;

        let currentPasswordLeftView = UIView(frame: CGRect.init(x: 0, y: 0, width: 20, height: currentPasswordField.frame.height))
        currentPasswordField.leftView = currentPasswordLeftView;
        currentPasswordField.leftViewMode = .always
        
        let leftView = UIView(frame: CGRect.init(x: 0, y: 0, width: 20, height: newPasswordField.frame.height))
        newPasswordField.leftView = leftView;
        newPasswordField.leftViewMode = .always
        
        let leftConfirmPasswordView = UIView(frame: CGRect.init(x: 0, y: 0, width: 20, height: confirmPasswordField.frame.height))
        confirmPasswordField.leftView = leftConfirmPasswordView;
        confirmPasswordField.leftViewMode = .always;
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if (textField == currentPasswordField) {
            self.newPasswordField.isEnabled = false;
            self.confirmPasswordField.isEnabled = false;
        }
        return true;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (textField == currentPasswordField) {
            
            var postData: [String: Any] = [String: Any]();
            postData["currentPassword"] = textField.text!;
            postData["userId"] = editPersonalDetailsViewControllerDelegate.loggedInUser.userId;
            UserService().postValidatePassword(postData: postData, token: editPersonalDetailsViewControllerDelegate.loggedInUser.token, complete: {(response) in
                
                let success = response.value(forKey: "success") as! Bool;
                if (success == false) {
                    self.editPersonalDetailsViewControllerDelegate.showAlert(title: response.value(forKey: "message") as! String, message: "")

                } else {
                    self.newPasswordField.isEnabled = true;
                    self.confirmPasswordField.isEnabled = true;
                    self.newPasswordField.becomeFirstResponder();
                }
            });
            return false;

        } else if (textField == newPasswordField) {
            confirmPasswordField.becomeFirstResponder();

        } else if (textField == confirmPasswordField) {
            
            if (newPasswordField.text != confirmPasswordField.text) {
                
                editPersonalDetailsViewControllerDelegate.showAlert(title: "Passwords Donot Match", message: "")
                
            } else if (newPasswordField.text!.count < 8 ||  newPasswordField.text!.count > 16) {
                editPersonalDetailsViewControllerDelegate.showAlert(title: "Check Password \nRequirements", message: "")

            } else {
                
                let decimalCharacters = CharacterSet.decimalDigits
                let decimalRange = newPasswordField.text!.rangeOfCharacter(from: decimalCharacters)
                if decimalRange == nil {
                    editPersonalDetailsViewControllerDelegate.showAlert(title: "Check Password \nRequirements", message: "")
                    return false;
                }

                let letters = CharacterSet.letters
                let charactersRange = newPasswordField.text!.rangeOfCharacter(from: letters)
                if (charactersRange == nil) {
                    editPersonalDetailsViewControllerDelegate.showAlert(title: "Check Password \nRequirements", message: "")
                    return false;
                }
                
                do {
                    let regex = try NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: .caseInsensitive)
                    let result = regex.firstMatch(in: newPasswordField.text!, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, newPasswordField.text!.count))
                    
                    if (result == nil) {
                        editPersonalDetailsViewControllerDelegate.showAlert(title: "Check Password \nRequirements", message: "")
                        return false;
                    }

                } catch {
                    debugPrint(error.localizedDescription)
                    return false
                }
                editPersonalDetailsViewControllerDelegate.newPassword = newPasswordField.text!
                editPersonalDetailsViewControllerDelegate.saveUserDetails();
                return true;
            }
            
        }
        
        return false;
    }
}
