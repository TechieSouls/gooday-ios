//
//  NotificationViewController+TableViewExt.swift
//  Deploy
//
//  Created by Cenes_Dev on 02/04/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation

extension NotificationViewController : UITableViewDelegate , UITableViewDataSource
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "NotificationGatheringTableViewCell"
        let cell : NotificationGatheringTableViewCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? NotificationGatheringTableViewCell
        
        if (self.notificationDtos.count != 0) {
            let notification = self.notificationDtos[indexPath.section].notifications[indexPath.row]
            
            //print(notification.event?.title);
            if (notification.type == "Welcome") {
                
                cell.profileImage.image = UIImage.init(named: "notification_alert_icon");
                
            } else {
                
                if let user = notification.user {
                    //print(user.photo);
                    if (user.photo != nil) {
                        cell.profileImage.sd_setImage(with: URL(string: user.photo!), placeholderImage: UIImage(named: "profile_pic_no_image"));
                    } else {
                        cell.profileImage.image = #imageLiteral(resourceName: "profile_pic_no_image")
                    }
                } else {
                    cell.profileImage.image = #imageLiteral(resourceName: "profile_pic_no_image")
                }
            }
            
            
            //print("Message : ", notification.message);
            cell.message.text = notification.message;
            
            if (notification.type != "Welcome") {
                cell.title.text = "(\(String(notification.title!)))";
            } else {
                cell.title.text = "";
            }
            if (notification.readStatus == "Read") {
                cell.title.textColor = UIColor.darkGray;
                cell.message.textColor = UIColor.darkGray;
                cell.circleButtonView.isHidden = true;
            } else {
                cell.title.textColor = UIColor.black;
                cell.message.textColor = UIColor.black;
                
                if (notification.action == "AcceptDecline") {
                    let searchString = "accepted|declined"
                    let attributed = NSMutableAttributedString(string: notification.message!)
                    do {
                        let regex = try! NSRegularExpression(pattern: searchString,options: .caseInsensitive)
                        for match in regex.matches(in: notification.message!, options: NSRegularExpression.MatchingOptions(), range: NSRange(location: 0, length: notification.message!.characters.count)) as [NSTextCheckingResult] {
                            attributed.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.orange, range: match.range)
                        }
                        cell.message.attributedText = attributed
                    }
                }
                cell.circleButtonView.isHidden = false;
                let tapGestureRecognizer = MyTapGesture(target: self, action: #selector(self.connected(_:)))
                cell.rightCornerView.addGestureRecognizer(tapGestureRecognizer)
                tapGestureRecognizer.notificationId = notification.notificationId;
            }
            
            let pastDateInMillis = Date().millisecondsSince1970 - Date(milliseconds: Int(notification.createdAt)).millisecondsSince1970

            let days = pastDateInMillis/(1000*3600*24);
            if (days == 0) {
                let hours = pastDateInMillis/(1000*3600);
                
                if (hours < 1) {
                    let minutes = hours/(1000*60);
                    if (minutes < 1) {
                        
                        let sec = minutes/1000;
                        cell.happen.text = "\(sec)s";

                    } else {
                        cell.happen.text = "\(minutes)m";
                    }
                } else {
                    cell.happen.text = "\(hours)h";
                }
            } else {
                
                if (days < 31) {
                    cell.happen.text = "\(days)d";
                } else {
                    let months = days / 30;
                    if (months != 0) {
                        cell.happen.text = "\(months)mo";
                    }
                }
            }
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.notificationDtos.count;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.notificationDtos[section].notifications.count);
        return self.notificationDtos[section].notifications.count;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let notification : NotificationData = self.notificationDtos[indexPath.section].notifications[indexPath.row]
        
        let notificationId = Int(notification.notificationId);
        
        if (notification.readStatus != "Read") {
            let queryStr = "notificationId=\(String(notificationId))";
            NotificationService().markNotificationReadByNotificationId(queryStr: queryStr, token: self.loggedInUser.token, complete: {(returnedDict) in
                for notification in self.allNotifications {
                    if (notification.notificationId == notificationId) {
                        notification.readStatus = "Read";
                        
                        sqlDatabaseManager.updateNotificationReadStatusByNotificationId(readStatus: "Read", notification: notification)
                        //NotificationModel().updateNotificationReadStatus(readStatus: "Read", notificationId: Int32(notificationId));
                    }
                }
                
                self.notificationDtos = NotificationManager().parseNotificationData(notifications: self.allNotifications, notificationDtos: self.notificationDtos);
                self.notificationTableView.reloadData();
            });
        }
        
        //print(notification.description);
        if (notification.event != nil) {
            //event!.eventClickedFrom = "Notification";
            /*let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "GatheringExpiredViewController") as! GatheringExpiredViewController
            self.navigationController?.pushViewController(newViewController, animated: true);*/
            let newViewController = storyboard!.instantiateViewController(withIdentifier: "GatheringInvitationViewController") as! GatheringInvitationViewController
            newViewController.event = notification.event;
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60;
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50;
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if (self.notificationDtos.count == 0) {
            return UIView();
        }
        
        let title = self.notificationDtos[section].header;
        
        let identifier = "HeaderTableViewCell"
        let cell : HeaderTableViewCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? HeaderTableViewCell
        cell.headerLabel.text = title;
        
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 25))
        returnedView.backgroundColor = UIColor.white;
        
        if (title == "Seen") {
            let gapView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 10))
            gapView.backgroundColor = UIColor.white
            //returnedView.addSubview(gapView);

            let topBorder = UIView();
            topBorder.backgroundColor = themeColor
            topBorder.frame = CGRect(x: 0, y: 0, width: returnedView.frame.size.width, height: 1);
            returnedView.addSubview(topBorder);
        }
        returnedView.addSubview(cell.headerLabel)
        return returnedView
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            
        self.notificationDtos = NotificationManager().parseNotificationData(notifications: self.allNotifications, notificationDtos: self.notificationDtos);

        //if (indexPath.section < notificationsDtoPerPage.count && indexPath.row == notificationsDtoPerPage[indexPath.section].notifications.count - 1) {
        
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {

            /*print(self.allNotifications.count, self.totalNotificationCounts);
            if (self.allNotifications.count < self.totalNotificationCounts) {
                self.pageNumber = self.pageNumber + 10;
                self.countToTenRecords = 0;
                self.loadNotification();
            }*/
            
            // print("this is the last cell")
            if (self.allNotifications.count < self.totalNotificationCounts) {
                self.spinner.startAnimating()
                self.spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
                
                self.notificationTableView.tableFooterView = self.spinner
                self.notificationTableView.tableFooterView?.isHidden = false
                
                self.loadNotification();
            }
        } else {
            self.notificationTableView.tableFooterView?.isHidden = true
        }
    }
        
    @objc func connected(_ sender:MyTapGesture){
        //print(sender.notificationId)
        let queryStr = "notificationId=\(String(sender.notificationId))";

        //NotificationService().markNotificationReadByNotificationId(queryStr: queryStr, token: self.loggedInUser.token, complete: {(returnedDict) in
          //  self.initilize();
        //});
        
        NotificationService().markNotificationReadByNotificationId(queryStr: queryStr, token: self.loggedInUser.token, complete: {(returnedDict) in
            
            });
        
        for notification in allNotifications {
            if (notification.notificationId == sender.notificationId) {
                notification.readStatus = "Read";
            }
        }
        self.notificationDtos = NotificationManager().parseNotificationData(notifications: self.allNotifications, notificationDtos: self.notificationDtos);
        self.notificationTableView.reloadData();
    }
}

class MyTapGesture: UITapGestureRecognizer {
    var notificationId = Int32();
}
