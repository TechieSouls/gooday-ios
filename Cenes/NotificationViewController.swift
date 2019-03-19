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
import SideMenu

class NotificationViewController: UIViewController,NVActivityIndicatorViewable {
    
    
    @IBOutlet weak var notificationTableView: UITableView!
    
    @IBOutlet weak var homeIcon: UIImageView!
    @IBOutlet weak var profilePic: UIImageView!
    
    var loggedInUser: User!;
    var profileImage = UIImage(named: "profile icon")
    var nactvityIndicatorView = NVActivityIndicatorView.init(frame: cgRectSizeLoading, type: NVActivityIndicatorType.lineScaleParty, color: UIColor.white, padding: 0.0);
    
    var image : UIImage!
    var imageDownloadsInProgress = [IndexPath : IconDownloader]()
    var notificationDict = [NotificationData]()
    var earlierDict = [NotificationData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Notifications"
        self.notificationTableView.register(UINib(nibName: "NotificationGatheringTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "NotificationGatheringTableViewCell")
        
        self.loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        self.notificationTableView.isHidden = true
        // Do any additional setup after loading the view.
        self.loadNotification();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpNavBar();
        self.navigationController?.navigationBar.shouldRemoveShadow(true)
        if self.loggedInUser.photo != nil {
            let webServ = WebService()
            webServ.profilePicFromFacebook(url:  String(self.loggedInUser.photo), completion: { image in
                self.profileImage = image
                self.setUpNavBar()
            })
        }
    }

    
    @objc func profilePicPressed(profilePicGesture: UITapGestureRecognizer) {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @objc func homePicPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func loadNotification() -> Void {
        let webservice = WebService()
        startAnimating(loadinIndicatorSize, message: "Loading...", type: self.nactvityIndicatorView.type)
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
        
         notificationDict = [NotificationData]()
         earlierDict = [NotificationData]()
        self.notificationTableView.reloadData()
        
        if resultArray.count > 0 {
        self.notificationTableView.isHidden = false
        for result in resultArray {
            let data = result as! NSDictionary
            
            let keyNum = data.value(forKey: "createdAt") as! NSNumber
            let key = "\(keyNum)"
            
            
            let notification = NotificationData().loadNotificationData(notificationDict: data);
            
            let isTimeNew = self.checkTimeIsNew(timeStamp: key)
            self.notificationDict.append(notification)
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
        
        let homeButton = UIButton.init(type: .custom)
        homeButton.setImage(UIImage(named: "homeSelected"), for: .normal)
        homeButton.frame = CGRect.init(x: 0, y: 0, width: 35, height: 35)
        homeButton.widthAnchor.constraint(equalToConstant: 35.0).isActive = true
        homeButton.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        
        homeButton.addTarget(self, action: #selector(homeButtonPressed), for: .touchUpInside)
        
        let rightBarButton = UIBarButtonItem.init(customView: homeButton)
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func homeButtonPressed(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func profileButtonPressed(){
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }

}

    extension NotificationViewController : UITableViewDelegate , UITableViewDataSource
    {

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let identifier = "NotificationGatheringTableViewCell"
            let cell : NotificationGatheringTableViewCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? NotificationGatheringTableViewCell
            cell.selectionStyle = .none
            
            let notification = self.notificationDict[indexPath.row]
            
            //cell.cellText.attributedText = self.getTitleCell(sender: notification.senderName!, title: notification.title!, message: notification.message!)
            
            //cell.timeLabel.text = notification.time
            
            if (notification.readStatus == "Read") {
                cell.notificationBackground?.backgroundColor = unselectedColor
                cell.readUnReadText.isHidden = false;
                cell.timeLabel.textColor = unselectedColor;
                cell.daysAgoText.textColor = unselectedColor;
                cell.readUnReadText.textColor = unselectedColor;
            } else {
                cell.notificationBackground?.backgroundColor = cenesLabelBlue
                cell.readUnReadText.isHidden = true;
                cell.timeLabel.textColor = selectedColor;
                cell.daysAgoText.textColor = selectedColor;
            }
            
            cell.cellText.text = "\(notification.senderName!) \(notification.title!) \(notification.message!)";
            
            if let user = notification.user {
                cell.profileImage.sd_setImage(with: URL(string: user.photo), placeholderImage: UIImage(named: "cenes_user_no_image"));
            } else {
                cell.profileImage.image = #imageLiteral(resourceName: "profile icon")
            }
            
            let timeOfNotificaiton = Date.init(millis: notification.time!);
            
            cell.timeLabel.text = timeOfNotificaiton.dMMM();
        
            let numberOfDays = Util().daysBetweenDates(startDate: Date.init(millis: notification.time!), endDate: Date());
            if (numberOfDays == 0) {
                
                let numberOfHours = Util().hoursBetweenDates(startDate: Date.init(millis: notification.time!), endDate: Date());
                if (numberOfHours == 0) {
                    cell.daysAgoText.text = "Just Now";
                } else {
                    cell.daysAgoText.text = "\(numberOfHours) hours ago";
                }
            } else {
                cell.daysAgoText.text = "\(numberOfDays) days ago";
            }
            /*if let icon = notification.notificationImage {
                cell.profileImage.image = icon
            } else {
                if notification.notificationImageURL != nil {
                    //self.startIconDownload(notificationData: notification, forIndexPath: indexPath)
                    cell.profileImage.image = #imageLiteral(resourceName: "profile icon")
                }else{
                    cell.profileImage.image = #imageLiteral(resourceName: "profile icon")
                }
                
            }*/
            return cell
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.notificationDict.count;
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            var notification : NotificationData!
            
            
             notification = self.notificationDict[indexPath.row]
            
            let notificationTypeId = notification?.notificationTypeId as! NSNumber
            
            
            if (notification.readStatus != "Read") {
                let queryStr = "userId=\(String(loggedInUser.userId))&notificationTypeId=\(notificationTypeId)";
                
                NotificationService().markNotificationAsRead(queryStr: queryStr) {(returnedDict)
                    in
                }
            }
            
            GatheringService().eventInfoTask(eventId: Int64(truncating: notificationTypeId)) {(returnedDict) in
                
                if (returnedDict.value(forKey: "success") as! Bool) {
                    let data = returnedDict.value(forKey: "data") as! NSDictionary;
                    let event = Event().loadEventData(eventDict: data);
                    event.eventClickedFrom = "Notification";
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "GatheringPreviewController") as! GatheringPreviewController
                    newViewController.event = event;
                    self.navigationController?.pushViewController(newViewController, animated: true)

                } else {
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "GatheringExpiredViewController") as! GatheringExpiredViewController
                    self.navigationController?.pushViewController(newViewController, animated: true);
                }
                
            }
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 85;
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
