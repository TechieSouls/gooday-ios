//
//  AddOrEditReminderViewController.swift
//  Cenes
//
//  Created by Chinna Addepally on 10/27/17.
//  Copyright © 2017 Redblink Pvt Ltd. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class AddOrEditReminderViewController: BaseViewController, NVActivityIndicatorViewable {
    
    var isEdit: Bool = false
    var selectedReminder: ReminderModel!
    var selectedLocation: LocationModel!
    var selectedUsers: [CenesUser] = []
    
    @IBOutlet weak var reminderTitleTextfield: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var peopleTextField: UITextField!
    
    var selectedDate: Date!
    var selectedDateStr: String!
    
    @IBAction func goBack(_ sender: Any) {
        if isEdit {
            self.navigationController?.popViewController(animated: true)
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func updateUsers() -> [[String: Any]] {
        var user: [String: Any] = [:]
        var users: [[String: Any]] = []
        
        for cenesuser in selectedUsers {
            user["memberId"] = cenesuser.userId
            user["name"] = cenesuser.name
            user["picture"] = cenesuser.photoUrl
            
            users.append(user)
        }
        return users
    }
    
    @IBAction func saveReminder(_ sender: Any) {
        
        if self.reminderTitleTextfield.text == "" {
            self.showAlert(title: "Error", message: "Please add Title to reminder.")
            return
        }
        if self.locationTextField.text == "" {
            self.showAlert(title: "Error", message: "Please choose a locaiton for reminder.")
            return
        }
        if self.selectedDate == nil {
            self.showAlert(title: "Error", message: "please choose time for reminder.")
            return
        }
        
        let userid = setting.value(forKey: "userId") as! NSNumber
        let uid = "\(userid)"
        
        var dict: [String: Any] = ["category":"Important","title":self.reminderTitleTextfield.text!,"createdById":uid,"location":self.locationTextField.text!,
                    "reminderTime":"\(self.selectedDate.millisecondsSince1970)"]
        startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))
        
        if selectedUsers.count > 0 {
            dict["reminderMembers"] = updateUsers()
        }
//        if isEdit {
//            dict["reminderId"] = String(describing: selectedReminder.reminderID as NSNumber)
//        }
        
        
        WebService().addReminder(uploadDict: dict, complete: { (returnedDict) in
            
            if returnedDict.value(forKey: "Error") as? Bool == true {
                self.stopAnimating()
                self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                
            }else{
                self.stopAnimating()
                
                let alertController = UIAlertController(title: "Success", message: "Your Reminder has been created.", preferredStyle: .alert)
                
                let OKButtonAction = UIAlertAction(title: "Ok", style: .default) { action -> Void in
                    print("take")
                    self.dismiss(animated: true, completion: nil)
                }
                alertController.addAction(OKButtonAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        })
    }
    
    @objc func updateDate(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, h:mm a"
        
        selectedDate = datePicker.date
        selectedDateStr = dateFormatter.string(from: datePicker.date)
        
        self.view.resignFirstResponder()
    }
    
    @objc func hideKeyBoard() {
        dateTextField.resignFirstResponder()
    }
    
    @objc func confirmSelectedDate() {
        dateTextField.text = selectedDateStr
        dateTextField.resignFirstResponder()
    }
    
    func createInputAccessoryView() -> UIToolbar{
        let toolbar = UIToolbar.init(frame: CGRect(x:0, y:0, width: UIScreen.main.bounds.size.width, height: 44))
        
        let cancelButton = UIBarButtonItem.init(title: "Cancel", style: .plain, target: self, action: #selector(hideKeyBoard))
        let space = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem.init(title: "Done", style: .plain, target: self, action: #selector(confirmSelectedDate))
        
        toolbar.setItems([cancelButton, space, doneButton], animated: true)
        
        return toolbar
    }
    
    func getPickerForDate() -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width,height: 216)
        datePicker.datePickerMode = .dateAndTime
        datePicker.date = Date()
        datePicker.addTarget(self, action: #selector(updateDate(datePicker:)), for: .valueChanged)
        return datePicker
    }
    
    private func configureTextField(withImage: UIImage, textfield: UITextField) {
        let imageView = UIImageView.init(image: withImage)
        imageView.frame = CGRect(x: 5, y: 0, width: 40, height: 40)
        imageView.contentMode = .center
        
        textfield.leftView = imageView
        textfield.leftViewMode = .always

        textfield.backgroundColor = UIColor.white
    }

    func configureUI() {
        configureTextField(withImage: #imageLiteral(resourceName: "pencil"), textfield: reminderTitleTextfield)
        
        dateTextField.inputView = getPickerForDate()
        dateTextField.inputAccessoryView = createInputAccessoryView()
        configureTextField(withImage: #imageLiteral(resourceName: "clockIcon"), textfield: dateTextField)
        
        configureTextField(withImage: #imageLiteral(resourceName: "locationIcon"), textfield: locationTextField)
        
        configureTextField(withImage: #imageLiteral(resourceName: "profile"), textfield: peopleTextField)
    }
    
    
    func populateData() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, h:mm a"
        selectedDateStr = dateFormatter.string(from: Util.getDateFromTimestamp(timeStamp: selectedReminder.reminderTime))

        reminderTitleTextfield.text = selectedReminder.title
        locationTextField.text = selectedReminder.location
        dateTextField.text = selectedDateStr
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.groupTableViewBackground
        
        title = "Add Reminder"
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        let gradient = CAGradientLayer()
        gradient.frame = (self.navigationController?.navigationBar.bounds)!
        gradient.colors = [UIColor(red: 244/255, green: 106/255, blue: 88/255, alpha: 1).cgColor,UIColor(red: 249/255, green: 153/255, blue: 44/255, alpha: 1).cgColor]
        gradient.locations = [1.0,0.3]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.navigationController?.navigationBar.setBackgroundImage(cenesDelegate.creatGradientImage(layer: gradient), for: .default)
        
        configureUI()
        
        if isEdit {
            populateData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showLocation" {
            let locationNavigationVC = segue.destination as? LocationTableViewController
            locationNavigationVC?.delegate = self
        }
    }
    
}


extension AddOrEditReminderViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == locationTextField {
            self.performSegue(withIdentifier: "showLocation", sender: nil)
            return false
        }
        else if textField == peopleTextField {
            let inviteFriends = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "inviteFriends") as? InviteFriendViewController
            inviteFriends?.delegate = self
            self.navigationController?.pushViewController(inviteFriends!, animated: true)
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}

extension AddOrEditReminderViewController: SelectedLocationDelegate {
    func selectedLocation(location: LocationModel) {
        self.selectedLocation = location
        locationTextField.text = location.locationName
    }
}

extension AddOrEditReminderViewController: SelectUsersDelegate {
    func selectUser(user: CenesUser) {
        selectedUsers.append(user)
    }
}

