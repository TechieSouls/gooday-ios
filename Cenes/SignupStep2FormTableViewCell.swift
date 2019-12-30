//
//  SignupStep2FormTableViewCell.swift
//  Deploy
//
//  Created by Cenes_Dev on 13/05/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class SignupStep2FormTableViewCell: UITableViewCell, UITextFieldDelegate, SignupStep2FormTableViewCellProtocol {
    
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var gender: UIButton!
    
    @IBOutlet weak var birthday: UIButton!
    
    var signupSuccessStep2ViewControllerDelegate: SignupSuccessStep2ViewController!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profilePic.setRounded();
        
        let cgColors = [UIColor.white.cgColor, UIColor(red:0.71, green:0.71, blue:0.71, alpha:0.75).cgColor, UIColor.white.cgColor]
        usernameField.layer.insertSublayer(getTextFieldBottomBorderGradient(textField: usernameField, cgColors: cgColors), at: 0);
        
        
        let cgGenderColors = [UIColor.white.cgColor, UIColor(red:0.71, green:0.71, blue:0.71, alpha:0.75).cgColor, UIColor.white.cgColor]
        gender.layer.insertSublayer(getButtonBottomBorderGradient(uiButton: gender, cgColors: cgGenderColors), at: 0);
        
        
        let cgBirthdayColors = [UIColor.white.cgColor, UIColor(red:0.71, green:0.71, blue:0.71, alpha:0.75).cgColor, UIColor.white.cgColor]
        birthday.layer.insertSublayer(getButtonBottomBorderGradient(uiButton: birthday, cgColors: cgBirthdayColors), at: 0);
        
        
        let profilePicTap = UITapGestureRecognizer.init(target: self, action: #selector(profilePicPressed));
        profilePic.addGestureRecognizer(profilePicTap);
        
        usernameField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func genderPressed(_ sender: Any) {
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let maleAction: UIAlertAction = UIAlertAction(title: "Male", style: .default) { action -> Void in
            self.genderShareSheetAction(genderSelectionValue: "Male");
        }
        maleAction.setValue(cenesLabelBlue, forKey: "titleTextColor")
        
        let femaleAction: UIAlertAction = UIAlertAction(title: "Female", style: .default) { action -> Void in
            self.genderShareSheetAction(genderSelectionValue: "Female");
        }
        femaleAction.setValue(cenesLabelBlue, forKey: "titleTextColor")
        
        let othersAction: UIAlertAction = UIAlertAction(title: "Other", style: .default) { action -> Void in
            self.genderShareSheetAction(genderSelectionValue: "Other");
        }
        othersAction.setValue(cenesLabelBlue, forKey: "titleTextColor")
        
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        //cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        actionSheetController.addAction(maleAction)
        actionSheetController.addAction(femaleAction)
        actionSheetController.addAction(othersAction)
        actionSheetController.addAction(cancelAction)
        
        // present an actionSheet...
        signupSuccessStep2ViewControllerDelegate.present(actionSheetController, animated: true, completion: nil)
    }

    @IBAction func birthdayPressed(_ sender: Any) {
        signupSuccessStep2ViewControllerDelegate.datePickerView.isHidden = false;
    }
    
    @objc func profilePicPressed() {
        signupSuccessStep2ViewControllerDelegate.photoIconClicked();
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if (textField.text != "") {
            let cgColors = [UIColor.white.cgColor, UIColor(red:0.29, green:0.56, blue:0.89, alpha:0.75).cgColor, UIColor.white.cgColor]
            
            usernameField.layer.addSublayer(getTextFieldBottomBorderGradient(textField: usernameField, cgColors: cgColors));
        } else {
            let cgColors = [UIColor.white.cgColor, UIColor(red:0.71, green:0.71, blue:0.71, alpha:0.75).cgColor, UIColor.white.cgColor]
            usernameField.layer.insertSublayer(getTextFieldBottomBorderGradient(textField: usernameField, cgColors: cgColors), at: 0);
            
        }
        signupSuccessStep2ViewControllerDelegate.loggedInUser.name = textField.text!;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (usernameField.text != "") {
            signupSuccessStep2ViewControllerDelegate.loggedInUser.name = usernameField.text!;
            
            let cgColors = [UIColor.white.cgColor, UIColor(red:0.29, green:0.56, blue:0.89, alpha:0.75).cgColor, UIColor.white.cgColor]

            usernameField.layer.addSublayer(getTextFieldBottomBorderGradient(textField: usernameField, cgColors: cgColors));
            
            usernameField.resignFirstResponder();
            
            signupSuccessStep2ViewControllerDelegate.highLightCompleteButton();
            
            
            var postData: [String: Any] = [String: Any]();
            postData["username"] = usernameField.text!;
            postData["userId"] = signupSuccessStep2ViewControllerDelegate.loggedInUser.userId;
            User().updateUserValuesInUserDefaults(user: signupSuccessStep2ViewControllerDelegate.loggedInUser);
            
            DispatchQueue.global(qos: .background).async {
                UserService().postUserDetails(postData: postData, token: self.signupSuccessStep2ViewControllerDelegate.loggedInUser.token, complete: {(response) in
                    print("Name Updated")
                });
            }
        }
        return true;
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("Print");
    }

    
    
    func getTextFieldBottomBorderGradient(textField: UITextField, cgColors: [CGColor]) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect.init(x: 0, y: textField.frame.height-1, width: textField.frame.width, height: 1)
        gradient.colors = cgColors
        gradient.startPoint = CGPoint(x: 0, y: 1);
        gradient.endPoint = CGPoint(x: 1, y: 1);
        return gradient;
    }
    
    func getButtonBottomBorderGradient(uiButton: UIButton, cgColors: [CGColor]) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect.init(x: 0, y: uiButton.frame.height-1, width: uiButton.frame.width, height: 1)
        gradient.colors = cgColors
        gradient.startPoint = CGPoint(x: 0, y: 1);
        gradient.endPoint = CGPoint(x: 1, y: 1);
        return gradient;
    }
    
    func genderShareSheetAction(genderSelectionValue: String) -> Void {
        let cgColors = [UIColor.white.cgColor, UIColor(red:0.29, green:0.56, blue:0.89, alpha:0.75).cgColor, UIColor.white.cgColor]
        gender.layer.addSublayer(getTextFieldBottomBorderGradient(textField: usernameField, cgColors: cgColors));
        
        gender.setTitleColor(UIColor.black, for: .normal);
        gender.setTitle(genderSelectionValue, for: .normal)        
        
        var postData: [String: Any] = [String: Any]();
        postData["gender"] = genderSelectionValue;
        postData["userId"] = signupSuccessStep2ViewControllerDelegate.loggedInUser.userId;
        signupSuccessStep2ViewControllerDelegate.loggedInUser.gender = genderSelectionValue;
        User().updateUserValuesInUserDefaults(user: signupSuccessStep2ViewControllerDelegate.loggedInUser);
        
        DispatchQueue.global(qos: .background).async {
            UserService().postUserDetails(postData: postData, token: self.signupSuccessStep2ViewControllerDelegate.loggedInUser.token, complete: {(response) in
                print("Gender Updated")
            });
        }
        
        signupSuccessStep2ViewControllerDelegate.highLightCompleteButton();
        
    }
    
    func datePickerDone(date: Date) {
        let cgColors = [UIColor.white.cgColor, UIColor(red:0.29, green:0.56, blue:0.89, alpha:0.75).cgColor, UIColor.white.cgColor]
        birthday.layer.addSublayer(getTextFieldBottomBorderGradient(textField: usernameField, cgColors: cgColors));
        birthday.setTitleColor(UIColor.black, for: .normal);
        birthday.setTitle(date.yyyyhfMMhfdd(), for: .normal)
        
        var postData: [String: Any] = [String: Any]();
        postData["birthDayStr"] = date.EMMMMdyyyy();
        postData["userId"] = self.signupSuccessStep2ViewControllerDelegate.loggedInUser.userId;
        self.signupSuccessStep2ViewControllerDelegate.loggedInUser.birthDayStr = date.EMMMMdyyyy();
        User().updateUserValuesInUserDefaults(user: signupSuccessStep2ViewControllerDelegate.loggedInUser);
        
        DispatchQueue.global(qos: .background).async {
            UserService().postUserDetails(postData: postData, token: self.signupSuccessStep2ViewControllerDelegate.loggedInUser.token, complete: {(response) in
                print("BirthDay Updated")
            });
        }
        
        signupSuccessStep2ViewControllerDelegate.highLightCompleteButton();
    }
    
    func updateProfilePic(profilePicImage: UIImage) {
        profilePic.image = profilePicImage;
    }
}
