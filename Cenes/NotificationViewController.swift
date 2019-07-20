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

class NotificationViewController: UIViewController, NVActivityIndicatorViewable {
    
    
    @IBOutlet weak var notificationTableView: UITableView!
    
    @IBOutlet weak var notNotificationLabel: UILabel!
    
    var loggedInUser: User!;
    var profileImage = UIImage(named: "profile icon")
    var nactvityIndicatorView = NVActivityIndicatorView.init(frame: cgRectSizeLoading, type: NVActivityIndicatorType.lineScaleParty, color: UIColor.white, padding: 0.0);
    
    var image : UIImage!
    var imageDownloadsInProgress = [IndexPath : IconDownloader]()
    var notificationPerPage = [NotificationData]()
    var allNotifications = [NotificationData]()
    var notificationDtos = [NotificationDto]();
    var pageNumber = 0;
    var totalNotificationCounts = 0;
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.notificationTableView.register(UINib(nibName: "NotificationGatheringTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "NotificationGatheringTableViewCell")
        self.notificationTableView.register(UINib(nibName: "HeaderTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "HeaderTableViewCell")
        
        self.notificationTableView.isHidden = true
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            self.notificationTableView.refreshControl = refreshControl
        } else {
            self.notificationTableView.addSubview(refreshControl)
        }
        // Configure Refresh Control
        self.refreshControl.addTarget(self, action: #selector(refreshNotificationData(_:)), for: .valueChanged)

        
        self.loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        
        self.tabBarController?.delegate = self
        
        
        if Connectivity.isConnectedToInternet {
            self.initilize();
        } /*else {
            
            self.allNotifications = NotificationPersistanceManager().getAllNotifications();
            self.notificationPerPage = NotificationPersistanceManager().getAllNotifications();
            self.notificationDtos = NotificationManager().parseNotificationData(notifications: self.allNotifications, notificationDtos: self.notificationDtos);
            
            self.notificationTableView.layer.removeAllAnimations();
            self.notificationTableView.reloadData();
        }*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.setUpNavBar();
        self.navigationController?.navigationBar.shouldRemoveShadow(true)
        tabBarController?.tabBar.isHidden = false;
        let myView = UIView.init(frame: CGRect.init(x: 0, y: -1, width: ((self.tabBarController?.tabBar.frame.width)!), height: 2));
        myView.backgroundColor = themeColor;
        self.tabBarController?.tabBar.addSubview(myView);
        
        /*if self.loggedInUser.photo != nil {
            let webServ = WebService()
            webServ.profilePicFromFacebook(url:  String(self.loggedInUser.photo), completion: { image in
                self.profileImage = image
                self.setUpNavBar()
            })
        }*/
        self.tabBarController?.setTabBarDotVisible(visible: false);
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Connectivity.isConnectedToInternet {
            //self.initilize();
            WebService().resetBadgeCount();
        }
    }
    
    @objc func profilePicPressed(profilePicGesture: UITapGestureRecognizer) {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @objc func homePicPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc private func refreshNotificationData(_ sender: Any) {
        // Fetch Weather Data
        initilize();
    }
    
    func initilize() {
        
        self.loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        self.pageNumber = 0;
        self.totalNotificationCounts = 0;
        self.notificationPerPage = [NotificationData]();
        self.allNotifications = [NotificationData]();
        self.notificationDtos = [NotificationDto]();
        
        let queryStr = "recepientId=\(String(self.loggedInUser.userId))";
        NotificationService().findNotificationCounts(queryStr: queryStr, token: self.loggedInUser.token, complete: {(response) in
            self.refreshControl.endRefreshing()
            if (response["success"] as! Bool == true) {
                self.totalNotificationCounts = response["data"] as! Int;
                print("Total Notifications : ",self.totalNotificationCounts);
                if (self.totalNotificationCounts > 0) {
                    self.loadNotification();
                } else {
                    self.notificationTableView.isHidden = true;
                    self.notNotificationLabel.isHidden = false;
                }
            } else {
                self.errorAlert(message: response["message"] as! String)
            }
        })
    }
    
    func loadNotification() -> Void {
        
        let queryStr = "userId=\(String(self.loggedInUser.userId))&pageNumber=\(self.pageNumber)&offset=20";
        NotificationService().getPageableNotifications(queryStr: queryStr, token: self.loggedInUser.token, complete: {(response) in
            
            self.notificationTableView.tableFooterView = nil
            self.notificationTableView.tableFooterView?.isHidden = true
            
            if (response["success"] as! Bool == true) {
                
                let notificationsNsArray = response["data"] as! NSArray;
                
                
                if (notificationsNsArray.count > 0) {
                     self.notificationTableView.isHidden = false
                     self.notificationPerPage = NotificationData().loadNotificationList(notificationArray: notificationsNsArray);
                    for notification in self.notificationPerPage {
                        self.allNotifications.append(notification);
                    }
                    
                    //Save Notification Locally.
                    /*for notification in self.allNotifications {
                        NotificationPersistanceManager().saveNotification(notificationData: notification);
                    }*/
                    
                    self.notificationDtos = NotificationManager().parseNotificationData(notifications: self.allNotifications, notificationDtos: self.notificationDtos);
                    
                    self.notificationTableView.layer.removeAllAnimations();
                    self.notificationTableView.reloadData();
                    
                }
            } else {
                self.errorAlert(message: response["message"] as! String)
            }
            
        });
        
        /*let webservice = WebService()
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
        }*/
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
    
    
    
    /*func parseResults(resultArray:NSArray){
        
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
    }*/
    
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
        //self.navigationItem.leftBarButtonItem = barButton
        
        let homeButton = UIButton.init(type: .custom)
        homeButton.setImage(UIImage(named: "homeSelected"), for: .normal)
        homeButton.frame = CGRect.init(x: 0, y: 0, width: 35, height: 35)
        homeButton.widthAnchor.constraint(equalToConstant: 35.0).isActive = true
        homeButton.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        
        homeButton.addTarget(self, action: #selector(homeButtonPressed), for: .touchUpInside)
        
        let rightBarButton = UIBarButtonItem.init(customView: homeButton)
        //self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func homeButtonPressed(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func profileButtonPressed(){
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
}

extension NotificationViewController: UITabBarControllerDelegate {
    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if (self.allNotifications.count > 0) {
            self.notificationTableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
        }
    }
}

    
