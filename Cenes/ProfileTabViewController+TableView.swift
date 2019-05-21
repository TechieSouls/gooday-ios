//
//  ProfileTabViewController+TableView.swift
//  Deploy
//
//  Created by Cenes_Dev on 04/05/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
import MessageUI

extension ProfileTabViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileDtos.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let profileDto = profileDtos[indexPath.row];
        let cell: PeronalDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PeronalDetailsTableViewCell") as! PeronalDetailsTableViewCell;
        
        cell.img.image = UIImage.init(named: profileDto.img);
        cell.title.text = profileDto.title;
        cell.desc.text = profileDto.desc;
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            let viewController = storyboard?.instantiateViewController(withIdentifier: "PersonalDetailsViewController") as! PersonalDetailsViewController
            navigationController?.pushViewController(viewController, animated: true);
            break;
        case 1:
            let viewController = storyboard?.instantiateViewController(withIdentifier: "CalendarsViewController") as! CalendarsViewController
            navigationController?.pushViewController(viewController, animated: true);
            break;
        case 2:
            let navViewController = storyboard?.instantiateViewController(withIdentifier: "AppSettingsViewController") as! AppSettingsViewController;
            navigationController?.pushViewController(navViewController, animated: true);
            break;
            
        case 3:
            // create an actionSheet
            let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            // create an action
            let faqAction: UIAlertAction = UIAlertAction(title: "FAQ", style: .default) { action -> Void in
                //self.selectPicture();
                if let requestUrl = NSURL(string: "\(faqLink)") {
                    UIApplication.shared.openURL(requestUrl as URL)
                }
            }
            let handfAction: UIAlertAction = UIAlertAction(title: "Help & Feedback", style: .default) { action -> Void in
                
                let iphoneDetails = "\(UIDevice.modelName) \(UIDevice.current.systemVersion)";
                
                if MFMailComposeViewController.canSendMail() {
                    let mail = MFMailComposeViewController()
                    mail.mailComposeDelegate = self
                    mail.setToRecipients(["support@cenesgroup.com"])
                    mail.setMessageBody("\(iphoneDetails) \n", isHTML: false)
                    self.present(mail, animated: true, completion: nil)
                } else {
                    print("Cannot send mail")
                    // give feedback to the user
                }
            }
            
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
            //cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
            
            actionSheetController.addAction(faqAction)
            actionSheetController.addAction(handfAction)
            actionSheetController.addAction(cancelAction)
            
            // present an actionSheet...
            self.present(actionSheetController, animated: true, completion: nil)
            break;
        default:
            print("Default")
        }
    }
}
