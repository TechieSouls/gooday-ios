//
//  CreateReminderViewController.swift
//  Cenes
//
//  Created by Redblink on 25/09/17.
//  Copyright © 2017 Redblink Pvt Ltd. All rights reserved.
//

import UIKit
import IoniconsSwift
import NVActivityIndicatorView

class CreateReminderViewController: UIViewController , CreateReminderCellTwoDelegate,NVActivityIndicatorViewable {

    
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var reminderIcon: UIImageView!
    @IBOutlet weak var createReminderTableView: UITableView!
    
    var locationName = ""
    var FriendArray = [CenesUser]()
    var timeExpand = false
    
    var reminderTitle = ""
    var reminderCategory = "" // default category
    var selectedDate : Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        createReminderTableView.register(UINib(nibName: "CreateReminderCellOne", bundle: Bundle.main), forCellReuseIdentifier: "CreateReminderCellOne")
        createReminderTableView.register(UINib(nibName: "CreateReminderCellTwo", bundle: Bundle.main), forCellReuseIdentifier: "CreateReminderCellTwo")
        createReminderTableView.register(UINib(nibName: "CreateReminderCellThree", bundle: Bundle.main), forCellReuseIdentifier: "CreateReminderCellThree")
        createReminderTableView.register(UINib(nibName: "CreateReminderCellFour", bundle: Bundle.main), forCellReuseIdentifier: "CreateReminderCellFour")
        createReminderTableView.tableFooterView = UIView()
        
         reminderIcon.image =    Ionicons.iosFilingOutline.image(25, color: UIColor.darkGray)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CreateReminderViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CreateReminderViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.createReminderTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    @IBAction func saveReminderButtonPressed(_ sender: Any) {
        
        if self.reminderTitle == "" {
            self.showAlert(title: "Error", message: "Please add Title to reminder.")
            return
        }
        if self.reminderCategory == "" {
            self.showAlert(title: "Error", message: "Please add a category i.e \"important\" \"urgent\" \"todo\".")
            return
        }
        if self.locationName == "" {
            self.showAlert(title: "Error", message: "Please choose a locaiton for reminder.")
            return
        }
        if self.selectedDate == nil {
            self.showAlert(title: "Errpr", message: "please choose time for reminder.")
            return
        }
        
        // save Reminder.
        print(reminderTitle  + "  " + reminderCategory + " " + locationName)
        
        
        var dict : [String:Any]
        
        let userid = setting.value(forKey: "userId") as! NSNumber
        let uid = "\(userid)"
        
        dict = ["category":self.reminderCategory,"title":self.reminderTitle,"createdById":uid,"location":self.locationName,"reminderTime":"\(self.selectedDate.millisecondsSince1970)"]
        startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))
        
        WebService().addReminder(uploadDict: dict, complete: { (returnedDict) in
            
            if returnedDict.value(forKey: "Error") as? Bool == true {
                self.stopAnimating()
                self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                
            }else{
                print(returnedDict)
                self.stopAnimating()
                
                let actionSheetController = UIAlertController(title: "Success", message: "Your Reminder has been created.", preferredStyle: .alert)
                
                let OKButtonAction = UIAlertAction(title: "Ok", style: .default) { action -> Void in
                    print("take")
                    self.navigationController?.popViewController(animated: true)
                }
                actionSheetController.addAction(OKButtonAction)
                
                self.present(actionSheetController, animated: true, completion: nil)
            }
        })
        
        
        
    }
    
    
     func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.tableViewBottomConstraint.constant = keyboardSize.height
            
        }
    }
    
     func keyboardWillHide(notification: NSNotification) {
        self.tableViewBottomConstraint.constant  = 0
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func selectPeople(){
        
        self.navigationController?.navigationBar.barTintColor = UIColor.lightGray
        
        let inviteFriends = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "inviteFriends") as? InviteFriendViewController
        
        inviteFriends?.createReminderView = self
        self.navigationController?.pushViewController(inviteFriends!, animated: true)
    }
    
    func AddLocation(){
        let location = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddLocationViewController") as? AddLocationViewController
        
        location?.createReminderView = self
        
        self.navigationController?.pushViewController(location!, animated: true)
    }
    
    
    
    func expandButtonTApped(indexPath : IndexPath){
        
        self.timeExpand = !self.timeExpand
        
        self.createReminderTableView.beginUpdates()
        
        self.createReminderTableView.endUpdates()
        
        self.createReminderTableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
}
    extension CreateReminderViewController :UITableViewDataSource,UITableViewDelegate
    {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 4
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            var identifier = "TableViewCell"
            
            switch indexPath.row {
            case 0:
                print("")
                identifier = "CreateReminderCellOne"
                let cell: CreateReminderCellOne = (tableView.dequeueReusableCell(withIdentifier: identifier) as? CreateReminderCellOne)!
                cell.createReminderView = self
                
                return cell
                
            case 1:
                print("")
                identifier = "CreateReminderCellTwo"
                let cell: CreateReminderCellTwo = (tableView.dequeueReusableCell(withIdentifier: identifier) as? CreateReminderCellTwo)!
                
                cell.indexPathCell = indexPath
                
                cell.createReminderView = self
                 cell.delegate = self
                cell.cellTabbed = timeExpand
                
                if timeExpand == true {
                    cell.lowerView.isHidden = false
                    cell.expandButton.isSelected = true
                }else{
                    cell.lowerView.isHidden = true
                    cell.expandButton.isSelected = false
                    
                }
                
                return cell
            case 2:
                print("")
                identifier = "CreateReminderCellThree"
                let cell: CreateReminderCellThree = (tableView.dequeueReusableCell(withIdentifier: identifier) as? CreateReminderCellThree)!
                cell.createReminderView = self
                cell.locationField.text = self.locationName
                return cell
            case 3:
                print("")
                identifier = "CreateReminderCellFour"
                let cell: CreateReminderCellFour = (tableView.dequeueReusableCell(withIdentifier: identifier) as? CreateReminderCellFour)!
                
                cell.createReminderView = self
                cell.setShowArray()
                
                if self.FriendArray.count > 0 {
                    cell.lowerView.isHidden = false
                }else{
                    cell.lowerView.isHidden = true
                }
                
                cell.reloadFriends()
                return cell
            
                
            default:
                print("")
                return UITableViewCell()
            }
            
        }
        
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            switch indexPath.row {
            case 0:
                return 78
            case 1:
                
                if self.timeExpand {
                    return 217
                }else{
                    return 40
                }
                
            case 2:
                
            return 44
                
            case 3:
                if self.FriendArray.count > 0 {
                    return 126
                }else{
                    return 44
            }
            default:
                print("")
                return 100
            }
            
        }
        
        
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            switch indexPath.row {
                
            case 0:
                print("")
            case 1:
                print("")
                
                let indexPath1 = IndexPath(row: 0, section: 0)
                
                let cell : CreateReminderCellOne = self.createReminderTableView.cellForRow(at: indexPath1) as! CreateReminderCellOne
                cell.titleTextField.resignFirstResponder()
                
                let cell1 : CreateReminderCellTwo = self.createReminderTableView.cellForRow(at: indexPath) as! CreateReminderCellTwo
                cell1.expandButtonPressed(cell1.expandButton)
                
            case 2:
                print("")
                let indexPath = IndexPath(row: 0, section: 0)
                
                let cell : CreateReminderCellOne = self.createReminderTableView.cellForRow(at: indexPath) as! CreateReminderCellOne
                cell.titleTextField.resignFirstResponder()
                self.AddLocation()
            case 3:
                print("")
                let indexPath = IndexPath(row: 0, section: 0)
                
                let cell : CreateReminderCellOne = self.createReminderTableView.cellForRow(at: indexPath) as! CreateReminderCellOne
                cell.titleTextField.resignFirstResponder()
                self.selectPeople()
            case 4:
                print("")
                
               
            case 5:
                print("")
                
            default:
                print("")
                
            }
        }
    }

