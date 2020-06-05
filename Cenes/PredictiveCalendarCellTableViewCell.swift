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
    var calendarPage: Date!
    var predictionsData = [PredictiveData]();
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        unselectedDates = GatheringManager().getCurrentMonthDatesWithColor(selectedDate: predictiveCalendar.currentPage);
        
        predictiveCalendar.appearance.borderRadius = 0.5
        predictiveCalendar.appearance.titleFont = UIFont.init(name: "Avenir-Heavy", size: 20)
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
            createGatheringDelegate.createGathDto.createGatheringRowsVisibility[CreateGatheringRows.friendsCollectionRow] = false;

            createGatheringDelegate.createGathTableView.reloadData();
        } else {
            
            //UnHiding navigation bar
            createGatheringDelegate.navigationController?.navigationBar.isHidden = false;
                        
            createGatheringDelegate.createGathDto.timeMatchIconOn = false;
            predictiveInfoIcon.image = UIImage.init(named: "time_match_icon_off");
            createGatheringDelegate.createGathDto.createGatheringRowsVisibility[CreateGatheringRows.predictiveInfoRow] = false;
            createGatheringDelegate.createGathDto.createGatheringRowsVisibility[CreateGatheringRows.datePanelRow] = true;
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
        
        if (predictiveSwitch.isOn == true) {
            if self.selectedDates[formatter.string(from: date)] != nil {
                return nil;
            }
        }
        return CreateGatheringPredictiveColors.GRAYCOLOR

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
        return UIColor.lightGray;
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(date, monthPosition)
        
        let currentDateCompos = Calendar.current.dateComponents(in: TimeZone.current, from: Date());
        let selectedDateCompos = Calendar.current.dateComponents(in: TimeZone.current, from: date);

        let isValidDate = ((selectedDateCompos.day as! Int) <= (currentDateCompos.day as! Int) && (selectedDateCompos.month as! Int) < (currentDateCompos.month as! Int) && (selectedDateCompos.year as! Int) > (currentDateCompos.year as! Int)) ||
            ((selectedDateCompos.day as! Int) < (currentDateCompos.day as! Int) && (selectedDateCompos.month as! Int) > (currentDateCompos.month as! Int) && (selectedDateCompos.year as! Int) >= (currentDateCompos.year as! Int)) ||
            ((selectedDateCompos.day as! Int) >= (currentDateCompos.day as! Int) && (selectedDateCompos.month as! Int) < (currentDateCompos.month as! Int) && (selectedDateCompos.year as! Int) > (currentDateCompos.year as! Int)) ||
            ((selectedDateCompos.day as! Int) >= (currentDateCompos.day as! Int) && (selectedDateCompos.month as! Int) >= (currentDateCompos.month as! Int) && (selectedDateCompos.year as! Int) >= (currentDateCompos.year as! Int));
        
        if (isValidDate) {
            
            if (createGatheringDelegate.createGathDto.timeMatchIconOn == true) {
                //UnHiding navigation bar
                createGatheringDelegate.navigationController?.navigationBar.isHidden = false;
                
                
                createGatheringDelegate.createGathDto.timeMatchIconOn = false;
                predictiveInfoIcon.image = UIImage.init(named: "time_match_icon_off");
                createGatheringDelegate.createGathDto.createGatheringRowsVisibility[CreateGatheringRows.predictiveInfoRow] = false;
                createGatheringDelegate.createGathDto.createGatheringRowsVisibility[CreateGatheringRows.datePanelRow] = false;
                createGatheringDelegate.createGathDto.createGatheringRowsVisibility[CreateGatheringRows.eventInfoPanelRow] = true;
                createGatheringDelegate.createGathDto.createGatheringRowsVisibility[CreateGatheringRows.friendsCollectionRow] = true;
                createGatheringDelegate.createGathTableView.reloadData();
            }
            
            createGatheringDelegate.createGathDto.trackGatheringDataFilled[CreateGatheringFields.dateField] = true;
            
            if (createGatheringDelegate.event.isPredictiveOn == true) {
                for prediction in self.predictionsData {
                    let predictiveDateCompos = Calendar.current.dateComponents(in: TimeZone.current, from: Date(millis: prediction.date));
                    
                    print("selectedDateCompos.day == predictiveDateCompos.day", selectedDateCompos.day, predictiveDateCompos.day)
                     print("selectedDateCompos.month == predictiveDateCompos.month", selectedDateCompos.month, predictiveDateCompos.month)
                     print("selectedDateCompos.year == predictiveDateCompos.year", selectedDateCompos.year, predictiveDateCompos.year)
                    if (selectedDateCompos.day! == predictiveDateCompos.day! && selectedDateCompos.month! == predictiveDateCompos.month! && selectedDateCompos.year! == predictiveDateCompos.year!) {
                        
                        print("Available Friens", prediction.attendingFriendsList);

                        createGatheringDelegate.createGathDto.availableFriendsList = prediction.attendingFriendsList;
                        
                        break;
                    }
                }
            }
            
           //This is to show date panel, if predictive info panel was opened and idi not hidden
            createGatheringDelegate.createGathDto.createGatheringRowsVisibility[CreateGatheringRows.datePanelRow] = true;

            dateClickedProtocolDelegate.predictiveCalendarDatePressed(date: date);
            
        } else {
            createGatheringDelegate.showAlert(title: "Alert", message: "Previous Date cannot be selected.")
        }
        
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        
        /*print(calendar.currentPage.currentTimeZoneDate);
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let currTimeZoneDate = dateFormatter.date(from: calendar.currentPage.currentTimeZoneDate);
        let currTimeZoneNewDate = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: currTimeZoneDate!)

        print(currTimeZoneNewDate);*/

        let currentPageComponents = Calendar.current.dateComponents(in: TimeZone.current, from: calendar.currentPage);
        
        print("Current Month : ", currentPageComponents.month!, currentPageComponents.year!);
        
        createGatheringDelegate.fsCalendarElements.month = currentPageComponents.month!
        createGatheringDelegate.fsCalendarElements.year = currentPageComponents.year!

        let currentDate = Calendar.current.dateComponents(in: TimeZone.current, from: Date());
        
        /*var startTimeDateComponent = Calendar.current.dateComponents(in: TimeZone.current, from: Date(milliseconds: Int(createGatheringDelegate.event.startTime)))
        startTimeDateComponent.month = currentPageComponents.month;
        startTimeDateComponent.year = currentPageComponents.year;
        let newStartDate = Calendar.current.date(from: startTimeDateComponent);
    
        print("Heyyyy , ", newStartDate!);
        createGatheringDelegate.event.startTime = newStartDate!.millisecondsSince1970;
        
        print(createGatheringDelegate.event.startTime)
        var endTimeDateComponent = Calendar.current.dateComponents(in: TimeZone.current, from: Date(milliseconds: Int(createGatheringDelegate.event.endTime)))
        endTimeDateComponent.month = currentPageComponents.month;
        endTimeDateComponent.year = currentPageComponents.year;
        let newEndDate = Calendar.current.date(from: endTimeDateComponent);

        createGatheringDelegate.event.endTime = newEndDate!.millisecondsSince1970;*/

        if (predictiveSwitch.isOn == true) {
            if (((currentPageComponents.month as! Int) >= currentDate.month! && (currentPageComponents.year as! Int) >= currentDate.year!) || ((currentPageComponents.month as! Int) < currentDate.month! && (currentPageComponents.year as! Int) > currentDate.year!)) {
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
                    self.createGatheringDelegate.event.isPredictiveOn = self.predictiveSwitch.isOn;
                }))
                
                createGatheringDelegate.present(alert, animated: true, completion: nil)
            } else if (createGatheringDelegate.createGathDto.trackGatheringDataFilled[CreateGatheringFields.startTimeField] == false) {
                let alert = UIAlertController(title: "Alert?", message: "Plaese select End Time.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
                    self.predictiveSwitch.isOn = false;
                    self.createGatheringDelegate.event.isPredictiveOn = self.predictiveSwitch.isOn;
                }))
                createGatheringDelegate.present(alert, animated: true, completion: nil)

            } else {
                
                if (createGatheringDelegate.fsCalendarElements.month == 0) {
                    
                    let currDateCompos = Calendar.current.dateComponents(in: TimeZone.current, from: Date());
                    createGatheringDelegate.fsCalendarElements.month = currDateCompos.month!;
                    createGatheringDelegate.fsCalendarElements.year = currDateCompos.year!;
                }
                    
                showPredictions();
            }
        } else {
            createGatheringDelegate.createGathDto.availableFriendsList = "";
            createGatheringDelegate.createGathTableView.reloadData();
            self.predictiveCalendar.reloadData();
        }
    }

func showPredictions() {
    
    var startTimeDateComponent = Calendar.current.dateComponents(in: TimeZone.current, from: Date(milliseconds: Int(createGatheringDelegate.event.startTime)))
    
    var newStartDateCompos = Calendar.current.dateComponents(in: TimeZone.current, from: Date());
    newStartDateCompos.day = 15;
    newStartDateCompos.month = createGatheringDelegate.fsCalendarElements.month;
    newStartDateCompos.year = createGatheringDelegate.fsCalendarElements.year;
    newStartDateCompos.hour = startTimeDateComponent.hour;
    newStartDateCompos.minute = startTimeDateComponent.minute;
    newStartDateCompos.second = 0;
        newStartDateCompos.nanosecond = 0;
    var newStartDate = Calendar.current.date(from: newStartDateCompos);

    let newStartDateComposTemp = Calendar.current.dateComponents(in: TimeZone.current, from: newStartDate!);
    let yearDiff = createGatheringDelegate.fsCalendarElements.year - newStartDateComposTemp.year!;
    newStartDate = Calendar.current.date(byAdding: .year, value: yearDiff, to: newStartDate!);
    print("Start Time : ",newStartDate?.millisecondsSince1970);
    
    var endTimeDateComponent = Calendar.current.dateComponents(in: TimeZone.current, from: Date(milliseconds: Int(createGatheringDelegate.event.endTime)))
    var newEndDateCompos = Calendar.current.dateComponents(in: TimeZone.current, from: Date());
    if (endTimeDateComponent.hour! < startTimeDateComponent.hour!) {
        newEndDateCompos.day = 16;
    } else {
        newEndDateCompos.day = 15;
    }
    newEndDateCompos.month = createGatheringDelegate.fsCalendarElements.month;
    newEndDateCompos.year = createGatheringDelegate.fsCalendarElements.year;
    newEndDateCompos.hour = endTimeDateComponent.hour;
    newEndDateCompos.minute = endTimeDateComponent.minute;
    newEndDateCompos.second = 0;
    newEndDateCompos.nanosecond = 0;
    var newEndDate = Calendar.current.date(from: newEndDateCompos);

    let newEndDateComposTemp = Calendar.current.dateComponents(in: TimeZone.current, from: newEndDate!);
    let endYearDiff = createGatheringDelegate.fsCalendarElements.year - newEndDateComposTemp.year!;
    newEndDate = Calendar.current.date(byAdding: .year, value: endYearDiff, to: newEndDate!);
    print("End Time : ",newEndDate?.millisecondsSince1970);

    selectedDates = [String: UIColor]();
    var queryStr = "userId=\(String(createGatheringDelegate.event.createdById))&startTime=\(String(newStartDate!.millisecondsSince1970))&endTime=\(String(newEndDate!.millisecondsSince1970))";
    print(queryStr)
    
    var friendIds = "";
    for eventMem in createGatheringDelegate.event.eventMembers {
        if (eventMem.userId != nil && eventMem.userId != 0 && eventMem.userId != createGatheringDelegate.loggedInUser.userId) {
            friendIds = friendIds + "\(String(eventMem.userId)),";
        }
    }
    if (friendIds != "") {
        queryStr = queryStr + "&friends=\(friendIds.prefix(friendIds.count-1))";
    }
    let loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
    
    //self.createGatheringDelegate.addBlurBackgroundView(viewToBlur: predictiveCalendarView);
    self.createGatheringDelegate.showLoading();

    GatheringService().getPredictiveData(queryStr: queryStr, token: loggedInUser.token, complete: {(response) in
        
        //self.createGatheringDelegate.removeBlurredBackgroundView(viewToBlur: self.predictiveCalendarView);
        self.createGatheringDelegate.hideLoading();

        let success = response.value(forKey: "success") as! Bool;
        if (success == true) {
            let predictiveArr = response.value(forKey: "data") as! NSArray;
            
            self.predictionsData = PredictiveData().loadPredicitiveDataFromList(predictiveArray: predictiveArr);
            
            let predictiveFormatter = DateFormatter();
            predictiveFormatter.dateFormat = "yyyy/MM/dd";
            predictiveFormatter.string(from: Date())
            
            let currentPageDate = self.predictiveCalendar.currentPage
            let currentPageDateCompos = Calendar.current.dateComponents(in: TimeZone.current, from: currentPageDate);
            print("Current Page Month : \(currentPageDateCompos.month)");
            
            for prediction in self.predictionsData {
                
                let calendar = Calendar.current;
                let dateComponents = calendar.dateComponents(in: TimeZone.current, from: Date(milliseconds: Int(prediction.date)))
                
                let currentDateCompos = Calendar.current.dateComponents(in: TimeZone.current, from: Date());
                
                print("Predictive Date month : \(dateComponents.month)");
                
                //Check if predictive data has
                //1.) If start time month < todays month
                //2.) If start time month is same as current month but date is less than current date
                //3.) If start time month is less than calendar page month.
                //print(dateComponents.month!, todayDateComponents.month!)
                //print(dateComponents.year!, todayDateComponents.year!)

               /* if ((dateComponents.day! >= todayDateComponents.day! && dateComponents.month! == todayDateComponents.month!) || ((dateComponents.month! > todayDateComponents.month!) && (dateComponents.year! >= todayDateComponents.year!)) || (dateComponents.month! < todayDateComponents.month! && (dateComponents.year! > todayDateComponents.year!))) {*/
                if (currentDateCompos.month == self.createGatheringDelegate.fsCalendarElements.month && (Int)(dateComponents.day as! Int) < (Int)(currentDateCompos.day as! Int) && currentDateCompos.year as! Int == dateComponents.year as! Int) {
                    continue;
                }
                
                
                if (self.createGatheringDelegate.fsCalendarElements.month == dateComponents.month) {
                    
                    //Lets make the users free for the same time for which
                    //the time was chosen earlier oon editing the event;
                    let eventDateCompos = Calendar.current.dateComponents(in: TimeZone.current, from: Date(millis: self.createGatheringDelegate.event.startTime));
                    
                    if (self.createGatheringDelegate.event.eventId != nil) {
                        
                        let startTimeComp = Calendar.current.dateComponents(in: TimeZone.current, from: Date(millis: self.createGatheringDelegate.event.startTime));
                        let endTimeComp = Calendar.current.dateComponents(in: TimeZone.current, from: Date(millis: self.createGatheringDelegate.event.endTime));

                        let origStartTimeComp = Calendar.current.dateComponents(in: TimeZone.current, from: Date(millis: self.createGatheringDelegate.createGathDto.originalEventStartTime));

                        let origEndTimeComp = Calendar.current.dateComponents(in: TimeZone.current, from: Date(millis: self.createGatheringDelegate.createGathDto.originalEventEndTime));

                        if (dateComponents.date! == origStartTimeComp.date! && dateComponents.month! == origStartTimeComp.month! && startTimeComp.hour! == origStartTimeComp.hour! && endTimeComp.hour! == origEndTimeComp.hour!) {
                            
                        /*}
                        if (self.createGatheringDelegate.event.eventId != nil && self.createGatheringDelegate.event.startTime == self.createGatheringDelegate.createGathDto.originalEventStartTime && self.createGatheringDelegate.event.endTime == self.createGatheringDelegate.createGathDto.originalEventEndTime) {*/
                            
                            var totalCenesMembers = 0;
                            var totalEventAttendees = 0;
                            let eventMembers = self.createGatheringDelegate.event.eventMembers;
                            for eventMem in eventMembers! {
                                if (eventMem.userId != nil) {
                                    totalCenesMembers += 1;
                                }
                                if (eventMem.eventMemberId != nil && eventMem.userId != nil) {
                                    totalEventAttendees += 1;
                                }
                            }
                            prediction.predictivePercentage = Int((totalCenesMembers/totalEventAttendees)*100);
                        
                            var aviableFrndsArrTmp = [String]();
                            let aviableFrndsArr = self.createGatheringDelegate.createGathDto.availableFriendsList.split(separator: ",");
                            
                            for eventMem in eventMembers! {
                                var isUserAvailable: Bool = false;
                                if (eventMem.eventMemberId != nil && eventMem.userId != nil) {
                                    
                                    for aviableFrndStr in aviableFrndsArr {
                                        if (Int32(aviableFrndStr) == eventMem.userId) {
                                            isUserAvailable = true;
                                            break;
                                        }
                                    }
                                    if (isUserAvailable ==  false) {
                                        aviableFrndsArrTmp.append(String(eventMem.userId));
                                    }
                                    
                                    if (aviableFrndsArrTmp.count > 0) {
                                        if (self.createGatheringDelegate.createGathDto.availableFriendsList.count > 0) {
                                            self.createGatheringDelegate.createGathDto.availableFriendsList = self.createGatheringDelegate.createGathDto.availableFriendsList + ",\(String(describing: eventMem.userId!))";

                                            
                                        } else {
                                            self.createGatheringDelegate.createGathDto.availableFriendsList = self.createGatheringDelegate.createGathDto.availableFriendsList + "\(String(describing: eventMem.userId!))";
                                        }
                                    }
                                }
                            }
                        } else {
                            self.createGatheringDelegate.createGathDto.availableFriendsList = prediction.attendingFriendsList;
                        }
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
            }
            self.predictiveCalendar.reloadData();
            self.createGatheringDelegate.createGathTableView.reloadData();
        }
    });
    }
}
