//
//  HomeViewController.swift
//  Cenes
//  This class is used after sign in
//  Created by Sabita Rani Samal on 7/12/17.
//  Copyright © 2017 Sabita Rani Samal. All rights reserved.
//

import UIKit
import IoniconsSwift
import FSCalendar
import ActionButton
import NVActivityIndicatorView
import GoogleSignIn
import FBSDKLoginKit
import FacebookCore
import SideMenu
import CoreData


class HomeViewController: BaseViewController ,NVActivityIndicatorViewable{
    
    
    @IBOutlet weak var tableView: UITableView!
   @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var calendarHeight: NSLayoutConstraint!
    
    @IBOutlet weak var monthlyWeeklyButton: UIButton!
    var userImagesInProgress = [String:String]()
    var holidaysData = NSMutableDictionary()
    var objectArray = [CalendarObjects]()
    var dataObjectArray = [CenesEvent]()
    var calendarDataArray = [CalendarData]()
    var sectionArray:[Int]?
    var rowsInSecionArray:[Int]?
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"//"MM/dd/yyyy"
        return formatter
    }()
  
    var profileImage = UIImage(named: "profile icon")
    
//    private let persistentContainer = NSPersistentContainer(name: "Cenes")

    
    class func MainViewController() -> UITabBarController{
        
        let tabController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tab") as! UITabBarController
        tabController.tabBar.items?[0].title = nil
        tabController.tabBar.items?[0].imageInsets = UIEdgeInsetsMake(6,0,-6,0)
        tabController.tabBar.items?[0].titlePositionAdjustment = UIOffsetMake(0, 80)
        tabController.tabBar.items?[1].title = nil
        tabController.tabBar.items?[1].imageInsets = UIEdgeInsetsMake(6,0,-6,0)
        tabController.tabBar.items?[1].titlePositionAdjustment = UIOffsetMake(0, 80)
        tabController.tabBar.items?[2].title = nil
        tabController.tabBar.items?[2].imageInsets = UIEdgeInsetsMake(6,0,-6,0)
        tabController.tabBar.items?[2].titlePositionAdjustment = UIOffsetMake(0, 80)
        tabController.tabBar.items?[3].title = nil
        tabController.tabBar.items?[3].imageInsets = UIEdgeInsetsMake(6,0,-6,0)
        tabController.tabBar.items?[3].titlePositionAdjustment = UIOffsetMake(0, 80)
        tabController.tabBar.items?[4].title = nil
        tabController.tabBar.items?[4].imageInsets = UIEdgeInsetsMake(6,0,-6,0)
        tabController.tabBar.items?[4].titlePositionAdjustment = UIOffsetMake(0, 80)
        cenesDelegate.cenesTabBar = tabController
        tabController.tabBar.tintColor = commonColor
//        tabController.moreNavigationController.navigationBar.tintColor = UIColor.white
//        tabController.moreNavigationController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white
//        ]
        
        return tabController
        
    }
    
    @IBAction func monthlyWeeklyPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            sender.setTitle("switch to monthly view", for: .normal)
            self.calendar.scope = .week
        }else{
            sender.setTitle("switch to weekly view", for: .normal)
            self.calendar.scope = .month
        }
        self.calendar.reloadData()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "CENES"
        self.tabBarItem.title = nil
        
        if appDelegate?.storeLoaded == false {
            appDelegate?.storeLoaded = true
            appDelegate?.loadPersistentContainer()
        }
        
        //let calendar = FSCalendar(frame: CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: 300))
        calendar.tintColor = commonColor
        calendar.appearance.headerTitleColor = UIColor(red: 0/255, green: 67/255, blue: 69/255, alpha: 1)//commonColor
        calendar.appearance.weekdayTextColor = UIColor.darkGray
        calendar.appearance.todaySelectionColor = commonColor
        calendar.appearance.headerTitleFont = UIFont.init(name: "Lato-Regular", size: 18)
        calendar.appearance.titleFont = UIFont.init(name: "Lato-Regular", size: 14)
        calendar.appearance.weekdayFont = UIFont.init(name: "Lato-Regular", size: 16)
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        calendar.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesSingleUpperCase]
        calendar.delegate = self
        calendar.dataSource = self
        //view.addSubview(calendar)
        //self.calendar = calendar
        
        self.calendar.select(Date())
        self.calendar.scope = .month
        //self.calendar.scopeGesture.isEnabled = true
        calendar.placeholderType = FSCalendarPlaceholderType.none
        
       // self.tableTopConstraint.constant = 0
        self.view.layoutIfNeeded()
        
    
        tableView.register(UINib(nibName: "HomeTableViewCellOne", bundle: Bundle.main), forCellReuseIdentifier: "cellOne")
        tableView.register(UINib(nibName: "HomeTableViewCellTwo", bundle: Bundle.main), forCellReuseIdentifier: "cellTwo")
        tableView.register(UINib(nibName: "HomeTableViewCellHeader", bundle: Bundle.main), forCellReuseIdentifier: "HeaderCell")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 58
        tableView.estimatedSectionHeaderHeight = 42
        
    
        let gradient = CAGradientLayer()
        gradient.frame = (self.navigationController?.navigationBar.bounds)!
        gradient.colors = [UIColor(red: 244/255, green: 106/255, blue: 88/255, alpha: 1).cgColor,UIColor(red: 249/255, green: 153/255, blue: 44/255, alpha: 1).cgColor]
        gradient.locations = [1.0,0.3]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.navigationController?.navigationBar.setBackgroundImage(cenesDelegate.creatGradientImage(layer: gradient), for: .default)
        self.calendarTopConstraint.constant = CGFloat(-Int(self.calendar.frame.size.height) - 24)
        self.monthlyWeeklyButton.isHidden = true
        self.calendar.isHidden = true
       // let constraint = Int(self.calendar.frame.size.height)
       // self.tableTopConstraint.constant = CGFloat(constraint)
        
        let gathering = ActionButtonItem(title: "Gathering", image: Ionicons.iosCalendarOutline.image(25, color: UIColor.orange))
        
        gathering.action = { item in print("Sharing...")
            self.actionButton?.toggleMenu()
            self.createGathering()
        }
        
        let reminder = ActionButtonItem(title: "Reminder", image: Ionicons.iosBellOutline.image(25, color: UIColor.orange))
        reminder.action = { item in print("Email...")
            self.actionButton?.toggleMenu()
            self.createReminder()
        }
        
        let alarm = ActionButtonItem(title: "Alarm", image: Ionicons.iosAlarmOutline.image(25, color: UIColor.orange))
        alarm.action = { item in print("Alarm...")
              self.createAlarm()
        }
        
        actionButton = ActionButton(attachedToView: self.view, items: [gathering, reminder,alarm])
        
        
        actionButton?.action = { button in button.toggleMenu() }
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIScreen.main.nativeBounds.height == 2436 {
            print("Iphone x")
            var frame = self.view.frame
            frame.size.height = 772
            self.view.frame = frame
            self.tabBarController?.tabBar.backgroundColor = UIColor.white
        }
        //setUpNavBarImages()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.profileImage = appDelegate?.getProfileImage()
        
       // print("button pressed \((sMenu?.buttonTag)!)")
       
        self.setUpNavBarImages()
        
       
        
    
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.actionButton?.active == true {
        self.actionButton?.toggleMenu()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if SideMenuManager.default.menuLeftNavigationController?.isHidden == true {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                
                
                self.calendar.reloadData()
                self.dataObjectArray.removeAll(keepingCapacity: true)
                self.tableView.reloadData()
                let webservice = WebService()
             //   self.startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))
                
                let str = self.dateFormatter.string(from: Date())
                let forMattedDate = self.dateFormatter.date(from: str)
                
                
                webservice.getHomeEvents(dateString: "\((forMattedDate?.millisecondsSince1970)!)", timeZoneString: "") { (returnedDict) in
                    print("Got results")
                    self.stopAnimating()
                    if returnedDict.value(forKey: "Error") as? Bool == true {
                        
                        self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                        
                    }else{
                        self.parseResults(resultArray: (returnedDict["data"] as? NSArray)!)
                    }
                    
                }
                
//                if self.holidaysData.allKeys.count == 0 {
//                    self.startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))
//                }
                
                
                webservice.getHolidays { (returnedDict) in
//                    if self.holidaysData.allKeys.count == 0 {
//                        self.stopAnimating()
//                    }
                    if returnedDict.value(forKey: "Error") as? Bool == true {
                        
                        self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                        
                    }else{
                        //   print (returnedDict)//self.parseResults(resultArray: (returnedDict["data"] as? NSArray)!)
                        
                        let array = returnedDict["data"] as? NSArray
                        
                        for result in array! {
                            let resultData = result as! NSDictionary
                            
                            
                            let keyNum = resultData.value(forKey: "startTime") as! NSNumber
                            let key = "\(keyNum)"
                            
                            let timeinterval : TimeInterval = Double(key)! / 1000 // convert it in to NSTimeInteral
                            let dateFromServer = NSDate(timeIntervalSince1970:timeinterval) // you can the Date object from here
                            let dateFormatter = DateFormatter()
                            //.dateFormat = "h:mm a"
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            let date = dateFormatter.string(from: dateFromServer as Date).capitalized
                            
                            let source = resultData.value(forKey: "source") as! String
                            let scheduleAs = resultData.value(forKey: "scheduleAs") as! String
                            
                           // print("date on \(date)")
                            
                            if source == "Cenes"{
                                self.holidaysData.setValue(commonColor, forKey: date)
                            }else if source == "Google"{
                                
                                if self.holidaysData.value(forKey: date) != nil {
                                    let eventColor = self.holidaysData.value(forKey: date) as? UIColor
                                    if eventColor == commonColor{
                                        continue
                                    }
                                }
                                
                                if scheduleAs == "Holiday"{
                                    self.holidaysData.setValue(Util.colorWithHexString(hexString: "004345"), forKey: date)
                                }else if scheduleAs == "Event"{
                                    self.holidaysData.setValue(Util.colorWithHexString(hexString: "d34836"), forKey: date)
                                }
                                
                            }else if source == "Facebook"{
                                
                                if self.holidaysData.value(forKey: date) != nil {
                                    let eventColor = self.holidaysData.value(forKey: date) as? UIColor
                                    if eventColor == commonColor{
                                        continue
                                    }
                                }
                                
                                self.holidaysData.setValue(Util.colorWithHexString(hexString: "3b5998"), forKey: date)
                            }else if source == "Apple"{
                                
                                if self.holidaysData.value(forKey: date) != nil {
                                    let eventColor = self.holidaysData.value(forKey: date) as? UIColor
                                    if eventColor == commonColor{
                                        continue
                                    }
                                }
                                self.holidaysData.setValue(Util.colorWithHexString(hexString: "999999"), forKey: date)
                            }else if source == "Outlook" {
                                if self.holidaysData.value(forKey: date) != nil {
                                    let eventColor = self.holidaysData.value(forKey: date) as? UIColor
                                    if eventColor == commonColor{
                                        continue
                                    }
                                }
                                
                                self.holidaysData.setValue(Util.colorWithHexString(hexString: "0072c6"), forKey: date)
                            }
                            
                        }
                        self.calendar.reloadData()
                    }
                }
            }
        }

    }
    
    func createGathering(){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        let createGatheringView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "createGathering") as! CreateGatheringViewController
        self.navigationController?.pushViewController(createGatheringView, animated: true)
        }
    }
    
    func createReminder(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.performSegue(withIdentifier: "addReminder", sender: nil)
//        let createReminderView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddOrEditReminderViewController") as! AddOrEditReminderViewController
//            let navController = UINavigationController(rootViewController: createReminderView)
//            //self.navigationController?.pushViewController(createReminderView, animated: true)
//            self.present(navController, animated: true, completion: nil)
////        self.navigationController?.pushViewController(createReminderView, animated: true)
        }
    }
    
    func createAlarm(){
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            print("adsb")
            
          self.performSegue(withIdentifier: "addOrEditAlarm", sender: nil)
            
//            let createReminderView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddAlarmViewController") as! AddAlarmViewController
//            let navController = UINavigationController(rootViewController: createReminderView)
//            self.present(navController, animated: true, completion: nil)
            //        self.navigationController?.pushViewController(createReminderView, animated: true)
        }
    }
    
    
    func parseResults(resultArray: NSArray){
        
        let dict = NSMutableDictionary()
        dict.setValue([CenesCalendarData](), forKey: "Reminders")
        let cenesEvent = CenesEvent()
        cenesEvent.sectionName = "Reminders"
        cenesEvent.sectionObjects = [CenesCalendarData]()
        self.dataObjectArray.append(cenesEvent)
        
        
        
        for i : Int in (0..<resultArray.count) {
            
            
            let outerDict = resultArray[i] as! NSDictionary
            
            
            
            
            
            let title = (outerDict.value(forKey: "title") != nil) ? outerDict.value(forKey: "title") as? String : nil
            
            let location = (outerDict.value(forKey: "location") != nil) ? outerDict.value(forKey: "location") as? String : nil
            
            let scheduleAs = outerDict.value(forKey: "scheduleAs") as? String
            
            let  eventPicture = (outerDict.value(forKey: "picture") != nil) ? outerDict.value(forKey: "picture") as? String : nil
            
            let dataType = (outerDict.value(forKey: "type") != nil) ? outerDict.value(forKey: "type") as? String : nil
            
            let  e_id = (outerDict.value(forKey: "id") != nil) ? outerDict.value(forKey: "id") as? NSNumber : nil
            let event_id = "\(e_id!)"
            
            let eventMembers = (outerDict.value(forKey: "members") != nil) ? outerDict.value(forKey: "members") as? NSArray : nil
            
            let source = outerDict.value(forKey: "source") as? String
            
            
            let cenesEventObject : CenesCalendarData = CenesCalendarData()
            
            cenesEventObject.title = title
            cenesEventObject.subTitle = location
            cenesEventObject.eventImageURL = eventPicture
            cenesEventObject.eventId = event_id
            
            if dataType == "Reminder" {
                    cenesEventObject.dataType = DATA_TYPE_CAL_REM
            }else if dataType == "Gathering" {
                    cenesEventObject.dataType = DATA_TYPE_CAL_NOR
            }else if dataType == "Event" {
                cenesEventObject.dataType = DATA_TYPE_CAL_NOR
            }
            
            
            
            cenesEventObject.scheduleAs = scheduleAs
            cenesEventObject.source = source
            let friendDict = eventMembers as! [NSDictionary]
            
            for userDict in friendDict {
                let cenesUser = CenesUser()
                cenesUser.name = userDict.value(forKey: "name") as? String
                cenesUser.photoUrl = userDict.value(forKey: "picture") as? String
                
                let uid =  userDict.value(forKey: "userId") as? NSNumber
                if uid != nil{
                cenesUser.userId = "\((uid)!)"
                }
                
                cenesUser.userName = userDict.value(forKey: "username") as? String
                if let isOwner = userDict.value(forKey: "owner") as? Bool {
                    cenesUser.isOwner = isOwner
                }
                
                cenesEventObject.eventUsers.append(cenesUser)
            }
            
           
            let keyNum = outerDict.value(forKey: "startTime") as? NSNumber
            
            if keyNum == nil {
                var array = dict.value(forKey: "Reminders") as! [CenesCalendarData]!
                array?.append(cenesEventObject)
                dict.setValue(array, forKey: "Reminders")
                if let cenesEvent = self.dataObjectArray.first(where: { $0.sectionName == "Reminders"}){
                    print(cenesEvent.sectionName)
                    cenesEvent.sectionObjects = array
                }
                continue
            }
            
            
            var key = "\(keyNum!)"
            
            let time = self.getTimeFromTimestamp(timeStamp: key)
            key = self.getDateFromTimestamp(timeStamp: key)
            cenesEventObject.time = time
            cenesEventObject.startTimeMillisecond = keyNum
            
            if dict.value(forKey: key) != nil {
                
                var array = dict.value(forKey: key) as! [CenesCalendarData]!
                array?.append(cenesEventObject)
                dict.setValue(array, forKey: key)
                
                if let cenesEvent = self.dataObjectArray.first(where: { $0.sectionName == key}){
                    print(cenesEvent.sectionName)
                    
                    var gArray = [CenesCalendarData]()
                    var rArray = [CenesCalendarData]()
                    for arr in array! {
                        if arr.dataType == DATA_TYPE_CAL_NOR{
                            gArray.append(arr)
                        }else if arr.dataType == DATA_TYPE_CAL_REM {
                            rArray.append(arr)
                        }
                    }
                    array?.removeAll()
                    array?.append(contentsOf: gArray)
                    array?.append(contentsOf: rArray)
                    cenesEvent.sectionObjects = array
                }
                

                
            }else{
                var array = [CenesCalendarData]()
                
                array.append(cenesEventObject)
                dict.setValue(array, forKey: key)
                
                let cenesEvent = CenesEvent()
                cenesEvent.sectionName = key
                cenesEvent.sectionObjects = array
                self.dataObjectArray.append(cenesEvent)
            }
            
        }
        
        
        let Default = self.dataObjectArray.first
        if Default?.sectionObjects.count == 0{
            self.dataObjectArray.remove(at: 0)
        }
        
        
        self.tableView.reloadData()
        if self.dataObjectArray.count > 0 {
            self.tableView.isHidden = false
        }else{
            self.tableView.isHidden = true
        }
        self.calendar.reloadData()
        
    }
    
    
    
    @IBAction func togglePressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        var constraint = 0
        
        if self.calendar.isHidden {
            constraint = 0
        }
        else {
            constraint = -Int(self.calendar.frame.size.height) - 24
        }
        
        UIView.animate(withDuration:0.4, animations: {
            self.calendarTopConstraint.constant = CGFloat(constraint)
            self.view.layoutIfNeeded()
            self.automaticallyAdjustsScrollViewInsets = false
            self.calendar.isHidden = !self.calendar.isHidden
            self.monthlyWeeklyButton.isHidden = !self.monthlyWeeklyButton.isHidden
            self.calendar.reloadData()
        })
        self.tableView.reloadData()
    }
    
    
    @objc func notificationBarButtonPressed(_ sender : UIButton){
        //sender.isSelected = !sender.isSelected
        let notificationsView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
       // notificationsView.image = self.profileImage
        self.navigationController?.pushViewController(notificationsView, animated: true)
    }

    
    func setUpNavBarImages() {
        
        let profileButton = UIButton.init(type: .custom)
        
        self.profileImage = appDelegate?.getProfileImage()
       
        profileButton.imageView?.contentMode = .scaleAspectFill
        
        profileButton.setImage(self.profileImage, for: UIControlState.normal)
        profileButton.frame = CGRect.init(x: 0, y: 0, width: 35 , height: 35)
        profileButton.layer.cornerRadius = profileButton.frame.height/2
        
        profileButton.clipsToBounds = true
        profileButton.widthAnchor.constraint(equalToConstant: 35.0).isActive = true
        profileButton.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        profileButton.addTarget(self, action:#selector(profileButtonPressed), for: UIControlEvents.touchUpInside)
        profileButton.backgroundColor = UIColor.white
        
        
        let barButton = UIBarButtonItem.init(customView: profileButton)
        self.navigationItem.leftBarButtonItem = barButton
        
        //let calendarImage = UIImage(named: "noun_999728_cc")
        let calendarButton = UIButton.init(type: .custom)
        calendarButton.setImage(#imageLiteral(resourceName: "calendarNavBarUnselected"), for: UIControlState.normal)
        calendarButton.setImage(#imageLiteral(resourceName: "calendarNavBarSelected"), for: UIControlState.selected)
        calendarButton.addTarget(self, action:#selector(togglePressed), for: UIControlEvents.touchUpInside)
        calendarButton.frame = CGRect.init(x: 0, y: 0, width: 25, height: 25)
        let calendarBarButton = UIBarButtonItem.init(customView: calendarButton)
        
        self.navigationItem.rightBarButtonItem = calendarBarButton
        /*let notificationButton = UIButton.init(type: .custom)
        
        
        
        //notificationButton.setImage(Ionicons.androidNotifications.image(25, color: commonColor), for: .selected)
        notificationButton.setImage(Ionicons.androidNotifications.image(25, color: UIColor.white), for: .normal)
        
        
        notificationButton.frame = CGRect.init(x: 0, y: 0, width: 25, height: 25)
        notificationButton.layer.cornerRadius = notificationButton.frame.height/2
        notificationButton.clipsToBounds = true
        notificationButton.addTarget(self, action: #selector(notificationBarButtonPressed), for: .touchUpInside)
        let notificationBarButton = UIBarButtonItem.init(customView: notificationButton)
        self.navigationItem.rightBarButtonItems = [calendarBarButton,notificationBarButton]
        */
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func profileButtonPressed(){
        
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
       // self.performSegue(withIdentifier: "openSideMenu", sender: self)
       
    }
    
    func getAlarmsCount() -> Int {
        let moc = appDelegate?.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Alarm> = Alarm.fetchRequest()
        let count = try! moc?.count(for: fetchRequest)
        return count!+1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addOrEditAlarm" {
            let addAlarmVCNavigation = segue.destination as? UINavigationController
            let addAlarmVC = addAlarmVCNavigation?.topViewController as? AddAlarmViewController
            addAlarmVC?.managedObjectContext = appDelegate?.cenesPersistentContainer.viewContext
            addAlarmVC?.isEditMode = false
            addAlarmVC?.autoIncrementID = getAlarmsCount()
            addAlarmVC?.alarmVCtitle = "Add Alarm"
        }
    }
}




extension HomeViewController :UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataObjectArray[section].sectionObjects.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         let obj = dataObjectArray[indexPath.section].sectionObjects[indexPath.row]
        print("subtitle \(obj.subTitle) for \(dataObjectArray[indexPath.section])")
        
        if obj.dataType == "Reminder"{
            return 44
        }
        
        
        var height =  113
        if obj.eventUsers.count == 0 && (obj.subTitle == nil || obj.subTitle == ""){
            height = 58
        }else if obj.eventUsers.count == 0 && !(obj.subTitle == nil || obj.subTitle == ""){
            height = 70
        }else if obj.eventUsers.count > 0 && !(obj.subTitle == nil || obj.subTitle == ""){
            height = 113
        }else if obj.eventUsers.count > 0 && (obj.subTitle == nil || obj.subTitle == ""){
            height = 90
        }
        
        
        return CGFloat(height)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let obj = dataObjectArray[indexPath.section].sectionObjects[indexPath.row]
        
        
        if(obj.dataType == DATA_TYPE_CAL_NOR)
        {
        
            let identifier = "cellOne"
            let cell: HomeTableViewCellOne! = self.tableView.dequeueReusableCell(withIdentifier: identifier) as? HomeTableViewCellOne
            
            cell.HomeView = self
            cell.locationView.isHidden = true
            
            cell.timeTitle.text = obj.title
            cell.timeLabel.text = obj.time
            
            if obj.subTitle == nil || obj.subTitle == ""{
                cell.locationView.isHidden = true
            }else{
                cell.timeSubTitle.text =  obj.subTitle
                cell.locationView.isHidden = false
            }
            
            if obj.eventUsers.count == 0 {
                cell.eventsImageOuterView.isHidden = true
            }else{
                cell.eventsImageOuterView.isHidden = false
            }
            
            if obj.source == "Cenes"{
                cell.eventView.backgroundColor = commonColor
            }else if obj.source == "Google"{
                if obj.scheduleAs == "Holiday"{
                    cell.eventView.backgroundColor = Util.colorWithHexString(hexString: "004345")
                }else if obj.scheduleAs == "Event"{
                    cell.eventView.backgroundColor = Util.colorWithHexString(hexString: "d34836")
                }
                
            }else if obj.source == "Facebook"{
                cell.eventView.backgroundColor = Util.colorWithHexString(hexString: "3b5998")
            }else if obj.source == "Apple"{
                cell.eventView.backgroundColor = Util.colorWithHexString(hexString: "999999")
            }else if obj.source == "Outlook" {
                cell.eventView.backgroundColor = Util.colorWithHexString(hexString: "0072c6")
            }
            
            
            cell.FriendArray = obj.eventUsers
            
            cell.reloadFriends()
            
            
            return cell
        }
        else
        {
            let identifier = "cellTwo"
            let cell: HomeTableViewCellTwo = (self.tableView.dequeueReusableCell(withIdentifier: identifier) as? HomeTableViewCellTwo)!
            cell.reminderlabel.text = obj.title
            
            if obj.time != nil {
            cell.timeLabel.text = obj.time
            }else{
                    cell.timeLabel.text = ""
            }
            
            if let sTime = obj.startTimeMillisecond {
                let dateReminder = Date(milliseconds:sTime.intValue)
                if dateReminder < Date(){
                    cell.reminderlabel.textColor = UIColor.red
                }else{
                    cell.reminderlabel.textColor = UIColor.black
                }
            }else{
               cell.reminderlabel.textColor = UIColor.black
            }
            
            
            
            
            return cell
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
         return dataObjectArray.count
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return  objectArray[section].sectionName
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 42
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        print("Section Header Calls \(section)")
        let sectionTitle = dataObjectArray[section].sectionName
        
        let identifier = "HeaderCell"
        let cell: HomeTableViewCellHeader! = self.tableView.dequeueReusableCell(withIdentifier: identifier) as? HomeTableViewCellHeader
        
        cell.titleLabel.text = sectionTitle
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let obj = dataObjectArray[indexPath.section].sectionObjects[indexPath.row]
        
        if obj.scheduleAs == "Gathering"{
            
        
        let webservice = WebService()
      //  startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))
        webservice.getEventDetails(eventid: obj.eventId!){ (returnedDict) in
            print("Got results")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.stopAnimating()
            if returnedDict.value(forKey: "Error") as? Bool == true {
                
                self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                
            }else{
                print(returnedDict)
                let createGatheringView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "createGathering") as! CreateGatheringViewController
                
                
                let dict = returnedDict.value(forKey: "data") as! NSDictionary
                createGatheringView.eventName = dict.value(forKey: "title") as! String
                
                var location = dict.value(forKey: "location") as! String
                if location == "" {
                    location = "No Location for event"
                }
                
                
                let locationModel =  LocationModel()
                locationModel.locationName = location
                
                
                let longString = dict.value(forKey: "longitude") as? String
                if longString != nil && longString != "" {
                    let long = Float(longString!)
                    let longitude = NSNumber(value:long!)
                    locationModel.longitude = longitude
                }
                
                
                let latString = dict.value(forKey: "latitude") as? String
                if latString != nil && latString != "" {
                    let lat = Float(latString!)
                    let latitude = NSNumber(value:lat!)
                    locationModel.latitude = latitude
                }
                
                createGatheringView.locationName = location
                createGatheringView.eventDetails = dict.value(forKey: "description") as! String
                createGatheringView.selectedLocation = locationModel
                createGatheringView.summaryBool = true
                createGatheringView.loadSummary = true
                createGatheringView.gatheringImageURL = obj.eventImageURL
                
                createGatheringView.eventId = obj.eventId
                
                let friendDict = dict.value(forKey: "eventMembers") as! [NSDictionary]
                
                var friendArray = [CenesUser]()
                
                for userDict in friendDict {
                    let cenesUser = CenesUser()
                    cenesUser.name = userDict.value(forKey: "name") as? String
                    cenesUser.photoUrl = userDict.value(forKey: "picture") as? String
                    cenesUser.userId = "\((userDict.value(forKey: "userId") as? NSNumber)!)"
                    cenesUser.userName = userDict.value(forKey: "username") as? String
                    cenesUser.status = userDict.value(forKey: "status") as? String
                    friendArray.append(cenesUser)
                }
                
                createGatheringView.FriendArray = friendArray
                
                let userid = setting.value(forKey: "userId") as! NSNumber
                
                if  dict.value(forKey: "createdById") as! NSNumber == userid {
                    createGatheringView.isOwner = true
                }else{
                    createGatheringView.isOwner = false
                }
                
                
                let isPredictiveOn = dict.value(forKey: "isPredictiveOn") as! Bool
                if isPredictiveOn == true {
                    createGatheringView.isPreditiveEnabled = true
                    let str = dict.value(forKey: "predictiveData") as! String
                    let abc = self.convertToDictionary(text: str)
                    createGatheringView.predictiveData = NSMutableArray(array: abc!)
                }else{
                    createGatheringView.isPreditiveEnabled = false
                }
                let startTime = dict.value(forKey: "startTime") as! NSNumber
                let endTime = dict.value(forKey: "endTime") as! NSNumber
                
                createGatheringView.startTime = "\(startTime)"
                createGatheringView.endTime = "\(endTime)"
                
                self.navigationController?.pushViewController(createGatheringView, animated: true)
                
            }
            }}
        }
    }
    
    func convertToDictionary(text: String) -> NSArray? {
        if let data = text.data(using: .utf8) {
            do {
                
                return try JSONSerialization.jsonObject(with: data, options: []) as? NSArray
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func getTimeFromTimestamp(timeStamp:String) -> String{
        let timeinterval : TimeInterval = Double(timeStamp)! / 1000 // convert it in to NSTimeInteral
        let dateFromServer = NSDate(timeIntervalSince1970:timeinterval) // you can the Date object from here
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let date = dateFormatter.string(from: dateFromServer as Date)
        
        return date
    }
    
    func getDateFromTimestamp(timeStamp:String) -> String{
        let timeinterval : TimeInterval = Double(timeStamp)! / 1000 // convert it in to NSTimeInteral
        let dateFromServer = NSDate(timeIntervalSince1970:timeinterval) // you can the Date object from here
        let dateFormatter = DateFormatter()
         //.dateFormat = "h:mm a"
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var date = dateFormatter.string(from: dateFromServer as Date).capitalized
        
        let dateobj = dateFormatter.date(from: date)
        
        
        dateFormatter.dateFormat = "EEEE, MMMM d"
        date = dateFormatter.string(from: dateFromServer as Date).capitalized
        if NSCalendar.current.isDateInToday(dateobj!) == true {
            date = "TODAY \(date)"
        }else if NSCalendar.current.isDateInTomorrow(dateobj!) == true{
            date = "TOMORROW \(date)"
        }
        
        return date
    }
    

    
}


extension HomeViewController: FSCalendarDelegate , FSCalendarDataSource ,FSCalendarDelegateAppearance
{
    
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        self.dataObjectArray.removeAll(keepingCapacity: true)
        self.tableView.reloadData()
        let webservice = WebService()
        
      //  startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))
        
        
        
        
        
        webservice.getHomeEvents(dateString: "\((self.dateFormatter.date(from: selectedDates.first!)?.millisecondsSince1970)!)", timeZoneString: "") { (returnedDict) in
            print("Got results")
            self.stopAnimating()
            if returnedDict.value(forKey: "Error") as? Bool == true {
                
                self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                
            }else{
                self.parseResults(resultArray: (returnedDict["data"] as? NSArray)!)
            }
            
        }
        
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }

    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeight.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        
        if self.holidaysData.allKeys.count > 0 {
            let key = self.dateFormatter.string(from: date)
            
            if holidaysData.value(forKey: key) != nil {
                let eventColor = holidaysData.value(forKey: key) as? UIColor
                return [eventColor!]
            }else{
                return [UIColor.clear]
            }
        }else{
            return [UIColor.clear]
        }
           
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        if self.holidaysData.allKeys.count > 0 {
            let key = self.dateFormatter.string(from: date)
            
            if holidaysData.value(forKey: key) != nil {
                let eventColor = holidaysData.value(forKey: key) as? UIColor
                return eventColor!
                
            }else{
                return commonColor
            }
        }else{
            return commonColor
        }
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        if self.holidaysData.allKeys.count > 0 {
            let key = self.dateFormatter.string(from: date)
            
            if holidaysData.value(forKey: key) != nil {
                let eventColor = holidaysData.value(forKey: key) as? UIColor
                return [eventColor!]
            }else{
                return [UIColor.clear]
            }
        }else{
            return [UIColor.clear]
        }
    }
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        return UIColor.white
    }
    
    func calendar(_ calendar : FSCalendar , numberOfEventsFor : Date) -> Int{
        
        if self.holidaysData.allKeys.count > 0 {
             let key = self.dateFormatter.string(from: numberOfEventsFor)
            
            if holidaysData.value(forKey: key) != nil {
                 return 1
            }else{
                 return 0
            }
        }else{
            return 0
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("calendar changes")
    }
    
    
}

