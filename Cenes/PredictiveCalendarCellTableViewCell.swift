//
//  PredictiveCalendarCellTableViewCell.swift
//  Deploy
//
//  Created by Cenes_Dev on 19/04/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit
import FSCalendar

protocol DateClickedProtocol {
    func predictiveCalendarDatePressed(date: Date);
}

class PredictiveCalendarCellTableViewCell: UITableViewCell, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    @IBOutlet weak var predictiveCalendar: FSCalendar!
    
    @IBOutlet weak var predictiveInfoIcon: UIImageView!
    
    @IBOutlet weak var predictiveSwitch: UISwitch!
    
    var createGatheringDelegate: CreateGatheringV2ViewController!
    
    var dateClickedProtocolDelegate: DateClickedProtocol!;
    
    let formatter = DateFormatter()

    var selectedDates = [String]();
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        predictiveCalendar.appearance.borderRadius = 0.5
        
        selectedDates = ["2019/04/08", "2019/04/09", "2019/04/10"]
        
        let predictiveInfoIconTap = UITapGestureRecognizer.init(target: self, action: #selector(predictiveInfoIconPressed));
        predictiveInfoIcon.addGestureRecognizer(predictiveInfoIconTap);
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @objc func predictiveInfoIconPressed() {
        
        //When pressed. If its off. Then make it on.
        if (createGatheringDelegate.createGathDto.timeMatchIconOn == false) {
            createGatheringDelegate.createGathDto.timeMatchIconOn = true;
            predictiveInfoIcon.image = UIImage.init(named: "time_match_icon_on");
            
            createGatheringDelegate.createGathDto.createGatheringRowsVisibility[CreateGatheringRows.predictiveInfoRow] = true;
            createGatheringDelegate.createGathDto.createGatheringRowsVisibility[CreateGatheringRows.datePanelRow] = false;
            createGatheringDelegate.createGathDto.createGatheringRowsVisibility[CreateGatheringRows.eventInfoPanelRow] = false;
            createGatheringDelegate.createGathDto.createGatheringRowsVisibility[CreateGatheringRows.friendsCollectionRow] = false;

            createGatheringDelegate.createGathTableView.reloadData();
        } else {
            createGatheringDelegate.createGathDto.timeMatchIconOn = false;
            predictiveInfoIcon.image = UIImage.init(named: "time_match_icon_off");
            createGatheringDelegate.createGathDto.createGatheringRowsVisibility[CreateGatheringRows.predictiveInfoRow] = false;
            createGatheringDelegate.createGathDto.createGatheringRowsVisibility[CreateGatheringRows.datePanelRow] = true;
            createGatheringDelegate.createGathDto.createGatheringRowsVisibility[CreateGatheringRows.eventInfoPanelRow] = true;
            createGatheringDelegate.createGathDto.createGatheringRowsVisibility[CreateGatheringRows.friendsCollectionRow] = true;
            createGatheringDelegate.createGathTableView.reloadData();
        }
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        return UIColor(red:0.86, green:0.87, blue:0.87, alpha:1)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        
        let dateString = formatter.string(from: date)
        
        /*if self.selectedDates.contains(dateString) {
         return UIColor.white
         }*/
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let dateString = formatter.string(from: date)
        
        /*if self.selectedDates.contains(dateString) {
         return UIColor.white
         }*/
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(date, monthPosition)
        dateClickedProtocolDelegate.predictiveCalendarDatePressed(date: date);
    }
    
    
    @IBAction func predictiveSwitchChanged(_ sender: UISwitch) {
        
        print(predictiveSwitch.isOn)
        let loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        
        if (predictiveSwitch.isOn == true) {
            
            var queryStr = "userId=\(String(createGatheringDelegate.event.createdById))&startTime=\(String(createGatheringDelegate.event.startTime))&endTime=\(String(createGatheringDelegate.event.endTime))";
            
            
            var friendIds = "";
            for eventMem in createGatheringDelegate.event.eventMembers {
                
                if (eventMem.userId != nil) {
                    friendIds = friendIds + "\(String(eventMem.userId)),";
                }
            }
            if (friendIds != "") {
                queryStr = queryStr + "&friends=\(friendIds.substring(toIndex: friendIds.count - 1))";
            }
            
            GatheringService().getPredictiveData(queryStr: queryStr, token: loggedInUser.token, complete: {(response) in
                
            })
        } else {
            
        }
    }
}
