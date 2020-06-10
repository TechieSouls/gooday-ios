//
//  RemindersViewController+Extensions.swift
//  Cenes
//
//  Created by Chinna Addepally on 12/3/17.
//  Copyright © 2017 Redblink Pvt Ltd. All rights reserved.
//

import Foundation

extension RemindersViewController {
    func sectionHeaderView(withLabel: String) -> UIView {
        let headerView = UIView.init(frame: CGRect.zero)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = UIColor.clear
        
        let imageView = UIImageView.init(frame: CGRect.zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "reminder basket")
        imageView.tag = 1
        headerView.addSubview(imageView)
        
        let label = UILabel.init(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = withLabel
        label.tag = 2
        label.font = UIFont.init(name: "Lato-Bold", size: 24)
        label.textColor = UIColor.darkGray
        headerView.addSubview(label)
        
        let viewsDict: [String: Any] = ["Header": headerView, "Image": imageView, "Label": label]
        
        headerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[Image]-20-[Label]-10@200-|", options: .init(rawValue: 0), metrics: nil, views: viewsDict))
        
        headerView.addConstraint(NSLayoutConstraint.init(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: headerView, attribute: .centerY, multiplier: 1, constant: 0))
        
        headerView.addConstraint(NSLayoutConstraint.init(item: label, attribute: .centerY, relatedBy: .equal, toItem: imageView, attribute: .centerY, multiplier: 1, constant: 0))
        
        headerView.addConstraint(NSLayoutConstraint.init(item: headerView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.size.width))
        
        headerView.addConstraint(NSLayoutConstraint.init(item: headerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 75))
        
        return headerView
    }
}

extension RemindersViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        if section == 0 {
            headerView.addSubview(sectionHeaderView(withLabel: "Reminders"))
        }
        else {
            headerView.addSubview(sectionHeaderView(withLabel: "Completed"))
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect(x: 0 , y: 0, width: UIScreen.main.bounds.size.width, height: 30))
        view.backgroundColor = UIColor.white
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if openReminders.count == 0 {
                return 1
            }
            return openReminders.count
        case 1:
            if closedReminders.count == 0 {
                return 1
            }
            return closedReminders.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reminderCell = tableView.dequeueReusableCell(withIdentifier: "Reminder") as? RemindersTableViewCell
        reminderCell?.selectionStyle = .none
        
        let userid = setting.value(forKey: "userId") as! NSNumber

        if indexPath.section == 0 {
            if openReminders.count == 0 {
                let emptyCell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell") as? RemindersEmptyTableViewCell
                let emptyquote = "The way to get started is to quit  talking and begin doing."
                emptyCell?.emptyLabel.text = emptyquote + "- WALT DISNEY"
                return emptyCell!
            }
            if selectedIndex == indexPath.row {
                let detailCell = tableView.dequeueReusableCell(withIdentifier: "ReminderDetail") as? ReminderDetailTableViewCell
                let reminder = openReminders[indexPath.row]
                detailCell?.reminderTitleLabel.text = reminder.title
                
                if reminder.reminderTime != nil {
                    detailCell?.reminderDateLabel.isHidden = false
                    
                    let timeinterval : TimeInterval = (reminder.reminderTime as NSNumber).doubleValue / 1000 // convert it in to NSTimeInteral
                    let reminderDate = Date.init(timeIntervalSince1970: timeinterval) // you can the Date object from here
                    if reminderDate < Date() {
                        detailCell?.reminderTitleLabel.textColor = UIColor.red
                    }
                    else {
                        detailCell?.reminderTitleLabel.textColor = UIColor.black
                    }

                    detailCell?.reminderDateLabel.text = getDateFromTimestamp(timeStamp: reminder.reminderTime as NSNumber)
                }
                else {
                    detailCell?.reminderDateLabel.isHidden = true
                }
                
                if reminder.location != nil {
                    detailCell?.reminderLocationLabel.text = reminder.location
                    detailCell?.locationPointImage.isHidden = false
                    detailCell?.reminderLocationLabel.isHidden = false
                }
                else {
                    detailCell?.reminderLocationLabel.isHidden = true
                    detailCell?.locationPointImage.isHidden = true
                }
                
//                if reminder.location.count > 0 {
//                }
//                else {
//                }
                
                detailCell?.selectionStyle = .none
                
                
                if userid == reminder.createdByID {
                    detailCell?.reminderEditButton.isHidden = false
                }
                else {
                    detailCell?.reminderEditButton.isHidden = true
                }
                
                detailCell?.reminderStatusButton.addTarget(self, action: #selector(closeReminderFromDetailCell(_sender:)), for: .touchUpInside)
                detailCell?.reminderEditButton.addTarget(self, action: #selector(showReminderDetail(sender:)), for: .touchUpInside)
                
                return detailCell!
            }
            
            let reminder = openReminders[indexPath.row]
            reminderCell?.reminderButton.setImage(#imageLiteral(resourceName: "ReminderPending"), for: .normal)
            reminderCell?.selectionStyle = .none
            reminderCell?.reminderLabel.text = reminder.title
            
            if reminder.reminderTime != nil {
                
                let timeinterval : TimeInterval = (reminder.reminderTime as NSNumber).doubleValue / 1000 // convert it in to NSTimeInteral
                let reminderDate = Date.init(timeIntervalSince1970: timeinterval) // you can the Date object from here
                if reminderDate < Date() {
                    reminderCell?.reminderLabel.textColor = UIColor.red
                }
                else {
                    reminderCell?.reminderLabel.textColor = UIColor.black
                }
            }
        }
        else if indexPath.section == 1 {
            
            if closedReminders.count == 0 {
                let emptyCell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath) as? RemindersEmptyTableViewCell
                emptyCell?.emptyLabel.text = "You have not completed any reminders!"
                return emptyCell!
            }
            
            let reminder = closedReminders[indexPath.row]
            let attributedString: NSMutableAttributedString =  NSMutableAttributedString(string: reminder.title)
            attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length))
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.lightGray, range: NSRange(location: 0, length: reminder.title.count))
            
            reminderCell?.reminderButton.setImage(#imageLiteral(resourceName: "RemindersCompleted"), for: .normal)
            reminderCell?.reminderLabel.attributedText = attributedString
        }
        return reminderCell!
    }
}

extension RemindersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        let userid = setting.value(forKey: "userId") as! NSNumber

        if indexPath.section == 0 {
            if openReminders.count > 0 {
                let reminder = openReminders[indexPath.row]
                
                if userid == reminder.createdByID {
                    return true
                }
            }
        }
        else if indexPath.section == 1 {
            if closedReminders.count > 0 {
                let reminder = closedReminders[indexPath.row]
                
                if userid == reminder.createdByID {
                    return true
                }
            }
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if selectedIndex == indexPath.row {
                selectedIndex = -1
            }
            else {
                selectedIndex = indexPath.row
            }
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            if openReminders.count == 0 {
                return 100
            }
            if selectedIndex == indexPath.row {
                return 110
            }
            return 50
        case 1:
            if closedReminders.count == 0 {
                return 100
            }
            return 50
        default:
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            switch indexPath.section {
            case 0:
                let reminder = openReminders[indexPath.row]
                deleteReminder(reminder: reminder, indexpath: indexPath)
                break
                
            case 1:
                let reminder = closedReminders[indexPath.row]
                deleteReminder(reminder: reminder, indexpath: indexPath)
                break
            default:
                print("Don't do anything")
            }
        }
    }
}
