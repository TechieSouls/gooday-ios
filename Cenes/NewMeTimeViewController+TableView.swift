//
//  NewMeTimeViewController+TableView.swift
//  Deploy
//
//  Created by Cenes_Dev on 19/03/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation

extension NewMeTimeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let counts = 1 + self.metimeEvents.count;
        
        return counts;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell();
        switch indexPath.row {
        case 0:
            let identifier = "MeTimeDescTableViewCell"
            let cell = (tableView.dequeueReusableCell(withIdentifier: identifier) as? MeTimeDescTableViewCell)!
            return cell;
        default:
            
            let meTimeEventObj = self.metimeEvents[indexPath.row - 1];
            
            if (meTimeEventObj.startTime == nil) {
                
                let identifier = "MeTimeUnscheduleTableViewCell"
                let cell: MeTimeUnscheduleTableViewCell  = (tableView.dequeueReusableCell(withIdentifier: identifier) as? MeTimeUnscheduleTableViewCell)!
                
                let twoDigitlabel = MeTimeManager().getTwoDigitInitialsOfTitle(title: meTimeEventObj.title);
                
                cell.meTimeViewLabel.text = twoDigitlabel.uppercased();
                cell.title.text = "\(String(meTimeEventObj.title))";
                return cell;
                
            } else {
                let identifier = "MeTimeItemTableViewCell"
                let cell: MeTimeItemTableViewCell  = (tableView.dequeueReusableCell(withIdentifier: identifier) as? MeTimeItemTableViewCell)!
                //Set the text initially to check if the text is of multiple lines.
                //Then adjust the height of cell.
                //print(cell.meTimeTitle.frame.height)

                //cell.meTimeTitle.numberOfLines = 0
                //cell.meTimeTitle.lineBreakMode = .byWordWrapping

                cell.meTimeTitle.text = meTimeEventObj.title;
                cell.meTimeTitle.frame = CGRect(cell.meTimeTitle.frame.origin.x, cell.meTimeTitle.frame.origin.y, cell.meTimeTitle.frame.width, cell.meTimeTitle.frame.height)

                print("Width: ",cell.meTimeTitle.frame.width)
                cell.meTimeDays.text = MeTimeManager().getDaysStr(recurringPatterns: meTimeEventObj.patterns);
                
                //We will use this height to Y axis of Schedule View to move it little down.
                //cell.meTimeTitle.frame = CGRect(x: cell.meTimeTitle.frame.origin.x, y: cell.meTimeTitle.frame.origin.y, width: cell.meTimeTitle.frame.width, height: cell.meTimeTitle.optimalHeight)
                
                //Setting Height of Days Label
                //cell.meTimeDays.frame = CGRect(x: cell.meTimeDays.frame.origin.x, y: cell.meTimeDays.frame.origin.y, width: cell.meTimeDays.frame.width, height: cell.meTimeDays.optimalHeight);
                
                //Setting Hours
                let hoursStr = "\(Date(milliseconds: Int(meTimeEventObj.startTime) ).hmma()) - \(Date(milliseconds: Int(meTimeEventObj.endTime) ).hmma())";
                cell.meTimeHours.text = hoursStr;
                //cell.meTimeHours.frame = CGRect(x: cell.meTimeHours.frame.origin.x, y: cell.meTimeDays.frame.height, width: cell.meTimeHours.frame.width, height: cell.meTimeHours.frame.height)

               //cell.meTimeScheduleView.frame = CGRect(x: cell.meTimeScheduleView.frame.origin.x, y: cell.meTimeTitle.frame.height + 10, width: cell.meTimeScheduleView.frame.width, height: cell.meTimeScheduleView.frame.height)
                
                //Setting Image
                if (meTimeEventObj.photo == nil) {
                    cell.meTimeImage.isHidden = true;
                    cell.meTimeViewNoImage.isHidden = false;
                    
                    let noImageLbl = MeTimeManager().getTwoDigitInitialsOfTitle(title: meTimeEventObj.title);
                    cell.meTimeNoImageLabel.text = noImageLbl.uppercased();
                } else {
                    cell.meTimeViewNoImage.isHidden = true;
                    cell.meTimeImage.isHidden = false;
                    
                    let imageUrl = "\(apiUrl)\(meTimeEventObj.photo!)";
                    cell.meTimeImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage.init(named: "profile icon"));
                }
                
                
                cell.totalHeightOfCell = 110 + Int(cell.meTimeTitle.optimalHeight);
                print("Before Setting row height", cell.totalHeightOfCell)
                //cell.meTimeCellViewDetails.frame = CGRect(x: cell.meTimeCellViewDetails.frame.origin.x, y: cell.meTimeCellViewDetails.frame.origin.y, width: cell.meTimeCellViewDetails.frame.width, height: cell.meTimeTitle.optimalHeight + cell.meTimeDays.optimalHeight + cell.meTimeHours.optimalHeight + 30)
                
                return cell;
            }
        }
        return cell;
    }
    
    /*func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0:
            return 100;
        default:
            let identifier = "MeTimeItemTableViewCell"
            let cell: MeTimeItemTableViewCell  = (tableView.dequeueReusableCell(withIdentifier: identifier) as? MeTimeItemTableViewCell)!
            print(cell.meTimeCellViewDetails.frame.height + 20)
            return 110;
        }
    }*/
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 100;
        default:
            let identifier = "MeTimeItemTableViewCell"
            let cell: MeTimeItemTableViewCell  = (tableView.dequeueReusableCell(withIdentifier: identifier) as? MeTimeItemTableViewCell)!
            
            print("Row Height", cell.totalHeightOfCell)
            return 110;
        }
    }
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath.row != 0) {
            
            let meTimeAddViewController: MeTimeAddViewController = storyboard?.instantiateViewController(withIdentifier: "MeTimeAddViewController") as! MeTimeAddViewController;
            meTimeAddViewController.metimeRecurringEvent =  self.metimeEvents[indexPath.row - 1];
            present(meTimeAddViewController, animated: true, completion: nil)
        }
    }
}
