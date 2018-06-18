//
//  GatheringViewController.swift
//  Cenes
//
//  Created by Redblink on 05/09/17.
//  Copyright © 2017 Sabita Rani Samal. All rights reserved.
//

import UIKit
import ActionButton
import IoniconsSwift
import NVActivityIndicatorView

class GatheringViewController: BaseViewController,NVActivityIndicatorViewable {

    var profileImage = UIImage(named: "profile icon")
    
    @IBOutlet weak var confirmSelectView: UIView!
    
    
    @IBOutlet weak var gatheringTableView: UITableView!
    
    
    
    @IBOutlet weak var tabTitleLabel: UILabel!
    
    var objectArray = [CalendarObjects]()
    
    var dataObjectArray = [CenesEvent]()
    var InvitationArray = [CenesCalendarData]()
    
    @IBOutlet weak var mayBeSelectView: UIView!
    
    @IBOutlet weak var declineSelectView: UIView!
    
    var imageDownloadsInProgress = [IndexPath : IconDownloader]()
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"//"MM/dd/yyyy"
        return formatter
    }()
    
    var selectedTab : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let gradient = CAGradientLayer()
        gradient.frame = (self.navigationController?.navigationBar.bounds)!
        gradient.colors = [UIColor(red: 244/255, green: 106/255, blue: 88/255, alpha: 1).cgColor,UIColor(red: 249/255, green: 153/255, blue: 44/255, alpha: 1).cgColor]
        gradient.locations = [1.0,0.3]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.navigationController?.navigationBar.setBackgroundImage(cenesDelegate.creatGradientImage(layer: gradient), for: .default)
        
        
        if(setting.value(forKey: "photo") != nil)
        {
            let webServ = WebService()
            webServ.profilePicFromFacebook(url: setting.value(forKey: "photo")! as! String, completion: { image in
                self.profileImage = image
                self.setUpNavBar()
            })
        }
        
        self.setUpNavBar()
        
        gatheringTableView.register(UINib(nibName: "HomeTableViewCellOne", bundle: Bundle.main), forCellReuseIdentifier: "cellOne")
        gatheringTableView.register(UINib(nibName: "HomeTableViewCellTwo", bundle: Bundle.main), forCellReuseIdentifier: "cellTwo")
        gatheringTableView.register(UINib(nibName: "HomeTableViewCellHeader", bundle: Bundle.main), forCellReuseIdentifier: "HeaderCell")
        gatheringTableView.register(UINib(nibName: "InvitationViewCell", bundle: Bundle.main), forCellReuseIdentifier: "InvitationViewCell")
        
        
        gatheringTableView.rowHeight = UITableViewAutomaticDimension
        gatheringTableView.estimatedRowHeight = 140
        gatheringTableView.estimatedSectionHeaderHeight = 42
        
        // Do any additional setup after loading the view.
    }
    
    
   override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    func fetchGatheringEvents(type:String){
        let webservice = WebService()
        startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))
        
        webservice.getGatheringEvents(type: type) { (returnedDict) in
            self.stopAnimating()
            if returnedDict.value(forKey: "Error") as? Bool == true {
                
                self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                
            }else{
                self.parseResults(resultArray: (returnedDict["data"] as? NSArray)!)
            }
        }
        
        
//        webservice.getHomeEvents(dateString: self.dateFormatter.string(from: Date()), timeZoneString: "") { (returnedDict) in
//            print("Got results")
//            let hud = MBProgressHUD(for: self.view.window!)
//            hud?.hide(animated: true)
//            if returnedDict.value(forKey: "Error") as? Bool == true {
//                
//                self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
//                
//            }else{
//                self.parseResults(resultArray: (returnedDict["data"] as? NSArray)!)
//            }
//            
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.confirmedButtonPressed(UIButton())
    }
    
    
    func parseResults(resultArray: NSArray){
        
        
        let dict = NSMutableDictionary()
        
        for i : Int in (0..<resultArray.count) {
            
            
            let outerDict = resultArray[i] as! NSDictionary
            
            let keyNum = outerDict.value(forKey: "startTime") as! NSNumber
            var key = "\(keyNum)"
            
            let dateString = self.getDateString(timeStamp: key)
            
            let time = self.getTimeFromTimestamp(timeStamp: key)
            key = self.getDateFromTimestamp(timeStamp: key)
            
            
            
            let title = (outerDict.value(forKey: "title") != nil) ? outerDict.value(forKey: "title") as? String : nil
            
            let location = (outerDict.value(forKey: "location") != nil) ? outerDict.value(forKey: "location") as? String : nil
            
            let  eventPicture = (outerDict.value(forKey: "event_picture") != nil) ? outerDict.value(forKey: "event_picture") as? String : nil
            
            let  e_id = (outerDict.value(forKey: "eventId") != nil) ? outerDict.value(forKey: "eventId") as? NSNumber : nil
            let event_id = "\(e_id!)"
            
            
            
            let eventMembers = (outerDict.value(forKey: "eventMembers") != nil) ? outerDict.value(forKey: "eventMembers") as? NSArray : nil
            
            let senderName = outerDict.value(forKey: "sender") as? String
            
            let cenesEventObject : CenesCalendarData = CenesCalendarData()
            
            cenesEventObject.title = title
            cenesEventObject.subTitle = location
            cenesEventObject.eventImageURL = eventPicture
            cenesEventObject.eventId = event_id
            cenesEventObject.dataType = DATA_TYPE_CAL_NOR
            cenesEventObject.time = time
            cenesEventObject.dateValue = dateString
            cenesEventObject.senderName = senderName
            let e_Member_Id = outerDict.value(forKey: "event_member_id") as? NSNumber
            if e_Member_Id != nil {
            let eMemeberId = "\(e_Member_Id!)"

            cenesEventObject.eventMemberId = eMemeberId
            }
            
            
            
            
            if self.selectedTab == 0 || self.selectedTab == 2{
                
                
                
            if dict.value(forKey: key) != nil {
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
                    cenesEventObject.eventUsers.append(cenesUser)
                }
                
                var array = dict.value(forKey: key) as! [CenesCalendarData]!
                array?.append(cenesEventObject)
                
                dict.setValue(array, forKey: key)
                
                
                
                if let cenesEvent = self.dataObjectArray.first(where: { $0.sectionName == key}){
                    print(cenesEvent.sectionName)
                    cenesEvent.sectionObjects = array
                }
            }else{
                var array = [CenesCalendarData]()
                
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
                    cenesEventObject.eventUsers.append(cenesUser)
                }
                
                array.append(cenesEventObject)
                dict.setValue(array, forKey: key)
                
                let cenesEvent = CenesEvent()
                cenesEvent.sectionName = key
                cenesEvent.sectionObjects = array
                
                self.dataObjectArray.append(cenesEvent)
                
            }
            }else{
                InvitationArray.append(cenesEventObject)
            }
        }
        
        self.reloadGatherings()
        
        
        
        
    }
    
    
    func reloadGatherings(){
        if self.selectedTab == 0 || self.selectedTab == 2 {
        if self.dataObjectArray.count > 0 {
            self.gatheringTableView.isHidden = false
        }else{
            self.gatheringTableView.isHidden = true
        }
        }else{
            if self.InvitationArray.count > 0 {
                self.gatheringTableView.isHidden = false
            }else{
                self.gatheringTableView.isHidden = true
            }
        }
        self.gatheringTableView.reloadData()
    }
    
    
    
    
    func getTimeFromTimestamp(timeStamp:String) -> String{
        let timeinterval : TimeInterval = Double(timeStamp)! / 1000 // convert it in to NSTimeInteral
        let dateFromServer = NSDate(timeIntervalSince1970:timeinterval) // you can the Date object from here
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let date = dateFormatter.string(from: dateFromServer as Date)
        
        return date
    }
    
    
    func getDateString(timeStamp:String)-> String {
        let timeinterval : TimeInterval = Double(timeStamp)! / 1000 // convert it in to NSTimeInteral
        let dateFromServer = NSDate(timeIntervalSince1970:timeinterval) // you can the Date object from here
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        var dateString = dateFormatter.string(from: dateFromServer as Date)
        dateString += "\n"
        dateFormatter.dateFormat = "EEE"
        dateString += dateFormatter.string(from: dateFromServer as Date)
        return dateString
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
    
    func createGathering(){
        
       let createGatheringView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "createGathering") as! CreateGatheringViewController
        self.navigationController?.pushViewController(createGatheringView, animated: true)
    }
    
    
    @objc func profileButtonPressed(){
        let settingsView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsView") as! SettingsViewController
        settingsView.image = self.profileImage
        self.navigationController?.pushViewController(settingsView, animated: true)
    }
    
    
    
    
    func setUpNavBar(){
        let profileButton = UIButton.init(type: .custom)
        let image = self.profileImage?.compressImage(newSizeWidth: 35, newSizeHeight: 35, compressionQuality: 1.0)
        profileButton.setImage(image, for: UIControlState.normal)
        profileButton.frame = CGRect.init(x: 0, y: 0, width: 35, height: 35)
        profileButton.layer.cornerRadius = profileButton.frame.height/2
        profileButton.clipsToBounds = true
        profileButton.addTarget(self, action: #selector(profileButtonPressed), for: .touchUpInside)
        
        
        let barButton = UIBarButtonItem.init(customView: profileButton)
        self.navigationItem.leftBarButtonItem = barButton
        
        let notificationButton = UIButton.init(type: .custom)
        
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createGathering))
        self.navigationItem.rightBarButtonItem = editButton
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func confirmedButtonPressed(_ sender: UIButton) {
        selectedTab = 0
        self.tabTitleLabel.text = "Your Gatherings"
        self.dataObjectArray = [CenesEvent]()
        self.InvitationArray = [CenesCalendarData]()
        self.gatheringTableView.separatorStyle = .singleLine
        self.gatheringTableView.reloadData()
        
        self.confirmSelectView.isHidden = false
        self.mayBeSelectView.isHidden = true
        self.declineSelectView.isHidden = true
        
        self.fetchGatheringEvents(type: "Going")
    }
    
    @IBAction func mayBeButtonPressed(_ sender: UIButton) {
        selectedTab = 1
        self.tabTitleLabel.text = "Your Invitaitons"
        self.gatheringTableView.separatorStyle = .none
        self.dataObjectArray = [CenesEvent]()
        self.InvitationArray = [CenesCalendarData]()
        self.reloadGatherings()
        self.confirmSelectView.isHidden = true
        self.mayBeSelectView.isHidden = false
        self.declineSelectView.isHidden = true
        self.fetchGatheringEvents(type: "pending")
    }
    
    @IBAction func declineButtonPressed(_ sender: UIButton) {
        selectedTab = 2
        self.tabTitleLabel.text = "Declined Invitations"
        self.gatheringTableView.separatorStyle = .singleLine
        self.dataObjectArray = [CenesEvent]()
        self.InvitationArray = [CenesCalendarData]()
        self.reloadGatherings()
        self.confirmSelectView.isHidden = true
        self.mayBeSelectView.isHidden = true
        self.declineSelectView.isHidden = false
        self.fetchGatheringEvents(type: "NotGoing")
    }
    
    
   
    
    func acceptInvite(sender:UIButton!){
        let buttonPosition : CGPoint = sender.convert(sender.bounds.origin, to: gatheringTableView)
        let indexPath = gatheringTableView.indexPathForRow(at: buttonPosition)
        
        let obj = InvitationArray[(indexPath?.row)!]
        startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))
        
        WebService().AcceptDeclineInvitation(eventMemberId: obj.eventMemberId, status: "confirmed") { (returnedDict) in
            self.stopAnimating()
            if returnedDict.value(forKey: "Error") as? Bool == true {
                
                self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                
            }else{
                
                self.gatheringTableView.beginUpdates()
                self.InvitationArray.remove(at: (indexPath?.row)!)
                self.gatheringTableView.deleteRows(at: [indexPath!], with: .fade)
                self.gatheringTableView.endUpdates()
            }
        }
        
        
        
        
        
    }
    
    func declineInvite(sender:UIButton!){
        let buttonPosition : CGPoint = sender.convert(sender.bounds.origin, to: gatheringTableView)
        let indexPath = gatheringTableView.indexPathForRow(at: buttonPosition)
        
        let obj = InvitationArray[(indexPath?.row)!]
        startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))
        
        WebService().AcceptDeclineInvitation(eventMemberId: obj.eventMemberId, status: "declined") { (returnedDict) in
            self.stopAnimating()
            if returnedDict.value(forKey: "Error") as? Bool == true {
                
                self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                
            }else{
                
                self.gatheringTableView.beginUpdates()
                self.InvitationArray.remove(at: (indexPath?.row)!)
                self.gatheringTableView.deleteRows(at: [indexPath!], with: .fade)
                self.gatheringTableView.endUpdates()
            }
        }
    }
    
    func getInvitationText(sender : String) -> NSAttributedString{
        
        var attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13, weight: .medium),
                          NSAttributedStringKey.foregroundColor: UIColor.blue]
        
        let first = NSMutableAttributedString(string:"\(sender) ", attributes: attributes)
        
        attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13, weight: .medium),
                      NSAttributedStringKey.foregroundColor: UIColor.darkGray]
        
        let second = NSMutableAttributedString(string:" invited you", attributes: attributes)
        
        let final = NSMutableAttributedString()
        final.append(first)
        final.append(second)
        return final
    }
    
    
}

extension GatheringViewController :UITableViewDataSource,UITableViewDelegate
{
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if self.selectedTab == 0 || self.selectedTab == 2{
            let obj = dataObjectArray[indexPath.section].sectionObjects[indexPath.row]
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
            
        }else {
            return 194
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.selectedTab == 0 || self.selectedTab == 2 {
        return dataObjectArray[section].sectionObjects.count
        }else{
            return InvitationArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var obj : CenesCalendarData!
        if self.selectedTab == 0 || self.selectedTab == 2{
         obj = dataObjectArray[indexPath.section].sectionObjects[indexPath.row]
        }else{
          obj = InvitationArray[indexPath.row]
        }
        
        
        if(obj.dataType == DATA_TYPE_CAL_NOR)
        {
            if selectedTab == 0 || selectedTab == 2 {
            let identifier = "cellOne"
            let cell: HomeTableViewCellOne! = self.gatheringTableView.dequeueReusableCell(withIdentifier: identifier) as? HomeTableViewCellOne
            
            
            
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
                
                cell.eventView.backgroundColor = commonColor
                
                cell.FriendArray = obj.eventUsers
                
                cell.reloadFriends()
            
            return cell
            }else{
                let identifier = "InvitationViewCell"
                let cell: InvitationViewCell! = self.gatheringTableView.dequeueReusableCell(withIdentifier: identifier) as? InvitationViewCell
                
                if let icon = obj.eventImage {
                    cell.eventImageView.image = icon
                } else {
                    if obj.eventImageURL != nil {
                        self.startIconDownload(cenesEventData: obj, forIndexPath: indexPath)
                        cell.eventImageView.image = #imageLiteral(resourceName: "invitationEventDefault")
                    }else{
                        cell.eventImageView.image = #imageLiteral(resourceName: "invitationEventDefault")
                    }
                    
                }
                
                cell.titleLabel.text = obj.title
                cell.timeLabel.text = obj.time
                cell.dateLabel.text = obj.dateValue
                cell.invitationLabel.attributedText = self.getInvitationText(sender: obj.senderName)
                cell.gatheringView = self
                return cell
            }
        }
        else
        {
            let identifier = "cellTwo"
            let cell: HomeTableViewCellTwo = (self.gatheringTableView.dequeueReusableCell(withIdentifier: identifier) as? HomeTableViewCellTwo)!
            cell.reminderlabel.text = obj.title
            return cell
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.selectedTab == 0 || self.selectedTab == 2 {
        return dataObjectArray.count
        }else{
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.selectedTab == 0 || self.selectedTab == 2 {
        return 42
        }else{
            return 0.1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        print("Section Header Calls \(section)")
        if self.selectedTab == 0 || self.selectedTab == 2 {
        let sectionTitle = dataObjectArray[section].sectionName
        
        let identifier = "HeaderCell"
        let cell: HomeTableViewCellHeader! = self.gatheringTableView.dequeueReusableCell(withIdentifier: identifier) as? HomeTableViewCellHeader
        
        cell.titleLabel.text = sectionTitle
        
        return cell
        }else{
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.selectedTab == 0 {
        
       let obj = dataObjectArray[indexPath.section].sectionObjects[indexPath.row]
        
        let webservice = WebService()
            startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))
        webservice.getEventDetails(eventid: obj.eventId!){ (returnedDict) in
            print("Got results")
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
                
                createGatheringView.locationName = location
                createGatheringView.eventDetails = dict.value(forKey: "description") as! String
                
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
                    friendArray.append(cenesUser)
                }
                
                createGatheringView.FriendArray = friendArray
                
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
            
        }
        }
    }
    
    func convertToDictionary(text: String) -> NSArray? {
        if let data = text.data(using: .utf8) {
            do {
                
                return try JSONSerialization.jsonObject(with: data, options: []) as! NSArray
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func startIconDownload(cenesEventData: CenesCalendarData, forIndexPath indexPath: IndexPath) {
        guard self.imageDownloadsInProgress[indexPath] == nil else { return }
        
        let iconDownloader = IconDownloader(cenesUser: nil, cenesEventData: cenesEventData, notificationData: nil, indexPath: indexPath)
        iconDownloader.delegate = self
        self.imageDownloadsInProgress[indexPath] = iconDownloader
        iconDownloader.startDownload()
       // print(cenesEventData.title+" started download")
    }
    
    func terminateAllDownloads() {
        let allDownloads = Array(self.imageDownloadsInProgress.values)
        allDownloads.forEach { $0.cancelDownload() }
        self.imageDownloadsInProgress.removeAll()
    }
    
    func loadImagesForOnscreenRows() {
        guard self.dataObjectArray.count != 0 else { return }

        let visibleIndexPaths = self.gatheringTableView.indexPathsForVisibleRows
        for indexPath in visibleIndexPaths! {
            let cenesEventData = dataObjectArray[indexPath.section].sectionObjects[indexPath.row]
            if cenesEventData.eventImage == nil {
                if cenesEventData.eventImage != nil {
                    self.startIconDownload(cenesEventData: cenesEventData, forIndexPath: indexPath)
                }
            }else{

            }
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.loadImagesForOnscreenRows()
    }
    
    
}


extension GatheringViewController: IconDownloaderDelegate {
    func iconDownloaderDidFinishDownloadingImage(_ iconDownloader: IconDownloader, error: NSError?) {
        
        
            guard let cell = self.gatheringTableView.cellForRow(at:iconDownloader.indexPath as IndexPath) as? InvitationViewCell else {
                print("Not got cell")
                return }
            if let error = error {
                print("error downloading Image\(error)")
                //fatalError("Error loading thumbnails: \(error.localizedDescription)")
            } else {
                UIView.transition(with: cell.eventImageView!,
                                  duration: 1,
                                  options: .transitionCrossDissolve,
                                  animations: { cell.eventImageView?.image = iconDownloader.cenesEventData.eventImage},
                                  completion: nil)
                
                //  print(iconDownloader.cenesEventData.title+" user profile updated")
            }
            self.imageDownloadsInProgress.removeValue(forKey: iconDownloader.indexPath as IndexPath)
        
    }
}

