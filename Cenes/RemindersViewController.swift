//
//  RemindersViewController.swift
//  Cenes
//
//  Created by Chinna Addepally on 10/27/17.
//  Copyright © 2017 Redblink Pvt Ltd. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SideMenu

class RemindersViewController: BaseViewController,NVActivityIndicatorViewable {
    
    @IBOutlet weak var remindersTableView: UITableView!
    
    var profileImage = UIImage(named: "profile icon")
    
    var openReminders: [ReminderModel] = []
    var closedReminders: [ReminderModel] = []
    
    var selectedIndex = -1
    
    //MARK:- Reminder Services
    func fetchReminders() {

//        self.remindersTableView.reloadData()
        
        let webservice = WebService()
      //  self.startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))

        webservice.getReminders { (returnedDict) in
            self.stopAnimating()
            print(returnedDict)
            if returnedDict["Error"] as? Bool == true {
                self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
            }
            else {
                
                self.openReminders.removeAll()
                self.closedReminders.removeAll()
                
                self.parseReminders(reminders: returnedDict["data"] as! Array)
            }
        }
    }
    
    //Delete Reminder
    func deleteReminder(reminder: ReminderModel, indexpath: IndexPath) {
        startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))
        
        WebService().removeReminder(reminderID: String(describing: reminder.reminderID as NSNumber)) { (returnedDict) in
            if returnedDict["Error"] as? Bool == true {
                self.stopAnimating()
                self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
            }else{
                self.stopAnimating()
                if indexpath.section == 0 {
                    self.openReminders.remove(at: indexpath.row)
                }
                else {
                    self.closedReminders.remove(at: indexpath.row)
                }
                self.remindersTableView.reloadData()
                //                self.remindersTableView.deleteRows(at: [indexpath], with: )
            }
        }
    }
    
    func updateInviteStatus(responseDict: [String: Any], status: String) {
        
        let userid = setting.value(forKey: "userId") as! NSNumber

        var reminderMemberID = ""
        
        if let friends = responseDict["reminderMembers"] as? [[String: Any]] {
            for member in friends {
                if userid == member["memberId"] as! NSNumber {
                    let memberID = member["reminderMemberId"] as! NSNumber
                    reminderMemberID = "\(memberID)"
                    break
                }
            }
            
            WebService().updateReminderInviteStatus(memeberID: reminderMemberID, inviteStatus: status, complete: { (statusResponseDict) in
                print(statusResponseDict)
                
                if responseDict["Error"] as? Bool == true {
                    self.stopAnimating()
                    self.showAlert(title: "Error", message: (responseDict["ErrorMsg"] as? String)!)
                }
                else {
                    self.stopAnimating()
                   self.fetchReminders()
                }
            })
        }
    }
    
    //Accept Invitation
    func acceptOrDeclineInvitation(forReminder reminderID: NSNumber, status: String)
    {
        if(status == "")
        {
            return
        }
        
        startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))
        
        WebService().acceptReminderInvite(reminderId: String(describing: reminderID as NSNumber)) { (responseDict) in
            print(responseDict)
            
            if responseDict["Error"] as? Bool == true {
                self.stopAnimating()
                self.showAlert(title: "Error", message: (responseDict["ErrorMsg"] as? String)!)
            }
            else {
                self.updateInviteStatus(responseDict: responseDict["data"] as! [String: Any], status: status)
//                self.stopAnimating()
                print(responseDict)
            }
        }
    }
    
    //Update Invite Status
    
    
    //Update Reminder to Closed State
    func updateReminderToClosedState(indexpath: IndexPath) {
        startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))
        
        let reminder = openReminders[indexpath.row]
        
        WebService().deleteReminder(reminderId: String(describing: reminder.reminderID as NSNumber)) { (returnedDict) in
            if returnedDict.value(forKey: "Error") as? Bool == true {
                self.stopAnimating()
                self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                
            }else{
                print(returnedDict)
                self.stopAnimating()
                
                self.openReminders.remove(at: indexpath.row)
                self.closedReminders.append(reminder)
                
                self.remindersTableView.reloadData()
            }
        }
    }
    
    //MARK:- Reminder Helper Functions
    @objc func closeReminderFromDetailCell(_sender: Any) {
        let reminderButton = _sender as! UIButton
        guard let cell = reminderButton.superview?.superview as? ReminderDetailTableViewCell else {
            return // or fatalError() or whatever
        }
        
        guard let indexpath = remindersTableView.indexPath(for: cell) else {
            return
        }
        
        guard indexpath.section == 0 else {
            return
        }
        updateReminderToClosedState(indexpath: indexpath)
    }
    
    @IBAction func closeReminder(_ sender: Any) {
        
        let reminderButton = sender as! UIButton
        guard let cell = reminderButton.superview?.superview as? RemindersTableViewCell else {
            return // or fatalError() or whatever
        }
        
        guard let indexpath = remindersTableView.indexPath(for: cell) else {
            return
        }
        
        guard indexpath.section == 0 else {
            return
        }
        
        updateReminderToClosedState(indexpath: indexpath)
    }
    
    func getDateFromTimestamp(timeStamp:NSNumber) -> String{
        let timeinterval : TimeInterval = timeStamp.doubleValue / 1000 // convert it in to NSTimeInteral
        let dateFromServer = NSDate(timeIntervalSince1970:timeinterval) // you can the Date object from here
        let dateFormatter = DateFormatter()
        //.dateFormat = "h:mm a"
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var date = dateFormatter.string(from: dateFromServer as Date).capitalized
        
        let dateobj = dateFormatter.date(from: date)
        
        
        dateFormatter.dateFormat = "dd MMM, hh:mm"
        //        dateFormatter.timeStyle = .short
        date = dateFormatter.string(from: dateFromServer as Date).capitalized
        if NSCalendar.current.isDateInToday(dateobj!) == true {
            date = "TODAY \(date)"
        }else if NSCalendar.current.isDateInTomorrow(dateobj!) == true {
            date = "TOMORROW \(date)"
        }
        return date
    }
    
    @objc func showReminderDetail(sender: UIButton) {
        self.performSegue(withIdentifier: "showDetail", sender: nil)
    }
    
    @objc func showTableViewIsEditing() {
        if self.navigationItem.leftBarButtonItem?.title == "Edit" {
            remindersTableView.isEditing = true
            self.navigationItem.leftBarButtonItem?.title = "Done"
        }
        else {
            remindersTableView.isEditing = false
            self.navigationItem.leftBarButtonItem?.title = "Edit"
        }
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
        remindersTableView.backgroundColor = UIColor.white
        
        configureNavigationBar()
        
        //let editButton = UIBarButtonItem.init(title: "Edit", style: .done, target: self, action: #selector(showTableViewIsEditing))
       // self.navigationItem.leftBarButtonItem = editButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.profileImage = appDelegate?.getProfileImage()
        
        if SideMenuManager.default.menuLeftNavigationController?.isHidden == true{
//        openReminders.removeAll()
//        closedReminders.removeAll()
        
            fetchReminders()
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.setUpNavBar()
    }
    
    
    @objc func profileButtonPressed(){
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
        // self.performSegue(withIdentifier: "openSideMenu", sender: self)
    }
    
    
    func setUpNavBar(){
        let profileButton = UIButton.init(type: .custom)
        self.profileImage = appDelegate?.getProfileImage()
        // let image = self.profileImage?.compressImage(newSizeWidth: 35, newSizeHeight: 35, compressionQuality: 1.0)
        profileButton.frame = CGRect.init(x: 0, y: 0, width: 35, height: 35)
        profileButton.imageView?.contentMode = .scaleAspectFill
        profileButton.setImage(self.profileImage, for: UIControlState.normal)
        profileButton.layer.cornerRadius = profileButton.frame.height/2
        profileButton.clipsToBounds = true
        profileButton.backgroundColor = UIColor.white
        profileButton.widthAnchor.constraint(equalToConstant: 35.0).isActive = true
        profileButton.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        profileButton.addTarget(self, action: #selector(RemindersViewController.profileButtonPressed), for: .touchUpInside)
        
        
        let barButton = UIBarButtonItem.init(customView: profileButton)
        self.navigationItem.leftBarButtonItem = barButton
        
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
        if segue.identifier == "showDetail" {
            let selectedReminder = openReminders[selectedIndex]
            let reminderDetail = segue.destination as? AddOrEditReminderViewController
            reminderDetail?.isEdit = true
            reminderDetail?.selectedReminder = selectedReminder
        }
    }
    
    //MARK:- Parse Reminders
    func parseReminders(reminders: [[String: Any]])
    {
        for reminder in reminders {
            let reminderModel = ReminderModel()
            
            if let reminderID = reminder["reminderId"] as? NSNumber {
                reminderModel.reminderID = reminderID
            }
            
            if let category = reminder["category"] as? String {
                reminderModel.category = category
            }
            
            if let title = reminder["title"] as? String {
                reminderModel.title = title
            }
            
            if let createdById =  reminder["createdById"] as? NSNumber {
                reminderModel.createdByID = createdById
            }
            
            if let location = reminder["location"] as? String {
                reminderModel.location = location
            }
            
            if let status =  reminder["status"] as? String {
                reminderModel.status = status
            }
            
            
            
            if let reminderTime = reminder["reminderTime"] as? NSNumber
            {
                reminderModel.reminderTime = reminderTime
            }
            
            if let friends = reminder["reminderMembers"] as? [[String: Any]] {
                for friend in friends {

                    let cenesUser = CenesUser()
                    
                    if let userName = friend["name"] as? String {
                        cenesUser.name = userName
                    }
                    
                    if let photoURL = friend["picture"] as? String {
                        cenesUser.photoUrl = photoURL
                    }
                    
                    if let memberID = friend["memberId"] as? NSNumber {
                        cenesUser.userId = String(describing: memberID as NSNumber)
                    }
                    reminderModel.friends.append(cenesUser)
                }
            }
            
            if reminderModel.status == "Start" {
                openReminders.append(reminderModel)
            }
            else {
                closedReminders.append(reminderModel)
            }
        }
        remindersTableView.reloadData()
    }
}
