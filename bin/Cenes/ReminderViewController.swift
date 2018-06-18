//
//  ReminderViewController.swift
//  Cenes
//
//  Created by Sabita Rani Samal on 7/28/17.
//  Copyright © 2017 Sabita Rani Samal. All rights reserved.
//

import UIKit
import IoniconsSwift
import ActionButton
import NVActivityIndicatorView

class ReminderViewController: BaseViewController,NVActivityIndicatorViewable{

    @IBOutlet weak var tableView: UITableView!
    var name:String?
     var profileImage = UIImage(named: "profile icon")
    
    @IBOutlet weak var reminderIcon: UIImageView!
    
    @IBOutlet weak var filterButton: UIButton!
    
    
    
    var urgentDict = NSMutableDictionary()
    var importantDict = NSMutableDictionary()
    var todoDict = NSMutableDictionary()
    var doneDict = NSMutableDictionary()
    
    var sectionDict = [NSMutableDictionary]()
    
    var urgentData = [NSMutableDictionary]()
    var importantData = [NSMutableDictionary]()
    var todoData = [NSMutableDictionary]()
    var doneData = [NSMutableDictionary]()
    
    var tempBool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradient = CAGradientLayer()
        gradient.frame = (self.navigationController?.navigationBar.bounds)!
        gradient.colors = [UIColor(red: 244/255, green: 106/255, blue: 88/255, alpha: 1).cgColor,UIColor(red: 249/255, green: 153/255, blue: 44/255, alpha: 1).cgColor]
        gradient.locations = [1.0,0.3]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.navigationController?.navigationBar.setBackgroundImage(cenesDelegate.creatGradientImage(layer: gradient), for: .default)
        
        urgentDict["show"] = false
        importantDict["show"] = false
        todoDict["show"] = false
        doneDict["show"] = false
        
        
        urgentDict["data"] = urgentData
        importantDict["data"] = importantData
        todoDict["data"] = todoData
        doneDict["data"] = doneData
        
        
        sectionDict =  [urgentDict,importantDict,todoDict,doneDict]
        // Do any additional setup after loading the view.
        
        
        let nib = UINib(nibName: "ReminderHeaderView", bundle: Bundle.main)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "ReminderViewCellTwo")
        
        
        
        if(setting.value(forKey: "photo") != nil)
        {
            let webServ = WebService()
            webServ.profilePicFromFacebook(url: setting.value(forKey: "photo")! as! String, completion: { image in
                self.profileImage = image
                self.setUpNavBarImages()
            })
        }
        
        reminderIcon.image =    Ionicons.iosFilingOutline.image(25, color: UIColor.darkGray)
        filterButton.setImage(Ionicons.statsBars.image(20), for: UIControlState.normal)
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func profileButtonPressed(){
        let settingsView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsView") as! SettingsViewController
        settingsView.image = self.profileImage
        
        self.navigationController?.pushViewController(settingsView, animated: true)
    }
    
    
    @IBAction func filterButtonPressed(_ sender: UIButton) {
        
    }
    
    
    func setUpNavBarImages() {
        
        let profileButton = UIButton.init(type: .custom)
        let image = self.profileImage?.compressImage(newSizeWidth: 35, newSizeHeight: 35, compressionQuality: 1.0)
        profileButton.setImage(image, for: UIControlState.normal)
        profileButton.frame = CGRect.init(x: 0, y: 0, width: 35, height: 35)
        profileButton.layer.cornerRadius = profileButton.frame.height/2
        profileButton.clipsToBounds = true
        profileButton.addTarget(self, action:#selector(profileButtonPressed), for: UIControlEvents.touchUpInside)
        
        
        let barButton = UIBarButtonItem.init(customView: profileButton)
        self.navigationItem.leftBarButtonItem = barButton
        
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /*
        actionButton = ActionButton(attachedToView:self.view, items: [])
        actionButton?.action = { button in self.createReminder() }
        //self.confirmedButtonPressed(UIButton())
        self.doneData.removeAll(keepingCapacity: true)
        self.todoData.removeAll(keepingCapacity: true)
        self.urgentData.removeAll(keepingCapacity: true)
        self.importantData.removeAll(keepingCapacity: true)
        self.tableView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        let webservice = WebService()
        let hud = MBProgressHUD.showAdded(to: self.view.window!, animated: true)
        hud.label.text = "Loading..."
        hud.bezelView.color = UIColor.black
        hud.contentColor = UIColor.white
        
            
        
        
        webservice.getReminders { (returnedDict) in
            let hud = MBProgressHUD(for: self.view.window!)
            hud?.hide(animated: true)
            if returnedDict.value(forKey: "Error") as? Bool == true {
                
                self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                
            }else{
                self.parseResults(resultArray: (returnedDict["data"] as? NSArray)!)
            }
        }
        }*/
        
        
    }
    
    func sectionPressed(section : Int , hide :Bool){
        let indices: IndexSet = [section]
        
            let dict = self.sectionDict[section]
            
            dict["show"] = hide
            self.tableView.reloadSections(indices, with: UITableViewRowAnimation.automatic)
        
        
    }
    
    func parseResults(resultArray:NSArray){
        for result in resultArray {
            let data = result as! NSDictionary
            var category : String!
            
            category = data["category"] as? String
            if (category == nil){
                category = "important"
            }
            if category == "important"{
                
                let data = NSMutableDictionary(dictionary: data)
                importantData.append(data)
                self.importantDict["data"] = importantData
                
                
            }else if category == "urgent"{
                
                let data = NSMutableDictionary(dictionary: data)
                urgentData.append(data)
                self.urgentDict["data"] = urgentData
            }else if category == "todo"{
                let data = NSMutableDictionary(dictionary: data)
                todoData.append(data)
                self.todoDict["data"] = todoData
            }else if category == "done"{
                let data = NSMutableDictionary(dictionary: data)
                doneData.append(data)
                self.doneDict["data"] = doneData
            }
        }
        
        self.tableView.reloadData()
    }
    
    func createReminder(){
        
        let createReminderView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "createReminderView") as! CreateReminderViewController
        self.navigationController?.pushViewController(createReminderView, animated: true)
       
    }
    
   
    
}


    extension ReminderViewController : UITableViewDelegate,UITableViewDataSource {
        
        
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return sectionDict.count
        }
        
        
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell:ReminderViewCell = tableView.dequeueReusableCell(withIdentifier: "ReminderViewCell")! as! ReminderViewCell
            cell.tintColor = commonColor
            
            
            let dict = self.sectionDict[indexPath.section]
            
            let dataArray = dict.value(forKey: "data") as! NSArray
            
            let dataShowHide = dict.value(forKey: "show") as! Bool
            
            let dict2 = dataArray[indexPath.row] as! NSDictionary
            
            cell.reminderTitle.text = dict2.value(forKey: "title") as! String
            // reminderDataDetail[indexPath.row].name
            return cell
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
             //reminderDataDetail.count
            
            
            let dict = self.sectionDict[section]
            
            let dataArray = dict.value(forKey: "data") as! NSArray
            
            let dataShowHide = dict.value(forKey: "show") as! Bool
            
            
            if dataShowHide == true {
                return dataArray.count
            }else{
                return 0
            }
            
            
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 44
        }
        
        func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return 0.01
        }
        
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("inside deleting reminder")
            DispatchQueue.main.async {
            
            let actionSheetController = UIAlertController(title: "Alert", message: "Have your reminder finished?", preferredStyle: .alert)
            
            let OKButtonAction = UIAlertAction(title: "Yes", style: .default) { action -> Void in
              self.removeOrFinishReminder(indexPath: indexPath)
            }
            
            let cancelAction = UIAlertAction(title: "No", style: .cancel) { action -> Void in
            }
            
            actionSheetController.addAction(OKButtonAction)
            actionSheetController.addAction(cancelAction)
            
            self.present(actionSheetController, animated: true, completion: nil)
            }
        }
        
        func removeOrFinishReminder(indexPath:IndexPath){
            
            startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))
            let dict = self.sectionDict[indexPath.section]
            
            let dataArray = dict.value(forKey: "data") as! NSArray
            
            let dict2 = dataArray[indexPath.row] as! NSDictionary
            
           let reminderId = "\(dict2.value(forKey: "reminderId") as! NSNumber)"
            
            WebService().deleteReminder(reminderId: reminderId) { (returnedDict) in
                if returnedDict.value(forKey: "Error") as? Bool == true {
                    self.stopAnimating()
                    self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                    
                }else{
                    print(returnedDict)
                    self.stopAnimating()
                    
                    self.tableView.beginUpdates()
                    
                    if indexPath.section == 0 {
                        self.urgentData.remove(at: indexPath.row)
                        self.urgentDict["data"] = self.urgentData
                        self.sectionDict =  [self.urgentDict,self.importantDict,self.todoDict,self.doneDict]
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                        self.tableView.endUpdates()
                    }else if indexPath.section == 1 {
                        self.importantData.remove(at: indexPath.row)
                        self.importantDict["data"] = self.importantData
                        self.sectionDict =  [self.urgentDict,self.importantDict,self.todoDict,self.doneDict]
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                        self.tableView.endUpdates()
                    }else if indexPath.section == 2 {
                        self.todoData.remove(at: indexPath.row)
                        self.todoDict["data"] = self.todoData
                        self.sectionDict =  [self.urgentDict,self.importantDict,self.todoDict,self.doneDict]
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                        self.tableView.endUpdates()
                    }else{
                        self.doneData.remove(at: indexPath.row)
                        self.doneDict["data"] = self.doneData
                        self.sectionDict =  [self.urgentDict,self.importantDict,self.todoDict,self.doneDict]
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                        self.tableView.endUpdates()
                    }
                    
                }
            }
        }
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            
            print("Section Header Calls \(section)")
            var sectionTitle = ""
            
            var color : UIColor!
            
            switch section {
            case 0:
                sectionTitle = "Urgent"
                color = UIColor.red
                break
            case 1 :
                sectionTitle = "Important"
                color = commonColor
                break
            case 2:
                sectionTitle = "Todo"
                color = UIColor.cyan
                break
            case 3 :
                sectionTitle = "Done"
                color = UIColor.darkGray
                break
            default:
                print("nothing")
                break
            }

            
            let identifier = "ReminderViewCellTwo"
            let cell: ReminderViewCellTwo! =  tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) as! ReminderViewCellTwo
            
            cell.headerTitle.text = sectionTitle
            cell.colorView.backgroundColor = color
            cell.section = section
            cell.reminderView = self
            cell.contentView.backgroundColor = UIColor.white
            let dict = self.sectionDict[section]
            
            let dataShowHide = dict.value(forKey: "show") as! Bool
            
            
            if dataShowHide == true {
                cell.headerButton.isSelected = true
            }else{
                cell.headerButton.isSelected = false
            }
            
            return cell             
        }
        
        
        
    }

