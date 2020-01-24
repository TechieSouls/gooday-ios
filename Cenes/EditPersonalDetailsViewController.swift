//
//  EditPersonalDetailsViewController.swift
//  Deploy
//
//  Created by Cenes_Dev on 06/05/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class EditPersonalDetailsViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var usernameView: UIView!
    
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var currentPasswordView: UIView!
    
    @IBOutlet weak var newPasswordView: UIView!
    @IBOutlet weak var editDetailsTableView: UITableView!
    
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var currentPasswordTExtField: UITextField!
    
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    var loggedInUser: User!;
    var seagueafor: String = "";
    var username: String = "";
    var newPassword: String = "";

    var passwordViewFrame: CGRect = CGRect();
    var passwordViewFrameWithoutCurrentPassword: CGRect = CGRect();

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = themeColor;
        editDetailsTableView.backgroundColor = themeColor;
        
        loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        
        editDetailsTableView.register(UINib.init(nibName: "UsernameTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "UsernameTableViewCell")
        editDetailsTableView.register(UINib.init(nibName: "PasswordTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PasswordTableViewCell")
        
        setupNavigationBarItems();
        
        var headerHeight = (self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.size.height;
        //passwordViewFrame = CGRect.init(0, headerHeight, view.frame.width, passwordView.frame.height);
        
        self.title = seagueafor;
        
        self.hideKeyboardWhenTappedAround();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        /*if (seagueafor == "Username") {
            //passwordView.isHidden = true;
        } else if (seagueafor == "Password") {
            usernameView.isHidden = true;
            usernameView.frame = CGRect.init(0, 0, 0, 0);
            //passwordView.frame = passwordViewFrame
        }*/
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func setupNavigationBarItems() {
        
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Cancel", for: .normal)
        closeButton.titleLabel?.font = UIFont(name: "Avenir Medium", size: 17)!
        closeButton.frame = CGRect(x: 0, y: 0, width: 50, height: 20);
        closeButton.addTarget(self, action: #selector(cancelEditProfile), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButton);
        
        
        /*let saveButton = UIButton(type: .system)
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.font = UIFont(name: "Avenir Medium", size: 17)!
        saveButton.frame = CGRect(x: 0, y: 0, width: 50, height: 20);
        saveButton.addTarget(self, action: #selector(cancelEditProfile), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton);*/
    }

    func showHideSaveButtom(isHidden: Bool) {
    
        if (isHidden == true) {
            self.navigationItem.rightBarButtonItem = nil;
        } else {
            let saveButton = UIButton(type: .system)
            saveButton.setTitle("Save", for: .normal)
            saveButton.titleLabel?.font = UIFont(name: "Avenir Medium", size: 17)!
            saveButton.frame = CGRect(x: 0, y: 0, width: 50, height: 20);
            //saveButton.addTarget(self, action: #selector(saveUserDetails), for: .touchUpInside)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton);
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        
        let tag: Int = textField.tag;
        if (seagueafor == "Username") {
            username = textField.text!;
            if (username != "") {
                saveUserDetails();
            }
        } else {
            if (tag == 2) {
                confirmPasswordTextField.becomeFirstResponder();
            }
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("Pressed...");
        return true;
    }
    
    @objc func cancelEditProfile() {
        self.navigationController?.popViewController(animated: true);
    }
    
    func saveUserDetails() {
        if (seagueafor == "Username") {
            var postData: [String: Any] = [String: Any]();
            postData["username"] = username;
            postData["userId"] = loggedInUser.userId;
            loggedInUser.name = username;
            User().updateUserValuesInUserDefaults(user: self.loggedInUser);

            DispatchQueue.global(qos: .background).async {
                UserService().postUserDetails(postData: postData, token: self.loggedInUser.token, complete: {(response) in
                    //User().updateUserValuesInUserDefaults(user: self.loggedInUser);
                });
                
                DispatchQueue.main.async {
                    // Go back to the main thread to update the UI.
                    self.navigationController?.popViewController(animated: true);
                }
            }
        } else if (seagueafor == "Password") {
            var postData: [String: Any] = [String: Any]();
            postData["newPassword"] = newPassword;
            postData["userId"] = loggedInUser.userId;
            loggedInUser.password = newPassword;
            User().updateUserValuesInUserDefaults(user: self.loggedInUser);
            
            DispatchQueue.global(qos: .background).async {
                UserService().postUserDetails(postData: postData, token: self.loggedInUser.token, complete: {(response) in
                    //User().updateUserValuesInUserDefaults(user: self.loggedInUser);
                });
                
                DispatchQueue.main.async {
                    // Go back to the main thread to update the UI.
                    self.navigationController?.popViewController(animated: true);
                }
            }
        }
    }
}

extension EditPersonalDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (seagueafor == "Username") {
            let cell: UsernameTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UsernameTableViewCell") as! UsernameTableViewCell;
            cell.nameTextField.text = loggedInUser.name!;
            cell.editPersonalDetailsViewControllerDelegate = self;
            return cell;
        } else if (seagueafor == "Password") {
            let cell: PasswordTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PasswordTableViewCell") as! PasswordTableViewCell;
            
            cell.editPersonalDetailsViewControllerDelegate = self;
            if (loggedInUser.password == nil || loggedInUser.password == "") {
                cell.currentPasswordField.isHidden = true;
                cell.newPasswordField.placeholder = "Choose a Password";

                cell.newPasswordField.frame = CGRect.init(x: 0, y: 0, width: cell.frame.width, height: cell.newPasswordField.frame.height)
                cell.confirmPasswordField.frame = CGRect.init(x: 0, y: 60, width: cell.frame.width, height: cell.confirmPasswordField.frame.height)
                cell.passwordDescriptionText.frame = CGRect.init(x: 20, y: 140, width: cell.frame.width - 40, height: cell.passwordDescriptionText.frame.height)
                cell.newPasswordField.becomeFirstResponder();
            }
            return cell;
        }
        return UITableViewCell();
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (seagueafor == "Username") {
            return 60;
        } else if (seagueafor == "Password") {
            if (loggedInUser.password == nil || loggedInUser.password == "") {
                return 200;
            } else {
                return 300;
            }
        }
        return 0
    }
}
