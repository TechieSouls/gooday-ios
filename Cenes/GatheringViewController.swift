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
import GoogleSignIn
import FBSDKLoginKit
import FacebookCore
import SideMenu

class GatheringViewController: BaseViewController,NVActivityIndicatorViewable {

    var profileImage = UIImage(named: "profile icon")
    
    @IBOutlet weak var confirmSelectView: UIView!
    @IBOutlet weak var acceptedBtn: UIButton!
    
    @IBOutlet weak var pendingBtn: UIButton!
    
    @IBOutlet weak var declinedBtn: UIButton!
    
    @IBOutlet weak var invitationView: UIView!
    
    @IBOutlet weak var gatheringTableView: UITableView!
    
    @IBOutlet weak var inviteTitleLabel: UILabel!
    var isNewInvite : Bool = false
    
    
    var invitationData : CenesCalendarData!
    var invitationLocationModel : LocationModel!
    
    @IBOutlet weak var tabTitleLabel: UILabel!
    
    var objectArray = [CalendarObjects]()
    
    var dataObjectArray = [CenesEvent]()
  //  var InvitationArray = [CenesCalendarData]()
    
    var isSummary = false
    
    @IBOutlet weak var mayBeSelectView: UIView!
    
    @IBOutlet weak var declineSelectView: UIView!
    
    var imageDownloadsInProgress = [IndexPath : IconDownloader]()
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"//"MM/dd/yyyy"
        return formatter
    }()
    
    var selectedTab : Int = 0
    var badgeCount: String? = "0"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Gatherings"
        
        self.gatheringTableView.backgroundColor = themeColor;
        
        
        
        /*let gradient = CAGradientLayer()
        gradient.frame = (self.navigationController?.navigationBar.bounds)!
        gradient.colors = [UIColor(red: 244/255, green: 106/255, blue: 88/255, alpha: 1).cgColor,UIColor(red: 249/255, green: 153/255, blue: 44/255, alpha: 1).cgColor]
        gradient.locations = [1.0,0.3]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.navigationController?.navigationBar.setBackgroundImage(cenesDelegate.creatGradientImage(layer: gradient), for: .default)*/
        
        
        
        gatheringTableView.register(UINib(nibName: "GatheringCardTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "GatheringCardTableViewCell")
        gatheringTableView.register(UINib(nibName: "GatheringCardHeaderTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "GatheringCardHeaderTableViewCell")
       
        /*gatheringTableView.register(UINib(nibName: "HomeTableViewCellTwo", bundle: Bundle.main), forCellReuseIdentifier: "cellTwo")*/
        /*gatheringTableView.register(UINib(nibName: "HomeTableViewCellHeader", bundle: Bundle.main), forCellReuseIdentifier: "HeaderCell")*/
        
        
        
        gatheringTableView.register(UINib(nibName: "InvitationViewCell", bundle: Bundle.main), forCellReuseIdentifier: "InvitationViewCell")
        
        
        gatheringTableView.rowHeight = UITableViewAutomaticDimension
        gatheringTableView.estimatedRowHeight = 140
        gatheringTableView.estimatedSectionHeaderHeight = 42
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    
    
    
    override func viewDidLayoutSubviews() {
        self.setUpNavBar()
    }
    
    
   override func viewWillAppear(_ animated: Bool) {
    
    
    self.profileImage = appDelegate?.getProfileImage()
    
    self.setUpNavBar()
    
    super.viewWillAppear(animated)
    if isSummary == true {
        isSummary = false
        self.confirmedButtonPressed(UIButton())
    }
    
}
    
    
    func setInvitation(){
        if self.invitationData.eventId != nil {
            // your code here
            self.navigationController?.popToRootViewController(animated: true)
            let webservice = WebService()
            self.startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))
            self.invitationView.isHidden = true
            webservice.getEventDetails(eventid: "\(self.invitationData.eventId!)"){ (returnedDict) in
                print("Got results")
                
                    self.stopAnimating()
                    if returnedDict.value(forKey: "Error") as? Bool == true {
                        
                        self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                        
                        let alertController = UIAlertController(title: "Error", message:(returnedDict["ErrorMsg"] as? String)!, preferredStyle: .alert)
                        
                        let OKButtonAction = UIAlertAction(title: "Ok", style: .default) { action -> Void in
                            self.isNewInvite = false
                            self.confirmedButtonPressed(UIButton())
                            self.invitationView.isHidden = true
                        }
                        alertController.addAction(OKButtonAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                        return
                        
                    }else{
                        print(returnedDict)
                        let createGatheringView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "createGathering") as! CreateGatheringViewController
                        
                        
                        var dict = returnedDict.value(forKey: "data") as? NSDictionary
                        if dict == nil {
                            return
                        }
                        
                        
                        
                        let members = dict?.value(forKey: "eventMembers") as! NSArray
                        let MyId = setting.value(forKey: "userId") as! NSNumber
                        var showInvite = false
                        for eMember in members{
                            let eventMember = eMember as! [String : Any]
                            let uId = eventMember["userId"] as? NSNumber
                            if MyId == uId {
                                let status = eventMember["status"] as? String
                                if status != nil {
                                    showInvite = false
                                }else{
                                    self.invitationData.eventMemberId = "\(eventMember["eventMemberId"] as! NSNumber)"
                                    showInvite = true
                                }
                                break
                            }
                        }
                        self.invitationData.title = dict?.value(forKey: "title") as! String
                        let locationModel = LocationModel()
                        locationModel.locationName = dict?.value(forKey: "location") as? String
                        
                        
                    let longString = dict?.value(forKey: "longitude") as? String
                        if longString != nil && longString != "" {
                            let long = Float(longString!)
                            let longitude = NSNumber(value:long!)
                            locationModel.longitude = longitude
                        }
                        
                        
                        let latString = dict?.value(forKey: "latitude") as? String
                        if latString != nil && latString != "" {
                            let lat = Float(latString!)
                            let latitude = NSNumber(value:lat!)
                            locationModel.latitude = latitude
                        }
                        
                        
                        
                        self.invitationLocationModel = locationModel
                        if showInvite == true {
                            self.invitationView.isHidden = false
                            self.inviteTitleLabel.text = self.invitationData.title
                            self.setUpNavBar()
                        }else{
                            
                            
                            
                            let createGatheringView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "createGathering") as! CreateGatheringViewController
                            
                            
                            let dict = returnedDict.value(forKey: "data") as! NSDictionary
                            createGatheringView.eventName = dict.value(forKey: "title") as! String
                            
                            
                            
                            
                            
                            var location = dict.value(forKey: "location") as? String
                            if location == "" || location == nil {
                                location = "No Location for event"
                            }
                            
                            createGatheringView.locationName = location!
                            createGatheringView.eventDetails = (dict.value(forKey: "description") as? String) != nil ? (dict.value(forKey: "description") as? String)! : ""
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
                            
                            
                            let userid = setting.value(forKey: "userId") as! NSNumber
                            
                            if  dict.value(forKey: "createdById") as! NSNumber == userid {
                                createGatheringView.isOwner = true
                            }else{
                                createGatheringView.isOwner = false
                            }
                            
                            createGatheringView.summaryBool = true
                            createGatheringView.selectedLocation = locationModel
                            createGatheringView.loadSummary = true
                            
                            createGatheringView.gatheringImageURL = dict.value(forKey: "eventPicture") as? String
                            
                            createGatheringView.eventId = "\(dict.value(forKey: "eventId")!)"
                            
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
                            self.isSummary = true
                            self.navigationController?.pushViewController(createGatheringView, animated: true)
                            

                            
//                            self.showAlert(title: "Alert", message: "You have already accepted this Invitation.")
//                            let alertController = UIAlertController(title: "Alert", message:"You have already seen this Invitation.", preferredStyle: .alert)
//
//                            let OKButtonAction = UIAlertAction(title: "Ok", style: .default) { action -> Void in
//                                self.isNewInvite = false
//                                self.confirmedButtonPressed(UIButton())
//                                self.invitationData = nil
//                            }
//                            alertController.addAction(OKButtonAction)
//
//                            self.present(alertController, animated: true, completion: nil)
                            
                            return
                        }
                        self.invitationData.subTitle = (dict?.value(forKey: "location") as? String) != nil ? (dict?.value(forKey: "location") as? String) : ""
                        self.invitationData.eventDescription = (dict?.value(forKey: "description") as? String) != nil ? (dict?.value(forKey: "description") as? String) : ""
                        let startTime = dict?.value(forKey: "startTime") as! NSNumber
                        let endTime = dict?.value(forKey: "endTime") as! NSNumber
                        
                        self.invitationData.startTimeMillisecond = startTime
                        self.invitationData.endTimeMillisecond = endTime
                        
                    }
            }
        }
    }
    
    
    func fetchGatheringEvents(type:String){
        let webservice = WebService()
      //  startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))
        
        webservice.getGatheringEvents(type: type) { (returnedDict) in
            self.stopAnimating()
            if returnedDict.value(forKey: "Error") as? Bool == true {
                
                self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                
            }else{
                //self.parseResults(resultArray: (returnedDict["data"] as? NSArray)!)
                self.dataObjectArray = GatheringManager().parseGatheringResults(resultArray: (returnedDict["data"] as? NSArray)!);
                
                self.reloadGatherings();
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.black]
        self.navigationController?.navigationBar.backgroundColor = themeColor
        self.navigationController?.navigationBar.tintColor = themeColor;
        

        if self.isNewInvite == false {
            if SideMenuManager.menuLeftNavigationController?.isNavigationBarHidden == true{
            self.confirmedButtonPressed(UIButton())
            }
        }
    }

    
    func reloadGatherings(){
        if self.dataObjectArray.count > 0 {
            self.gatheringTableView.isHidden = false
        }else{
            self.gatheringTableView.isHidden = true
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
    
    @objc func createGathering(){
        
       let createGatheringView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "createGathering") as! CreateGatheringViewController
        self.navigationController?.pushViewController(createGatheringView, animated: true)
    }
    
    
    @objc func profileButtonPressed(){
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
        //self.performSegue(withIdentifier: "openSideMenu", sender: self)
    }
    
    
    
    
    func setUpNavBar(){
        let profileButton = SSBadgeButton()//UIButton.init(type: .custom) //
        
        self.profileImage = appDelegate?.getProfileImage()
        
        profileButton.imageView?.contentMode = .scaleAspectFill
        
        profileButton.setImage(self.profileImage, for: UIControlState.normal)
        profileButton.frame = CGRect.init(x: 0, y: 0, width: 40 , height: 40)
        profileButton.layer.cornerRadius = profileButton.frame.height/2
        
        profileButton.clipsToBounds = true
        profileButton.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        profileButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        profileButton.addTarget(self, action:#selector(profileButtonPressed), for: UIControlEvents.touchUpInside)
        profileButton.backgroundColor = UIColor.white
        profileButton.badge = badgeCount;
        profileButton.badgeEdgeInsets = UIEdgeInsets(top: 35, left: 0, bottom: 0, right: 10)
        profileButton.badgeFont = profileButton.badgeFont.withSize(10)
        
        let barButton = UIBarButtonItem.init(customView: profileButton)
        self.navigationItem.leftBarButtonItem = barButton
        
        
        let editButton = UIButton.init(type: .custom)
        editButton.setImage(UIImage.init(named: "plus.png"), for: UIControlState.normal)
        editButton.addTarget(self, action:#selector(createGathering), for:.touchUpInside)
        editButton.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40) //CGRectMake(0, 0, 30, 30)
        let rightEditButton = UIBarButtonItem.init(customView: editButton)
        if self.isNewInvite == true {
        self.navigationItem.rightBarButtonItem = nil
        }else{
          self.navigationItem.rightBarButtonItem = rightEditButton
        }
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.black]
        self.navigationController?.navigationBar.tintColor = themeColor
        self.navigationController?.navigationBar.barTintColor = themeColor
        
    }
    func getNotificationCounts () {
        let webservice = WebService();
        webservice.getNotificationsCounter(){ (returnedDict) in
            print(returnedDict)
            self.stopAnimating()
            if returnedDict.value(forKey: "Error") as? Bool == true {
                
                self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                
            }else{
                print(returnedDict)
                self.badgeCount =  String(returnedDict["data"] as! Int) as? String
                self.setUpNavBar()
                
                //  self.parseResults(resultArray: (returnedDict["data"] as? NSArray)!)
                
                //Setting badge counts in prefrences
                let userDefaults = UserDefaults.standard
                userDefaults.setValue(returnedDict["data"] , forKey: "badgeCounts");
                userDefaults.synchronize()
            }
        }
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
        //self.tabTitleLabel.text = "Your Gatherings"
        self.dataObjectArray = [CenesEvent]()
        self.gatheringTableView.reloadData()
        
        self.acceptedBtn.setTitleColor(selectedColor, for: .normal)
        self.pendingBtn.setTitleColor(UIColor.init(red: 155/255, green: 155/255, blue: 155/255, alpha: 1), for: .normal)
        self.declinedBtn.setTitleColor(UIColor.init(red: 155/255, green: 155/255, blue: 155/255, alpha: 1), for: .normal)
        
        self.confirmSelectView.isHidden = false
        self.mayBeSelectView.isHidden = true
        self.declineSelectView.isHidden = true
        
        self.fetchGatheringEvents(type: "Going")
    }
    
    @IBAction func mayBeButtonPressed(_ sender: UIButton) {
        selectedTab = 1
        //self.tabTitleLabel.text = "Your Invitations"
        self.dataObjectArray = [CenesEvent]()
        self.reloadGatherings()
        
        
        self.acceptedBtn.setTitleColor(UIColor.init(red: 155/255, green: 155/255, blue: 155/255, alpha: 1), for: .normal)
        self.pendingBtn.setTitleColor(selectedColor, for: .normal)
        self.declinedBtn.setTitleColor(UIColor.init(red: 155/255, green: 155/255, blue: 155/255, alpha: 1), for: .normal)
        
        self.confirmSelectView.isHidden = true
        self.mayBeSelectView.isHidden = false
        self.declineSelectView.isHidden = true
        self.fetchGatheringEvents(type: "pending")
    }
    
    @IBAction func declineButtonPressed(_ sender: UIButton) {
        selectedTab = 2
        //self.tabTitleLabel.text = "Declined Invitations"
        self.dataObjectArray = [CenesEvent]()
        self.reloadGatherings()
        
        self.acceptedBtn.setTitleColor(UIColor.init(red: 155/255, green: 155/255, blue: 155/255, alpha: 1), for: .normal)
        self.pendingBtn.setTitleColor(UIColor.init(red: 155/255, green: 155/255, blue: 155/255, alpha: 1), for: .normal)
        self.declinedBtn.setTitleColor(selectedColor, for: .normal)
        
        self.confirmSelectView.isHidden = true
        self.mayBeSelectView.isHidden = true
        self.declineSelectView.isHidden = false
        self.fetchGatheringEvents(type: "NotGoing")
    }
    
    
   
   /*
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
    */
    
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
    
    
    @IBAction func openInvitePopup(_ sender: UIButton) {
        
        
        let invitationView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InvitationAcceptView") as! InvitationAcceptView
        
        //invitationView.modalPresentationStyle = .overCurrentContext
        invitationView.modalTransitionStyle = .crossDissolve
        invitationView.invitationData  = self.invitationData
        invitationView.locationModel = self.invitationLocationModel
        invitationView.gatheringView = self
        self.navigationController?.pushViewController(invitationView, animated: true)
        self.isNewInvite = false
        self.invitationView.isHidden = true
        
    }
    
}



extension GatheringViewController :UITableViewDataSource,UITableViewDelegate
{
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        var height = 200;
        
        let obj = dataObjectArray[indexPath.section].sectionObjects[indexPath.row]
        //if (obj.locationStr == nil || obj.locationStr == "") {
        //    height = height - 20;
        //}
        
        var eventUsers = obj.eventUsers;
        var eventMemberCounts: Int = 0;
        for eventUser in eventUsers {
            
            var memebrId: NSNumber = 0;
            let loggedInUserId = setting.value(forKey: "userId") as! NSNumber;
            if let myInteger = Int(eventUser.userId) {
                memebrId = NSNumber(value: myInteger);
            }
            if (memebrId != loggedInUserId) {
                eventMemberCounts = eventMemberCounts + 1;
            }
        }
        if (eventMemberCounts == 0) {
            height = height - 50;
        }
        
        /*if obj.eventUsers.count == 0 && (obj.subTitle == nil || obj.subTitle == ""){
            height = 58
        }else if obj.eventUsers.count == 0 && !(obj.subTitle == nil || obj.subTitle == ""){
            height = 70
        }else if obj.eventUsers.count > 0 && !(obj.subTitle == nil || obj.subTitle == ""){
            height = 113
        }else if obj.eventUsers.count > 0 && (obj.subTitle == nil || obj.subTitle == ""){
            height = 90
        }*/
        
        return CGFloat(height)
            
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataObjectArray[section].sectionObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var obj : CenesCalendarData!
       
         obj = dataObjectArray[indexPath.section].sectionObjects[indexPath.row]
        
        let identifier = "GatheringCardTableViewCell";
        let cell: GatheringCardTableViewCell! = self.gatheringTableView.dequeueReusableCell(withIdentifier: identifier) as? GatheringCardTableViewCell
        
        cell.title.text = obj.title
        cell.startTime.text = obj.time
        let eventMembers: [CenesUser] = obj.eventUsers;
        var owner: CenesUser?
        var memebrId : NSNumber;
        
        var eventMembersExceptOwner: [CenesUser] = [];
        
        var counter: Int = 0;
        for eventMember in eventMembers {
            
            if (counter == 4) {
                break;
            }
            let loggedInUserId = setting.value(forKey: "userId") as! NSNumber;
            if let myInteger = Int(eventMember.userId) {
             memebrId = NSNumber(value: myInteger);
            }else{
                memebrId = 0;
            }
            if (memebrId == loggedInUserId) {
                owner = eventMember;
            } else {
                eventMembersExceptOwner.append(eventMember);
                counter = counter + 1;
            }
        }
        cell.bubbleNumbers = eventMembers.count - 1;
        
        let formattedText = NSMutableAttributedString();
        formattedText.bold((owner?.name)!).normal(" is hosting");
        cell.ownerLabel.attributedText = formattedText;
        if (owner?.photoUrl != nil) {
            cell.profilePic.cacheImage(urlString: (owner?.photoUrl)!)
            cell.profilePic.setRounded()
        } else {
            cell.profilePic.image = #imageLiteral(resourceName: "profile icon");
        }
        
        //Hiding Location View if location is empty or null
        if obj.locationStr == nil || obj.locationStr == "" {
            cell.locationView.isHidden = true;
        } else {
            cell.locationView.isHidden = false;
            cell.location.text = obj.locationStr;
        }
        
        
        //Hiding Horizontal StackView if There are no event Members except Owner
        if eventMembersExceptOwner.count == 0 {
            cell.membersCollectionView.isHidden = true;
        } else {
            cell.membersCollectionView.isHidden = false;
            cell.members = eventMembersExceptOwner;
            cell.reloadFriends();
        }
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataObjectArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        print("Section Header Calls \(section)")
       
        let sectionTitle = dataObjectArray[section].sectionName
        
        //let identifier = "HeaderCell"
        let identifier = "GatheringCardHeaderTableViewCell"
        let cell: GatheringCardHeaderTableViewCell! = self.gatheringTableView.dequeueReusableCell(withIdentifier: identifier) as? GatheringCardHeaderTableViewCell
        
        
        var headerTitleArr: [String]  = sectionTitle!.components(separatedBy: " ");
        let finalDateStr = NSMutableAttributedString();
        finalDateStr.normal(headerTitleArr[0]).bold(headerTitleArr[1]);
        
        cell.headerLabel.attributedText = finalDateStr;
        return cell;
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        let obj = dataObjectArray[indexPath.section].sectionObjects[indexPath.row]
        //  /api/event/delete?event_id={select event id}
        
        if (obj.dataType != "Reminder"){
            
            startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))
            
            WebService().removeEventFromList(EVEntID: obj.eventId) { (returnedDict) in
                if returnedDict["Error"] as? Bool == true {
                    self.stopAnimating()
                    self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                }else{
                    self.stopAnimating()
                    self.viewDidAppear(true)
                    
                    //                self.remindersTableView.deleteRows(at: [indexpath], with: )
                }
            }
        }
        else{
            self.showAlert(title: "Alert!", message:"This is reminder and cannot be deleted.")
        }
        
        
        
        print(obj.eventId)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.selectedTab == 0 || self.selectedTab == 2 {
        
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
                
                var location = dict.value(forKey: "location") as? String
                if location == "" || location == nil {
                    location = "No Location for event"
                }
                
                createGatheringView.locationName = location!
                createGatheringView.eventDetails = (dict.value(forKey: "description") as? String) != nil ? (dict.value(forKey: "description") as? String)! : ""
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
                
                
                let userid = setting.value(forKey: "userId") as! NSNumber
                
                if  dict.value(forKey: "createdById") as! NSNumber == userid {
                    createGatheringView.isOwner = true
                }else{
                    createGatheringView.isOwner = false
                }
                
                createGatheringView.summaryBool = true
                createGatheringView.selectedLocation = locationModel
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
        }else if self.selectedTab == 1{
            
             let obj = dataObjectArray[indexPath.section].sectionObjects[indexPath.row]
            let invitationView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InvitationAcceptView") as! InvitationAcceptView
            
            //invitationView.modalPresentationStyle = .overCurrentContext
            invitationView.modalTransitionStyle = .crossDissolve
            invitationView.invitationData  = obj
            invitationView.locationModel = obj.locationModel
            invitationView.gatheringView = self
            self.navigationController?.pushViewController(invitationView, animated: true)
            self.isNewInvite = false
            self.invitationView.isHidden = true
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
        
        let iconDownloader = IconDownloader(cenesUser: nil, cenesEventData: cenesEventData, notificationData: nil, indexPath: indexPath, photoDiary: nil)
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

