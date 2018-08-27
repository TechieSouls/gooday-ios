//
//  NotificationViewController.swift
//  Cenes
//
//  Created by Redblink on 09/10/17.
//  Copyright © 2017 Redblink Pvt Ltd. All rights reserved.
//

import UIKit
import IoniconsSwift
import NVActivityIndicatorView

class NotificationViewController: UIViewController,NVActivityIndicatorViewable {
    
    
    @IBOutlet weak var notificationTableView: UITableView!
    
    var profileImage = UIImage(named: "profile icon")
    
    var image : UIImage!
    var imageDownloadsInProgress = [IndexPath : IconDownloader]()
    var newDict = [NotificationData]()
    var earlierDict = [NotificationData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Notifications"
        self.navigationItem.hidesBackButton = true
        if(image == nil)
        {
            
            
            if setting.value(forKey: "photo") != nil {
            let webServ = WebService()
            webServ.profilePicFromFacebook(url: setting.value(forKey: "photo")! as! String, completion: { image in
                self.profileImage = image
                self.setUpNavBar()
            })
            }
        }else{
            self.profileImage? = image
        }
        self.setUpNavBar()
        self.notificationTableView.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let webservice = WebService()
        startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))
        webservice.getNotifications(){ (returnedDict) in
            print("Got results")
            //Setting badge counts in prefrences
            let userDefaults = UserDefaults.standard
            userDefaults.setValue(0 , forKey: "badgeCounts");
            userDefaults.synchronize();
            
            self.stopAnimating()
            if returnedDict.value(forKey: "Error") as? Bool == true {
                
                self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                
            }else{
                print(returnedDict)
                self.parseResults(resultArray: (returnedDict["data"] as? NSArray)!)
            }
            
        }
    }
    
    
    
    func getTitleCell(sender : String ,title : String , message: String) -> NSAttributedString{
        
        var attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14, weight: .semibold),
                          NSAttributedStringKey.foregroundColor: UIColor.black]
        
        let first = NSMutableAttributedString(string:"\(sender) ", attributes: attributes)
        let second = NSMutableAttributedString(string:" \(title)", attributes: attributes)
        
        attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13, weight: .medium),
                      NSAttributedStringKey.foregroundColor: UIColor.darkGray]
        
        let third = NSMutableAttributedString(string:message, attributes: attributes)
        
        let final = NSMutableAttributedString()
        final.append(first)
        final.append(third)
        final.append(second)
        return final
    }
    
    func checkTimeIsNew(timeStamp: String) -> Bool{
        let timeinterval : TimeInterval = Double(timeStamp)! / 1000 // convert it in to NSTimeInteral
        let dateFromServer = NSDate(timeIntervalSince1970:timeinterval)
        
        let calendar = Calendar.current
        let now = Date()
        let earliest = (now as NSDate).earlierDate(dateFromServer as Date)
        let latest = (earliest == now) ? dateFromServer as Date : now
        let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
        
        
        if (components.year! >= 1){
            
            return false
        } else if (components.month! >= 2) {
            return false
        } else if (components.month! >= 1){
            return false
        } else if (components.weekOfYear! >= 2) {
            return false
        } else if (components.weekOfYear! >= 1){
            return false
        } else if (components.day! >= 2) {
            return false
        } else if (components.day! >= 1){
            return false
        } else if (components.hour! >= 1) {
            return false
        }else if (components.minute! >= 10){
            return false
        } else {
            return true
        }
        
    }
    
    func getTimeFromTimestamp(timeStamp:String) -> String{
        let timeinterval : TimeInterval = Double(timeStamp)! / 1000 // convert it in to NSTimeInteral
        let dateFromServer = NSDate(timeIntervalSince1970:timeinterval) // you can the Date object from here
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMMM d" //"yyyy-MM-dd"
        let dateFirst = dateFormatter.string(from: dateFromServer as Date).capitalized
        
        dateFormatter.dateFormat = "h:mm a"
        let dateSecond = dateFormatter.string(from: dateFromServer as Date).capitalized
        let finalDate = dateFirst+" at "+dateSecond
        return finalDate
    }
    
    
    
    func parseResults(resultArray:NSArray){
        
         newDict = [NotificationData]()
         earlierDict = [NotificationData]()
        self.notificationTableView.reloadData()
        
        if resultArray.count > 0 {
        self.notificationTableView.isHidden = false
        for result in resultArray {
            let data = result as! NSDictionary
            
            let keyNum = data.value(forKey: "createdAt") as! NSNumber
            let key = "\(keyNum)"
            
            
            let notification = NotificationData()
            
            notification.senderName = data.value(forKey: "sender") as? String
            notification.title = data.value(forKey: "title") as? String
            notification.message = data.value(forKey: "message") as? String
            notification.time =  self.getTimeFromTimestamp(timeStamp: key)
            notification.notificationImageURL = data.value(forKey: "senderPicture") as? String
            notification.notificationTypeId = data.value(forKey: "notificationTypeId") as? NSNumber
             notification.notificationId = data.value(forKey: "notificationId") as? NSNumber
            notification.type = data.value(forKey: "type") as? String
            
            let isTimeNew = self.checkTimeIsNew(timeStamp: key)
            if isTimeNew {
                self.newDict.append(notification)
            }else{
                self.earlierDict.append(notification)
            }
            
        }
        
        self.notificationTableView.reloadData()
        }else{
            self.notificationTableView.isHidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpNavBar(){
        let profileButton = UIButton.init(type: .custom)
       // let image = self.profileImage?.compressImage(newSizeWidth: 35, newSizeHeight: 35, compressionQuality: 1.0)
        profileButton.imageView?.contentMode = .scaleAspectFill
        profileButton.setImage(self.profileImage, for: UIControlState.normal)
        profileButton.frame = CGRect.init(x: 0, y: 0, width: 35, height: 35)
        profileButton.layer.cornerRadius = profileButton.frame.height/2
        profileButton.clipsToBounds = true
        profileButton.widthAnchor.constraint(equalToConstant: 35.0).isActive = true
        profileButton.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        
        profileButton.addTarget(self, action: #selector(profileButtonPressed), for: .touchUpInside)
        profileButton.backgroundColor = UIColor.white
        
        let barButton = UIBarButtonItem.init(customView: profileButton)
        self.navigationItem.leftBarButtonItem = barButton
        
        /*let notificationButton = UIButton.init(type: .custom)
        
        //notificationButton.setImage(Ionicons.androidNotifications.image(25, color: commonColor), for: .selected)
        notificationButton.setImage(Ionicons.androidNotifications.image(25, color: UIColor.white), for: .normal)
        notificationButton.isSelected = true
        notificationButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        notificationButton.layer.cornerRadius = notificationButton.frame.height/2
        notificationButton.clipsToBounds = true
        notificationButton.addTarget(self, action: #selector(notificationBarButtonPressed), for: .touchUpInside)
        
        let widthConstraint2 = notificationButton.widthAnchor.constraint(equalToConstant: 30)
        let heightConstraint2 = notificationButton.heightAnchor.constraint(equalToConstant: 30)
        heightConstraint2.isActive = true
        widthConstraint2.isActive = true
        
        let notificationBarButton = UIBarButtonItem.init(customView: notificationButton)
        
        
       
        
        
        
        let calendarButton = UIButton.init(type: .custom)
        
        calendarButton.setImage(Ionicons.iosCalendarOutline.image(25, color: UIColor.white), for: UIControlState.normal)
        //calendarButton.setImage(Ionicons.iosCalendarOutline.image(25, color: commonColor), for: UIControlState.selected)
        calendarButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        calendarButton.layer.cornerRadius = calendarButton.frame.height/2
        calendarButton.clipsToBounds = true
        calendarButton.addTarget(self, action: #selector(calendarBarButtonPressed), for: .touchUpInside)
        
        let calendarBarButton = UIBarButtonItem.init(customView: calendarButton)
        
        let widthConstraint = calendarButton.widthAnchor.constraint(equalToConstant: 30)
        let heightConstraint = calendarButton.heightAnchor.constraint(equalToConstant: 30)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        
        self.navigationItem.rightBarButtonItems = [calendarBarButton,notificationBarButton]
        */
    }
    
    @objc func calendarBarButtonPressed(){
        
    }
    
    @objc func notificationBarButtonPressed(){
    
    }
    
    @objc func profileButtonPressed(){
        self.navigationController?.popViewController(animated: true)
    }

}

    extension NotificationViewController : UITableViewDelegate , UITableViewDataSource
    {

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            
            
            
            let identifier = "NotificationCell"
            let cell : NotificationCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? NotificationCell
            
            if indexPath.section == 0 {
                if self.newDict.count > 0 {
                    let notification = self.newDict[indexPath.row]
                    
                    cell.cellText.attributedText = self.getTitleCell(sender: notification.senderName!, title: notification.title!, message: notification.message!)
                    
                    cell.timeLabel.text = notification.time
                    
                    if let icon = notification.notificationImage {
                        cell.profileImage.image = icon
                    } else {
                        if notification.notificationImageURL != nil {
                            self.startIconDownload(notificationData: notification, forIndexPath: indexPath)
                            cell.profileImage.image = #imageLiteral(resourceName: "profile icon")
                        }else{
                            cell.profileImage.image = #imageLiteral(resourceName: "profile icon")
                        }
                        
                    }

                }else{
                    
                    let notification = self.earlierDict[indexPath.row]
                    
                    cell.cellText.attributedText = self.getTitleCell(sender: notification.senderName!, title: notification.title!, message: notification.message!)
                    
                    cell.timeLabel.text = notification.time
                    if let icon = notification.notificationImage {
                        cell.profileImage.image = icon
                    } else {
                        if notification.notificationImageURL != nil {
                            self.startIconDownload(notificationData: notification, forIndexPath: indexPath)
                            cell.profileImage.image = #imageLiteral(resourceName: "profile icon")
                        }else{
                            cell.profileImage.image = #imageLiteral(resourceName: "profile icon")
                        }
                        
                    }
                }
            }else{
                let notification = self.earlierDict[indexPath.row]
                
                cell.cellText.attributedText = self.getTitleCell(sender: notification.senderName!, title: notification.title!, message: notification.message!)
                
                cell.timeLabel.text = notification.time
                if let icon = notification.notificationImage {
                    cell.profileImage.image = icon
                } else {
                    if notification.notificationImageURL != nil {
                        self.startIconDownload(notificationData: notification, forIndexPath: indexPath)
                        cell.profileImage.image = #imageLiteral(resourceName: "profile icon")
                    }else{
                        cell.profileImage.image = #imageLiteral(resourceName: "profile icon")
                    }
                    
                }
            }
            
            
            
            return cell
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            if self.newDict.count > 0 {
                return 2
            }else if self.earlierDict.count > 0{
            return 1
            }else{
                return 0
            }
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if self.newDict.count > 0 {
                if section == 0 {
                    return self.newDict.count
                }else{
                    return self.earlierDict.count
                }
            }else{
                    return self.earlierDict.count
                    
                }
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 44
        }

        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            var notification : NotificationData!
            
             if indexPath.section == 0 {
                    if self.newDict.count > 0 {
                         notification = self.newDict[indexPath.row]
                    }else{
                         notification = self.earlierDict[indexPath.row]
                    }
             }else{
                 notification = self.earlierDict[indexPath.row]
            }
            let notificationID = notification?.notificationId as! NSNumber
            
            let webservice = WebService()
            webservice.getNotificationsRead(){ (returnedDict) in
                print("Got results")

                if returnedDict.value(forKey: "Error") as? Bool == true {
                    
                    self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                    
                }
                else
                {
                    print(returnedDict)
                    
                    if notification.type != nil && notification.type == "Gathering"
                    {
                        if let cenesTabBarViewControllers = appDelegate?.cenesTabBar?.viewControllers {
                            appDelegate?.cenesTabBar?.selectedIndex = 2
                            
                            
                            let gathering = (cenesTabBarViewControllers[2] as? UINavigationController)?.viewControllers.first as? GatheringViewController
                            
                            
                            gathering?.dismiss(animated: false, completion: nil)
                            (cenesTabBarViewControllers[2] as? UINavigationController)?.viewControllers = [gathering!]
                            self.navigationController?.popViewController(animated: true)
                            gathering?.invitationView.isHidden = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                gathering?.isNewInvite = true
                                gathering?.invitationView.isHidden = true
                                let eventId = "\(notification.notificationTypeId!)"
                                let invitationData = CenesCalendarData()
                                invitationData.eventId = eventId
                                gathering?.invitationData = invitationData
                                gathering?.setInvitation()
                            }
                        }
                    }else if notification.type == "Reminder"{
                        let eventId = notification.notificationTypeId!
                        appDelegate?.showReminderInvite(forTitle: notification.title, reminderID: eventId)
                    }
                }
                
            }

        }
        
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
            print("Section Header Calls \(section)")
            // let sectionTitle = objectArray[section].sectionName
            let identifier = "NotificationHeaderCell"
            let cell: NotificationHeaderCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? NotificationHeaderCell
            if self.newDict.count > 0 {
            if section == 0{
                cell.titleLabel.text = "NEW"
            }else{
                cell.titleLabel.text = "EARLIER"
            }
            }else{
                cell.titleLabel.text = "EARLIER"
            }
            return cell
        }
        
        func startIconDownload(notificationData: NotificationData, forIndexPath indexPath: IndexPath) {
            guard self.imageDownloadsInProgress[indexPath] == nil else { return }
            
            let iconDownloader = IconDownloader(cenesUser: nil, cenesEventData: nil, notificationData: notificationData, indexPath: indexPath, photoDiary: nil)
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
 
    }


extension NotificationViewController: IconDownloaderDelegate {
    func iconDownloaderDidFinishDownloadingImage(_ iconDownloader: IconDownloader, error: NSError?) {
        guard let cell = self.notificationTableView.cellForRow(at:iconDownloader.indexPath as IndexPath) as? NotificationCell else {
            print("Not got cell")
            return }
        if let error = error {
            print("error downloading Image")
            //fatalError("Error loading thumbnails: \(error.localizedDescription)")
        } else {
            cell.profileImage?.image = iconDownloader.notificationData.notificationImage
            //  print(iconDownloader.cenesEventData.title+" user profile updated")
        }
        self.imageDownloadsInProgress.removeValue(forKey: iconDownloader.indexPath as IndexPath)
    }
}
