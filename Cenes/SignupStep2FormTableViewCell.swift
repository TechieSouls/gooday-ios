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
    var user = User();
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        user = User().loadUserDataFromUserDefaults(userDataDict: setting);
        
        profilePic.setRounded();
        
        let cgColors = [UIColor.white.cgColor, UIColor(red:0.71, green:0.71, blue:0.71, alpha:0.75).cgColor, UIColor.white.cgColor]
        usernameField.layer.insertSublayer(getTextFieldBottomBorderGradient(textField: usernameField, cgColors: cgColors), at: 0);
        
        
        let cgGenderColors = [UIColor.white.cgColor, UIColor(red:0.71, green:0.71, blue:0.71, alpha:0.75).cgColor, UIColor.white.cgColor]
        gender.layer.insertSublayer(getButtonBottomBorderGradient(uiButton: gender, cgColors: cgGenderColors), at: 0);
        
        
        let cgBirthdayColors = [UIColor.white.cgColor, UIColor(red:0.71, green:0.71, blue:0.71, alpha:0.75).cgColor, UIColor.white.cgColor]
        birthday.layer.insertSublayer(getButtonBottomBorderGradient(uiButton: birthday, cgColors: cgBirthdayColors), at: 0);
        
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (usernameField.text != "") {
            user.name = usernameField.text!;
            
            let cgColors = [UIColor.white.cgColor, UIColor(red:0.29, green:0.56, blue:0.89, alpha:0.75).cgColor, UIColor.white.cgColor]

            usernameField.layer.addSublayer(getTextFieldBottomBorderGradient(textField: usernameField, cgColors: cgColors));
            
            usernameField.resignFirstResponder();
        }
        return true;
    }
    
    func getTextFieldBottomBorderGradient(textField: UITextField, cgColors: [CGColor]) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect.init(0, textField.frame.height-1, textField.frame.width, 1)
        gradient.colors = cgColors
        gradient.startPoint = CGPoint(x: 0, y: 1);
        gradient.endPoint = CGPoint(x: 1, y: 1);
        return gradient;
    }
    
    func getButtonBottomBorderGradient(uiButton: UIButton, cgColors: [CGColor]) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect.init(0, uiButton.frame.height-1, uiButton.frame.width, 1)
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
        
        var pgenderostData: [String: Any] = [String: Any]();
        pgenderostData["gender"] = genderSelectionValue;
        pgenderostData["userId"] = user.userId;
        user.gender = genderSelectionValue;
        User().updateUserValuesInUserDefaults(user: self.user);
        
        /*DispatchQueue.global(qos: .background).async {
            UserService().postUserDetails(postData: postData, token: self.user.token, complete: {(response) in
                //User().updateUserValuesInUserDefaults(user: self.loggedInUser);
            });
        }*/
        
    }
    
    func datePickerDone(date: Date) {
        let cgColors = [UIColor.white.cgColor, UIColor(red:0.29, green:0.56, blue:0.89, alpha:0.75).cgColor, UIColor.white.cgColor]
        birthday.layer.addSublayer(getTextFieldBottomBorderGradient(textField: usernameField, cgColors: cgColors));
        birthday.setTitleColor(UIColor.black, for: .normal);
        birthday.setTitle(date.yyyyhfMMhfdd(), for: .normal)
        
        var postData: [String: Any] = [String: Any]();
        postData["birthDayStr"] = date.EMMMMdyyyy();
        postData["userId"] = user.userId;
        user.birthDayStr = date.EMMMMdyyyy();
        User().updateUserValuesInUserDefaults(user: self.user);
        
        /*DispatchQueue.global(qos: .background).async {
            UserService().postUserDetails(postData: postData, token: self.user.token, complete: {(response) in
                //User().updateUserValuesInUserDefaults(user: self.loggedInUser);
            });
        }*/
        
    }
}
