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
            self.helpAndFeedbackIconPressed(mfMailComposerDelegate: self);
            break;
            
        case 4:
            let navViewController = storyboard?.instantiateViewController(withIdentifier: "VersionUpdateViewController") as! VersionUpdateViewController;
            navigationController?.pushViewController(navViewController, animated: true);
            break;
        default:
            print("Default")
        }
    }
}
