//
//  PersonalDetailsViewController.swift
//  Deploy
//
//  Created by Cenes_Dev on 05/05/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class PersonalDetailsViewController: UIViewController {

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var password: UILabel!
    
    @IBOutlet weak var email: UILabel!
    
    @IBOutlet weak var phone: UILabel!
    
    @IBOutlet weak var dateOfBirth: UILabel!
    
    @IBOutlet weak var gender: UILabel!
    
    @IBOutlet weak var datePickerView: UIView!
    
    @IBOutlet weak var dateTimePicker: UIDatePicker!
    
    @IBOutlet weak var datePickerCancel: UIButton!
    
    @IBOutlet weak var datePickerDone: UIButton!
    
    var loggedInUser: User!;
    var seagueFor: String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Personal Details";
        self.view.backgroundColor = themeColor;
        self.tabBarController?.tabBar.isHidden = true;
        self.navigationController?.navigationBar.isHidden = false;
        
        let nameTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(namePressed));
        name.addGestureRecognizer(nameTapGesture);
        
        let passwordTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(passwordPressed));
        password.addGestureRecognizer(passwordTapGesture);
        
        let dobTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(dateOfBirthPressed));
        dateOfBirth.addGestureRecognizer(dobTapGesture);
        
        let genderTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(genderPressed));
        gender.addGestureRecognizer(genderTapGesture);
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func viewWillAppear(_ animated: Bool) {
        self.loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        name.text = loggedInUser.name!;
        email.text = loggedInUser.email!
        phone.text = loggedInUser.phone!;
        if (loggedInUser.password == nil) {
            password.text = "Set a Password";
        }
        if let dateOfBirthStr = loggedInUser.birthDayStr {
            
            let dateFormatter = DateFormatter();
            dateFormatter.dateFormat = "E MMMM d yyyy";
            let birthdate = dateFormatter.date(from: dateOfBirthStr);
            if (birthdate != nil) {
                dateOfBirth.text = birthdate?.yyyyhfMMhfdd();
            } else {
                 dateOfBirth.text = "Set Birth Day";
            }
            
        } else {
            dateOfBirth.text = "Set Birth Day"
        }
        if let dateOfBirthStr = loggedInUser.birthDayStr {
            gender.text = loggedInUser.gender!;
        } else {
            gender.text = "Set Gender";
        }
    }
    
    @objc func namePressed() {
        self.seagueFor = "Username";
        performSegue(withIdentifier: "editProfileSeague", sender: self);
    }
    
    @objc func passwordPressed() {
        self.seagueFor = "Password";
        performSegue(withIdentifier: "editProfileSeague", sender: self);
    }
    
    @objc func dateOfBirthPressed() {
        datePickerView.isHidden = false;
    }
    
    @objc func genderPressed() {
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
        present(actionSheetController, animated: true, completion: nil)
    }
    
    @IBAction func datePickerCancelPressed(_ sender: Any) {
        datePickerView.isHidden = true;
    }
    
    @IBAction func datePickerDonePressed(_ sender: Any) {
        datePickerView.isHidden = true;
        
        dateOfBirth.text = dateTimePicker.clampedDate.yyyyhfMMhfdd();
        //print(dateTimePicker.clampedDate)
        
        var postData: [String: Any] = [String: Any]();
        postData["birthDayStr"] = dateTimePicker.clampedDate.EMMMMdyyyy();
        postData["userId"] = loggedInUser.userId;
        loggedInUser.birthDayStr = dateTimePicker.clampedDate.EMMMMdyyyy();
        User().updateUserValuesInUserDefaults(user: self.loggedInUser);
        
        DispatchQueue.global(qos: .background).async {
            UserService().postUserDetails(postData: postData, token: self.loggedInUser.token, complete: {(response) in
                //User().updateUserValuesInUserDefaults(user: self.loggedInUser);
            });
        }
    }
    
    func genderShareSheetAction(genderSelectionValue: String) -> Void {
        gender.text = genderSelectionValue;
        
        var postData: [String: Any] = [String: Any]();
        postData["gender"] = genderSelectionValue;
        postData["userId"] = loggedInUser.userId;
        loggedInUser.gender = genderSelectionValue;
        User().updateUserValuesInUserDefaults(user: self.loggedInUser);
        
        DispatchQueue.global(qos: .background).async {
            UserService().postUserDetails(postData: postData, token: self.loggedInUser.token, complete: {(response) in
                //User().updateUserValuesInUserDefaults(user: self.loggedInUser);
            });
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! EditPersonalDetailsViewController;
        viewController.seagueafor = seagueFor;
    }
}
