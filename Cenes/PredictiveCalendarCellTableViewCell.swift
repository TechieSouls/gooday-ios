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

    
    @IBOutlet weak var predictiveCalendarView: UIView!
    
    @IBOutlet weak var predictiveCalendar: FSCalendar!
    
    @IBOutlet weak var predictiveInfoIcon: UIImageView!
    
    @IBOutlet weak var predictiveSwitch: UISwitch!
    
    var createGatheringDelegate: CreateGatheringV2ViewController!
    
    var dateClickedProtocolDelegate: DateClickedProtocol!;
    
    let formatter = DateFormatter()

    var selectedDates = [String: UIColor]();
    var unselectedDates = [String: UIColor]();
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        unselectedDates = GatheringManager().getCurrentMonthDatesWithColor(selectedDate: predictiveCalendar.currentPage);
        
        predictiveCalendar.appearance.borderRadius = 0.5
        formatter.dateFormat = "yyyy/MM/dd";
        //selectedDates = ["2019/04/08", "2019/04/09", "2019/04/10"]
        
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
            
            //Hiding navigation bar
            createGatheringDelegate.navigationController?.navigationBar.isHidden = true;
            
            createGatheringDelegate.createGathDto.timeMatchIconOn = true;
            predictiveInfoIcon.image = UIImage.init(named: "time_match_icon_on");
            
            createGatheringDelegate.createGathDto.createGatheringRowsVisibility[CreateGatheringRows.predictiveInfoRow] = true;
            createGatheringDelegate.createGathDto.createGatheringRowsVisibility[CreateGatheringRows.datePanelRow] = false;
            createGatheringDelegate.createGathDto.createGatheringRowsVisibility[CreateGatheringRows.eventInfoPanelRow] = false;
            createGatheringDelegate.createGathDto.createGatheringRowsVisibility[CreateGatheringRows.friendsCollectionRow] = false;

            createGatheringDelegate.createGathTableView.reloadData();
        } else {
            
            //UnHiding navigation bar
            createGatheringDelegate.navigationController?.navigationBar.isHidden = false;
            
            
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
        
        if (predictiveSwitch.isOn == true) {
            if self.selectedDates[formatter.string(from: date)] != nil {
                return self.selectedDates[formatter.string(from: date)]
            }
        } else {
            if self.unselectedDates[formatter.string(from: date)] != nil {
                return self.unselectedDates[formatter.string(from: date)]
            }
        }
        return UIColor.white;
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        
        _ = formatter.string(from: date)
        
        /*if self.selectedDates.contains(dateString) {
         return UIColor.white
         }*/
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        
        if (predictiveSwitch.isOn == true) {
            if self.selectedDates[formatter.string(from: date)] != nil {
                return UIColor.white
            }
        } else {
            if self.unselectedDates[formatter.string(from: date)] != nil {
                return UIColor.white
            }
        }
        return CreateGatheringPredictiveColors.GRAYCOLOR;
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(date, monthPosition)
        
        if (createGatheringDelegate.createGathDto.timeMatchIconOn == true) {
            //UnHiding navigation bar
            createGatheringDelegate.navigationController?.navigationBar.isHidden = false;
            
            
            createGatheringDelegate.createGathDto.timeMatchIconOn = false;
            predictiveInfoIcon.image = UIImage.init(named: "time_match_icon_off");
            createGatheringDelegate.createGathDto.createGatheringRowsVisibility[CreateGatheringRows.predictiveInfoRow] = false;
            createGatheringDelegate.createGathDto.createGatheringRowsVisibility[CreateGatheringRows.datePanelRow] = true;
            createGatheringDelegate.createGathDto.createGatheringRowsVisibility[CreateGatheringRows.eventInfoPanelRow] = true;
            createGatheringDelegate.createGathDto.createGatheringRowsVisibility[CreateGatheringRows.friendsCollectionRow] = true;
            createGatheringDelegate.createGathTableView.reloadData();
        }
        
        
        createGatheringDelegate.createGathDto.trackGatheringDataFilled[CreateGatheringFields.dateField] = true
        dateClickedProtocolDelegate.predictiveCalendarDatePressed(date: date);
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentPageDate = self.predictiveCalendar.currentPage
        let month = Calendar.current.component(.month, from: currentPageDate)
        print("Current Month : ", month);
        
        let currentDate = Calendar.current.dateComponents(in: TimeZone.current, from: Date());
        
        var startTimeDateComponent = Calendar.current.dateComponents(in: TimeZone.current, from: Date(milliseconds: Int(createGatheringDelegate.event.startTime)))
        startTimeDateComponent.month = month;
        createGatheringDelegate.event.startTime = Calendar.current.date(from: startTimeDateComponent)!.millisecondsSince1970;
        
        var endTimeDateComponent = Calendar.current.dateComponents(in: TimeZone.current, from: Date(milliseconds: Int(createGatheringDelegate.event.endTime)))
        endTimeDateComponent.month = month;
        createGatheringDelegate.event.endTime = Calendar.current.date(from: endTimeDateComponent)!.millisecondsSince1970;
        
        if (predictiveSwitch.isOn == true) {
            if (month >= currentDate.month!) {
                showPredictions();
            }
        } else {
            unselectedDates = GatheringManager().getCurrentMonthDatesWithColor(selectedDate: predictiveCalendar.currentPage);
            self.predictiveCalendar.reloadData();

        }
    }
    
    @IBAction func predictiveSwitchChanged(_ sender: UISwitch) {
        
        
        createGatheringDelegate.event.isPredictiveOn = predictiveSwitch.isOn;

        if (predictiveSwitch.isOn == true) {
            
            if (createGatheringDelegate.createGathDto.trackGatheringDataFilled[CreateGatheringFields.startTimeField] == false && createGatheringDelegate.createGathDto.trackGatheringDataFilled[CreateGatheringFields.endTimeField] == false) {
                
                let alert = UIAlertController(title: "Alert?", message: "Plaese select Start and End Time.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
                    self.predictiveSwitch.isOn = false;
                }))
                
                createGatheringDelegate.present(alert, animated: true, completion: nil)
            } else if (createGatheringDelegate.createGathDto.trackGatheringDataFilled[CreateGatheringFields.startTimeField] == false) {
                let alert = UIAlertController(title: "Alert?", message: "Plaese select End Time.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
                    self.predictiveSwitch.isOn = false;
                }))
                createGatheringDelegate.present(alert, animated: true, completion: nil)

            } else {
                showPredictions();
            }
        } else {
            self.predictiveCalendar.reloadData();
        }
    }

func showPredictions() {
    selectedDates = [String: UIColor]();
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
    let loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
    
    self.createGatheringDelegate.addBlurBackgroundView(viewToBlur: predictiveCalendarView);
    
    GatheringService().getPredictiveData(queryStr: queryStr, token: loggedInUser.token, complete: {(response) in
        
        self.createGatheringDelegate.removeBlurredBackgroundView(viewToBlur: self.predictiveCalendarView);
        
        let success = response.value(forKey: "success") as! Bool;
        if (success == true) {
            let predictiveArr = response.value(forKey: "data") as! NSArray;
            
            let predictions = PredictiveData().loadPredicitiveDataFromList(predictiveArray: predictiveArr);
            
            let predictiveFormatter = DateFormatter();
            predictiveFormatter.dateFormat = "yyyy/MM/dd";
            predictiveFormatter.string(from: Date())
            
            let currentPageDate = self.predictiveCalendar.currentPage
            let month = Calendar.current.component(.month, from: currentPageDate)
            print("Current Page Month : \(month)");
            
            for prediction in predictions {
                
                let calendar = Calendar.current;
                let dateComponents = calendar.dateComponents(in: TimeZone.current, from: Date(milliseconds: Int(prediction.date)))
                
                let todayDateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: Date());
                print("Predictive Dare month : \(dateComponents.month)");
                
                //Check if predictive data has
                //1.) If start time month < todays month
                //2.) If start time month is same as current month but date is less than current date
                //3.) If start time month is less than calendar page month.
                if ((dateComponents.month! < todayDateComponents.month!) || (dateComponents.month! == todayDateComponents.month! && dateComponents.day! < todayDateComponents.day!) || dateComponents.month! < month) {
                    continue;
                }
                
                if (prediction.predictivePercentage == 0) {
                    self.selectedDates[predictiveFormatter.string(from: Date(milliseconds: Int(prediction.date)))] = CreateGatheringPredictiveColors.GRAYCOLOR
                } else if (prediction.predictivePercentage >= 1 && prediction.predictivePercentage <= 33) {
                    self.selectedDates[predictiveFormatter.string(from: Date(milliseconds: Int(prediction.date)))] = CreateGatheringPredictiveColors.REDCOLOR
                    
                } else if (prediction.predictivePercentage >= 34 && prediction.predictivePercentage <= 66) {
                    self.selectedDates[predictiveFormatter.string(from: Date(milliseconds: Int(prediction.date)))] = CreateGatheringPredictiveColors.PINKCOLOR
                    
                } else if ((prediction.predictivePercentage >= 67 && prediction.predictivePercentage <= 99)) {
                    self.selectedDates[predictiveFormatter.string(from: Date(milliseconds: Int(prediction.date)))] = CreateGatheringPredictiveColors.LIMECOLOR
                    
                } else if (prediction.predictivePercentage == 100) {
                    self.selectedDates[predictiveFormatter.string(from: Date(milliseconds: Int(prediction.date)))] = CreateGatheringPredictiveColors.GREENCOLOR
                    
                }
            }
            
            self.predictiveCalendar.reloadData();
            
        }
    });
    }
}
