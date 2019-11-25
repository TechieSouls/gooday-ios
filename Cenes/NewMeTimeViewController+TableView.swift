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
            
            if (meTimeEventObj.startTime == 0) {
                
                let identifier = "MeTimeUnscheduleTableViewCell"
                let cell: MeTimeUnscheduleTableViewCell  = (tableView.dequeueReusableCell(withIdentifier: identifier) as? MeTimeUnscheduleTableViewCell)!
                
                let twoDigitlabel = MeTimeManager().getTwoDigitInitialsOfTitle(title: meTimeEventObj.title!);
                
                cell.meTimeViewLabel.text = twoDigitlabel.uppercased();
                cell.title.text = "\(String(meTimeEventObj.title!))";
                return cell;
                
            } else {
                
                let font = UIFont(name: "Avenir Medium", size: 20)
                let fontAttributes = [NSAttributedStringKey.font: font]
                let myText = meTimeEventObj.title
                let size = (myText as! NSString).size(withAttributes: fontAttributes)
                
                let leftAndRightEmptySpaceAroundTitle: CGFloat = 130.0;
                let cellType = Int((size.width/(tableView.frame.width - leftAndRightEmptySpaceAroundTitle)));
                if (cellType == 0) {
                     let identifier = "MeTimeItemTableViewCell";
                     let finalCell: MeTimeItemTableViewCell = (tableView.dequeueReusableCell(withIdentifier: identifier) as? MeTimeItemTableViewCell)!
                
                       finalCell.meTimeTitle.text = meTimeEventObj.title;
                    
                    finalCell.meTimeDays.text = MeTimeManager().getDaysStr(recurringPatterns: meTimeEventObj.patterns);
                        //Setting Hours
                        let hoursStr = "\(Date(milliseconds: Int(meTimeEventObj.startTime) ).hmma()) - \(Date(milliseconds: Int(meTimeEventObj.endTime) ).hmma())";
                        finalCell.meTimeHours.text = hoursStr;
                    
                        //Setting Image
                        if (meTimeEventObj.photo == nil) {
                            finalCell.meTimeImage.isHidden = true;
                            finalCell.meTimeViewNoImage.isHidden = false;
                            
                            let noImageLbl = MeTimeManager().getTwoDigitInitialsOfTitle(title: meTimeEventObj.title!);
                            finalCell.meTimeNoImageLabel.text = noImageLbl.uppercased();
                        } else {
                            finalCell.meTimeViewNoImage.isHidden = true;
                            finalCell.meTimeImage.isHidden = false;
                            
                            let imageUrl = "\(imageUploadDomain)\(meTimeEventObj.photo!)";
                            finalCell.meTimeImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage.init(named: "profile_pic_no_image icon"));
                        }
                        return finalCell;
                
                } else if (cellType == 1) {
                    let identifier = "MeTimeTwoLineTitleTableViewCell";
                    let finalCell: MeTimeTwoLineTitleTableViewCell = (tableView.dequeueReusableCell(withIdentifier: identifier) as? MeTimeTwoLineTitleTableViewCell)!
                
                
                    finalCell.meTimeTitle.text = meTimeEventObj.title;
                    
                    finalCell.meTimeDays.text = MeTimeManager().getDaysStr(recurringPatterns: meTimeEventObj.patterns);
                    //Setting Hours
                    let hoursStr = "\(Date(milliseconds: Int(meTimeEventObj.startTime) ).hmma()) - \(Date(milliseconds: Int(meTimeEventObj.endTime) ).hmma())";
                    finalCell.meTimeHours.text = hoursStr;
                    
                    //Setting Image
                    if (meTimeEventObj.photo == nil) {
                        finalCell.meTimeImage.isHidden = true;
                        finalCell.meTimeViewNoImage.isHidden = false;
                        
                        let noImageLbl = MeTimeManager().getTwoDigitInitialsOfTitle(title: meTimeEventObj.title!);
                        finalCell.meTimeNoImageLabel.text = noImageLbl.uppercased();
                    } else {
                        finalCell.meTimeViewNoImage.isHidden = true;
                        finalCell.meTimeImage.isHidden = false;
                        
                        let imageUrl = "\(imageUploadDomain)\(meTimeEventObj.photo!)";
                        finalCell.meTimeImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage.init(named: "profile_pic_no_image"));
                    }
                    
                        return finalCell;
                } else {
                    let identifier = "MeTimeThreeLineTableViewCell";
                    let finalCell: MeTimeThreeLineTableViewCell = (tableView.dequeueReusableCell(withIdentifier: identifier) as? MeTimeThreeLineTableViewCell)!
                
                    finalCell.meTimeTitle.text = meTimeEventObj.title;
                    
                    finalCell.meTimeDays.text = MeTimeManager().getDaysStr(recurringPatterns: meTimeEventObj.patterns);
                    //Setting Hours
                    let hoursStr = "\(Date(milliseconds: Int(meTimeEventObj.startTime) ).hmma()) - \(Date(milliseconds: Int(meTimeEventObj.endTime) ).hmma())";
                    finalCell.meTimeHours.text = hoursStr;
                    
                    //Setting Image
                    if (meTimeEventObj.photo == nil) {
                        finalCell.meTimeImage.isHidden = true;
                        finalCell.meTimeViewNoImage.isHidden = false;
                        
                        let noImageLbl = MeTimeManager().getTwoDigitInitialsOfTitle(title: meTimeEventObj.title!);
                        finalCell.meTimeNoImageLabel.text = noImageLbl.uppercased();
                    } else {
                        finalCell.meTimeViewNoImage.isHidden = true;
                        finalCell.meTimeImage.isHidden = false;
                        
                        let imageUrl = "\(imageUploadDomain)\(meTimeEventObj.photo!)";
                        finalCell.meTimeImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage.init(named: "profile_pic_no_image"));
                    }
                    
                    return finalCell;
                }
            
                return cell;
            }
        
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.beginUpdates()
        tableView.endUpdates()
        
        switch indexPath.row {
        case 0:
            return 100;
        default:
            let meTimeEventObj = self.metimeEvents[indexPath.row - 1];
            let font = UIFont(name: "Avenir Medium", size: 20)
            let fontAttributes = [NSAttributedStringKey.font: font]
            let myText = meTimeEventObj.title
            let size = (myText as! NSString).size(withAttributes: fontAttributes)
            
            let leftAndRightEmptySpaceAroundTitle: CGFloat = 130.0;
            let cellType = Int((size.width/(tableView.frame.width - leftAndRightEmptySpaceAroundTitle)));
            
            if (cellType == 0) {
                return 110;
            } else if (cellType == 1) {
                return 135;
            }
            return 170;
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath.row != 0) {
            
            let meTimeAddViewController: MeTimeAddViewController = storyboard?.instantiateViewController(withIdentifier: "MeTimeAddViewController") as! MeTimeAddViewController;
            meTimeAddViewController.metimeRecurringEvent =  self.metimeEvents[indexPath.row - 1];
            meTimeAddViewController.newMeTimeViewControllerDelegate = self;
            self.tabBarController?.tabBar.isHidden = true;
            self.addBlurBackgroundView();
            present(meTimeAddViewController, animated: false, completion: nil)
        }
    }
}
