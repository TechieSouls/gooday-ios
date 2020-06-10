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
        cell.partyIcon.isHidden = true;

        if (self.notificationDtos.count != 0) {
            let notification = self.notificationDtos[indexPath.section].notifications[indexPath.row]
        
            //print("Message : ", notification.message);
            let font = UIFont(name: "Avenir-Medium", size: 15.0)
            let fontAttributes = [NSAttributedString.Key.font: font]
            let myText = notification.message!
            let size = (myText as NSString).size(withAttributes: fontAttributes)
            if (size.width > 250) {
                
                let identifier = "NotificationGatheringTwoLineTableViewCell"
                let cell : NotificationGatheringTwoLineTableViewCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? NotificationGatheringTwoLineTableViewCell
                cell.partyIcon.isHidden = true;

                if (notification.type == "Welcome") {
                    
                    cell.profilePic.image = UIImage.init(named: "notification_alert_icon");
                    
                } else {
                    
                    if let user = notification.user {
                        //print(user.photo);
                        if (user.photo != nil) {
                            cell.profilePic.sd_setImage(with: URL(string: user.photo!), placeholderImage: UIImage(named: "profile_pic_no_image"));
                        } else {
                            cell.profilePic.image = #imageLiteral(resourceName: "profile_pic_no_image")
                        }
                    } else {
                        cell.profilePic.image = #imageLiteral(resourceName: "profile_pic_no_image")
                    }
                }
                
                cell.message.text = notification.message;
               if (notification.type != "Welcome") {
                   cell.title.text = "(\(String(notification.title!)))";
               } else {
                   cell.title.text = "";
               }
               if (notification.readStatus == "Read") {
                   cell.title.textColor = UIColor.init(red: 89/255, green: 87/255, blue: 87/255, alpha: 1);
                   cell.message.textColor = UIColor.init(red: 89/255, green: 87/255, blue: 87/255, alpha: 1);
                cell.backgroundColor = UIColor.white;
                   //cell.circleButtonView.isHidden = true;
               } else {
                cell.backgroundColor = UIColor.init(red: 151/255, green: 199/255, blue: 255/255, alpha: 0.2);

                   cell.title.textColor = UIColor.black;
                   cell.message.textColor = UIColor.black;
                   //cell.circleButtonView.isHidden = false;
                   let tapGestureRecognizer = MyTapGesture(target: self, action: #selector(self.connected(_:)))
                   cell.rightCornerView.addGestureRecognizer(tapGestureRecognizer)
                   tapGestureRecognizer.notificationId = notification.notificationId;
               }
                
                if (notification.action == "AcceptDecline") {
                    let searchString = "accepted|declined"
                    let attributed = NSMutableAttributedString(string: notification.message!)
                    do {
                        let regex = try! NSRegularExpression(pattern: searchString,options: .caseInsensitive)
                        for match in regex.matches(in: notification.message!, options: NSRegularExpression.MatchingOptions(), range: NSRange(location: 0, length: notification.message!.count)) as [NSTextCheckingResult] {
                            attributed.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange, range: match.range)
                        }
                        cell.message.attributedText = attributed
                    }
                } else if (notification.action == "Create") {
                    cell.partyIcon.isHidden = false;
                    cell.partyIcon.image = UIImage.init(named: "mdi_party_popper");
                 } else if (notification.action == "Chat") {
                    cell.partyIcon.isHidden = false;
                    cell.partyIcon.image = UIImage.init(named: "notificaiton_chat_icon");
                }
                
            let pastDateInMillis = Date().millisecondsSince1970 - notification.createdAt

               let days = Int(pastDateInMillis/(1000*3600*24));
               if (days == 0) {
                   let hours = Int(pastDateInMillis/(1000*3600));
                   
                   if (hours < 1) {
                       let minutes = Int(pastDateInMillis/(1000*60));
                       if (minutes < 1) {
                           
                           let sec = Int(pastDateInMillis/1000);
                           cell.happen.text = "\(sec)s";

                       } else {
                           cell.happen.text = "\(minutes)m";
                       }
                   } else {
                       cell.happen.text = "\(hours)h";
                   }
               } else {
                   
                   if (days < 7) {
                       cell.happen.text = "\(days)d";
                   } else {
                       cell.happen.text = "\(days/7)w";
                   }
               }
                return cell;
            }
                        
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
            
            cell.message.text = notification.message;
               if (notification.type != "Welcome") {
                   cell.title.text = "(\(String(notification.title!)))";
               } else {
                   cell.title.text = "";
               }
               if (notification.readStatus == "Read") {
                   cell.title.textColor = UIColor.init(red: 89/255, green: 87/255, blue: 87/255, alpha: 1);
                   cell.message.textColor = UIColor.init(red: 89/255, green: 87/255, blue: 87/255, alpha: 1);
                    cell.backgroundColor = UIColor.white;
                   //cell.circleButtonView.isHidden = true;
               } else {
                    cell.backgroundColor = UIColor.init(red: 151/255, green: 199/255, blue: 255/255, alpha: 0.2);
                   cell.title.textColor = UIColor.black;
                   cell.message.textColor = UIColor.black;
                   //cell.circleButtonView.isHidden = false;
                   let tapGestureRecognizer = MyTapGesture(target: self, action: #selector(self.connected(_:)))
                   cell.rightCornerView.addGestureRecognizer(tapGestureRecognizer)
                   tapGestureRecognizer.notificationId = notification.notificationId;
               }
            
            if (notification.action == "AcceptDecline") {
                let searchString = "accepted|declined"
                let attributed = NSMutableAttributedString(string: notification.message!)
                do {
                    let regex = try! NSRegularExpression(pattern: searchString,options: .caseInsensitive)
                    for match in regex.matches(in: notification.message!, options: NSRegularExpression.MatchingOptions(), range: NSRange(location: 0, length: notification.message!.count)) as [NSTextCheckingResult] {
                        attributed.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange, range: match.range)
                    }
                    cell.message.attributedText = attributed
                }
            } else if (notification.action == "Create") {
               cell.partyIcon.isHidden = false;
               cell.partyIcon.image = UIImage.init(named: "mdi_party_popper");
            } else if (notification.action == "Chat") {
               cell.partyIcon.isHidden = false;
               cell.partyIcon.image = UIImage.init(named: "notificaiton_chat_icon");
            }
            let pastDateInMillis = Date().millisecondsSince1970 - notification.createdAt

           let days = Int(pastDateInMillis/(1000*3600*24));
           if (days == 0) {
               let hours = Int(pastDateInMillis/(1000*3600));
               
               if (hours < 1) {
                   let minutes = Int(pastDateInMillis/(1000*60));
                   if (minutes < 1) {
                       
                       let sec = Int(pastDateInMillis/1000);
                       cell.happen.text = "\(sec)s";

                   } else {
                       cell.happen.text = "\(minutes)m";
                   }
               } else {
                   cell.happen.text = "\(hours)h";
               }
           } else {
               
               if (days < 7) {
                   cell.happen.text = "\(days)d";
               } else {
                   cell.happen.text = "\(days/7)w";
               }
           }
    
            return cell

        }
        return cell;
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
            if (notification.action == "Chat") {
                let selectedEventChatDto = SelectedEventChatDto();
                selectedEventChatDto.showChatWindow = true;
                selectedEventChatDto.message = notification.message!;
                newViewController.selectedEventChatDto = selectedEventChatDto;
            }
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height: CGFloat = 60;
        if (self.notificationDtos.count != 0) {
                let notificationsTemp = self.notificationDtos[indexPath.section].notifications
                let notification = notificationsTemp![indexPath.row];
            if let font = UIFont(name: "Avenir-Medium", size: 15.0) {
               let fontAttributes = [NSAttributedString.Key.font: font]
                let myText = notification.message!
               let size = (myText as NSString).size(withAttributes: fontAttributes)
                if (size.width > 250) {
                    height = 75;
                }
            }
        }
        return height;
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
        
        if (title == "Earlier") {
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
