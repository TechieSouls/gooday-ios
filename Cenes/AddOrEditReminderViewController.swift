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
    var selectedUsers: [CenesUser] = [] {
        didSet {
            reloadFriends()
        }
    }
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var reminderTitleTextfield: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var peopleTextField: UITextField!
    @IBOutlet weak var friendsCollectionView: UICollectionView!
    
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
    
    func reloadFriends() {
        if selectedUsers.count > 0 {
            friendsCollectionView.isHidden = false
        }
        else {
            friendsCollectionView.isHidden = true
        }
    }
    
    func scheduleReminder(returnedDict: NSMutableDictionary)
    {
        let remindersScheduler = Reminders()
        let responseDict = returnedDict.object(forKey: "data") as! NSDictionary
        let reminderID = String(describing: responseDict.object(forKey: "reminderId") as! NSNumber)
        let notificationIdentier = String(format:"Reminder%@",reminderID)
        let reminderTitle = responseDict.object(forKey: "title")
       
        
        remindersScheduler.scheduleNotification(at: self.selectedDate, identifier: notificationIdentier, reminderTitle: reminderTitle as! String)
    }
    
    @IBAction func deleteReminder(_ sender: Any) {
        startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))
        
        WebService().removeReminder(reminderID: String(describing: self.selectedReminder.reminderID as NSNumber)) { (returnedDict) in
            if returnedDict["Error"] as? Bool == true {
                self.stopAnimating()
                self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
            }else{
                self.stopAnimating()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func deleteReminderScheduledNotification(having identifier: String) {
        let remindersScheduler = Reminders()
        let identifiers: [String] = [identifier]
        remindersScheduler.removeNotification(identifiers: identifiers)
    }
    
    @IBAction func saveReminder(_ sender: Any) {
        
        if self.reminderTitleTextfield.text == "" {
            self.showAlert(title: "Error", message: "Please add Title to reminder.")
            return
        }
//        if self.locationTextField.text == "" {
//            self.showAlert(title: "Error", message: "Please choose a locaiton for reminder.")
//            return
//        }
//        if self.selectedDate == nil {
//            self.showAlert(title: "Error", message: "please choose time for reminder.")
//            return
//        }
        
        let userid = setting.value(forKey: "userId") as! NSNumber
        let uid = "\(userid)"
        
        //"location":self.locationTextField.text!, "reminderTime":"\(self.selectedDate.millisecondsSince1970)"
        
        var dict: [String: Any] = ["category":"Important","title":self.reminderTitleTextfield.text!,"createdById":uid]
        
        if let location = self.locationTextField.text {
            dict["location"] = location
        }
      
        
        
        if let date = self.selectedDate {
            dict["reminderTime"] = "\(date.millisecondsSince1970)"
        }
        
        startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))
        
        if selectedUsers.count > 0 {
            dict["reminderMembers"] = updateUsers()
        }
        
        if isEdit {
            dict["reminderId"] = String(describing: selectedReminder.reminderID as NSNumber)
            
            let reminderID = String(describing: selectedReminder.reminderID as NSNumber)
            let notificationIdentier = String(format:"Reminder%@",reminderID)
            
            deleteReminderScheduledNotification(having: notificationIdentier)
        }
        
        WebService().addReminder(uploadDict: dict, complete: { (returnedDict) in
            
            if returnedDict.value(forKey: "Error") as? Bool == true {
                self.stopAnimating()
                self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                
            }else{
                self.stopAnimating()
                
                if self.dateTextField.text!.count > 0 {
                    self.scheduleReminder(returnedDict: returnedDict)
                }
                if self.isEdit {
                    self.navigationController?.popViewController(animated: true)
                }else{
                self.dismiss(animated: true, completion: nil)
                }
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
        datePicker.minimumDate = Date()
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
        
        //Configure Reminder TextField
        configureTextField(withImage: #imageLiteral(resourceName: "pencil"), textfield: reminderTitleTextfield)
        
        //Configure Date TextField
        dateTextField.inputView = getPickerForDate()
        dateTextField.inputAccessoryView = createInputAccessoryView()
        configureTextField(withImage: #imageLiteral(resourceName: "clockIcon"), textfield: dateTextField)
        
        //Configure Location TextField
        configureTextField(withImage: #imageLiteral(resourceName: "locationIcon"), textfield: locationTextField)
        
        //Configure People TextField
        configureTextField(withImage: #imageLiteral(resourceName: "profile"), textfield: peopleTextField)
    }

    func populateData()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, h:mm a"
        
        if(selectedReminder.reminderTime != nil )
        {
        selectedDateStr = dateFormatter.string(from: Util.getDateFromTimestamp(timeStamp: selectedReminder.reminderTime))
        selectedDate = Util.getDateFromTimestamp(timeStamp: selectedReminder.reminderTime)
        }
        else
        {
         selectedDateStr = ""
        }
        
        reminderTitleTextfield.text = selectedReminder.title
        locationTextField.text = selectedReminder.location
        dateTextField.text = selectedDateStr
        
        selectedUsers = selectedReminder.friends
    }
    
    func configureNavigationBar() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        let gradient = CAGradientLayer()
        gradient.frame = (self.navigationController?.navigationBar.bounds)!
        gradient.colors = [UIColor(red: 244/255, green: 106/255, blue: 88/255, alpha: 1).cgColor,UIColor(red: 249/255, green: 153/255, blue: 44/255, alpha: 1).cgColor]
        gradient.locations = [1.0,0.3]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.navigationController?.navigationBar.setBackgroundImage(cenesDelegate.creatGradientImage(layer: gradient), for: .default)
    }
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.groupTableViewBackground
        
        title = "Add Reminder"
        
        configureUI()
        
        configureNavigationBar()
        
        if isEdit {
            populateData()
            deleteButton.isHidden = false
        }
        else {
            deleteButton.isHidden = true
        }
        
        self.friendsCollectionView.register(UINib(nibName: "FriendsViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "friendCell")
        
        reloadFriends()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        
        self.reminderTitleTextfield.resignFirstResponder()
        
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
        print(textField.text!)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField.text!)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}

extension AddOrEditReminderViewController: SelectedLocationDelegate {
    func selectedLocation(location: LocationModel,url : String!) {
        self.selectedLocation = location
        locationTextField.text = location.locationName
    }
}

extension AddOrEditReminderViewController: SelectUsersDelegate {
    func selectUser(user: CenesUser) {
        selectedUsers.append(user)
        
        friendsCollectionView.reloadData()
    }
}

extension AddOrEditReminderViewController : UICollectionViewDataSource ,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendCell", for: indexPath) as! FriendsViewCell
        
        let friend = selectedUsers[indexPath.row]
        
        cell.nameLabel.text =  friend.name
        cell.addGestureRecognizer(longPressGesture())
        
        cell.tag = indexPath.row
        cell.crossButotn.tag = indexPath.row
        cell.delegate = self
        
        cell.crossButotn.isHidden = true
        cell.backWhiteView.isHidden = true
        
        let photoUrl1 = friend.photoUrl
        
        if photoUrl1 != nil {
            WebService().profilePicFromFacebook(url: photoUrl1!, completion: { image in
                cell.profileImage.image = image
            })
        }else{
            cell.profileImage.image = #imageLiteral(resourceName: "profile icon")
        }
        return cell
        
    }
    
    func longPressGesture() -> UILongPressGestureRecognizer {
        let lpg = UILongPressGestureRecognizer(target: self, action: #selector(AddOrEditReminderViewController.longPress))
        lpg.minimumPressDuration = 0.5
        return lpg
    }
    
    @objc func longPress(_ sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began {
            let cell = sender.view as! FriendsViewCell
            
            cell.crossButotn.isHidden = false
            cell.backWhiteView.isHidden = false
            
            cell.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
            
            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .curveLinear, animations: {
                
                cell.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
                
            }, completion:{(success) in
                
            })
        }
    }
    
}

extension AddOrEditReminderViewController: DeleteFriendDelegate {
    func deleteCell(cell: FriendsViewCell) {
        self.selectedUsers.remove(at: cell.tag)
        self.friendsCollectionView.reloadData()
    }
}



