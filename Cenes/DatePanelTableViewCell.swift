//
//  DatePanelTableViewCell.swift
//  Deploy
//
//  Created by Cenes_Dev on 18/04/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class DatePanelTableViewCell: UITableViewCell, TimePickerDoneProtocol, DateClickedProtocol {

    @IBOutlet weak var startTimeBar: UIView!
    @IBOutlet weak var endTimeBar: UIView!
    @IBOutlet weak var dateBar: UIView!
    
    
    @IBOutlet weak var startBarArrow: UIImageView!
    @IBOutlet weak var endBarArrow: UIImageView!
    @IBOutlet weak var dateBarArrow: UIImageView!
    
    
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var createGatheringDelegate: CreateGatheringV2ViewController!;
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let startTimeBarTap = UITapGestureRecognizer.init(target: self, action: #selector(startTimeBarPressed));
        startTimeBar.addGestureRecognizer(startTimeBarTap);
        
        let endTimeBarTap = UITapGestureRecognizer.init(target: self, action: #selector(endTimeBarPressed));
        endTimeBar.addGestureRecognizer(endTimeBarTap);
        
        let dateBarTap = UITapGestureRecognizer.init(target: self, action: #selector(dateBarPressed));
        dateBar.addGestureRecognizer(dateBarTap);
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func startTimeBarPressed() {
        
        //Hide keyboard if opened.
        createGatheringDelegate.textfield.resignFirstResponder();
        
        //If user press the start bar
        if (createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.startBar] == true) {
            createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.startBar] = false
            startBarArrow.image = UIImage.init(named: "date_panel_right_arrow")
            createGatheringDelegate.timePickerView.isHidden = true;
            createGatheringDelegate.showHidePreviewGatheringButton(show: true);

            if (createGatheringDelegate.createGathDto.createGatheringRowsVisibility[CreateGatheringRows.predictiveCalendarRow] == true) {
                
                createGatheringDelegate.showHidePreviewGatheringButton(show: false);
                createGatheringDelegate.removeBlurredBackgroundView(viewToBlur:  createGatheringDelegate.predictiveCalendarViewTableViewCellDelegate)
                
                createGatheringDelegate.createGathTableView.reloadData();
            }
       
            //If StartBar Closed
            if (createGatheringDelegate.event.eventId != nil) {
                createGatheringDelegate.createGathDto.trackGatheringDataFilled[CreateGatheringFields.startTimeField] = true;
                //createGatheringDelegate.showHidePreviewGatheringButton();
            }
        } else {
            createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.startBar] = true
            startBarArrow.image = UIImage.init(named: "date_panel_down_arrow")
            createGatheringDelegate.timePickerView.isHidden = false;
            createGatheringDelegate.showHidePreviewGatheringButton(show: false);

            if (createGatheringDelegate.event.startTime != 0) {
                createGatheringDelegate.timePicker.date = Date(milliseconds: Int(createGatheringDelegate.event.startTime));
            }
            
            if (createGatheringDelegate.createGathDto.createGatheringRowsVisibility[CreateGatheringRows.predictiveCalendarRow] == true) {
                
                createGatheringDelegate.addBlurBackgroundView(viewToBlur:  createGatheringDelegate.predictiveCalendarViewTableViewCellDelegate)
                createGatheringDelegate.createGathTableView.reloadData();
            }
            //createGatheringDelegate.showHidePreviewGatheringButton();
            
            //If StartBar Closed
            if (createGatheringDelegate.event.eventId != nil) {
                createGatheringDelegate.createGathDto.trackGatheringDataFilled[CreateGatheringFields.startTimeField] = false;
                //createGatheringDelegate.showHidePreviewGatheringButton();
            }

        }
       
        //If user presses star when end bar is opened.
        if (createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.endBar] == true) {
            createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.endBar] = false
            endBarArrow.image = UIImage.init(named: "date_panel_right_arrow")
        }
        
    }
    
    @objc func endTimeBarPressed() {
        
        //Hide keyboard if opened.
        createGatheringDelegate.textfield.resignFirstResponder();

        if (createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.endBar] == true) {
            createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.endBar] = false
            endBarArrow.image = UIImage.init(named: "date_panel_right_arrow")
            createGatheringDelegate.timePickerView.isHidden = true;
            createGatheringDelegate.showHidePreviewGatheringButton(show: true);

            
            //If Predictive Calendar was opened and
            //The end time picker is also opened.
            //user closed the end time bar by clicking on it.
            //Then we will hide preview button in this case.
            if (createGatheringDelegate.createGathDto.createGatheringRowsVisibility[CreateGatheringRows.predictiveCalendarRow] == true) {
                
                createGatheringDelegate.showHidePreviewGatheringButton(show: false);

                createGatheringDelegate.removeBlurredBackgroundView(viewToBlur:  createGatheringDelegate.predictiveCalendarViewTableViewCellDelegate)
                
                createGatheringDelegate.createGathTableView.reloadData();
            }

            //If EndBar Closed
            if (createGatheringDelegate.event.eventId != nil) {
                createGatheringDelegate.createGathDto.trackGatheringDataFilled[CreateGatheringFields.endTimeField] = true;
                //createGatheringDelegate.showHidePreviewGatheringButton(show: true);
            }
        } else {
            
            //This is the case when end time bar was close and user
            //clicked on it to open it.
            createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.endBar] = true
            endBarArrow.image = UIImage.init(named: "date_panel_down_arrow")
            createGatheringDelegate.timePickerView.isHidden = false;
            createGatheringDelegate.showHidePreviewGatheringButton(show: false);

            //Showing already selected dat in time picker.
            if (createGatheringDelegate.event.endTime != 0) {
                createGatheringDelegate.timePicker.date = Date(milliseconds: Int(createGatheringDelegate.event.endTime));
            }
            
            if (createGatheringDelegate.createGathDto.createGatheringRowsVisibility[CreateGatheringRows.predictiveCalendarRow] == true) {
                
                createGatheringDelegate.addBlurBackgroundView(viewToBlur:   createGatheringDelegate.predictiveCalendarViewTableViewCellDelegate)
                
                createGatheringDelegate.createGathTableView.reloadData();
            }
            
            //If EndBar Opened
            if (createGatheringDelegate.event.eventId != nil) {
                createGatheringDelegate.createGathDto.trackGatheringDataFilled[CreateGatheringFields.endTimeField] = false;
                //createGatheringDelegate.showHidePreviewGatheringButton(show: false);
            }
        }

        //If user presses end bar when start bar is opened.
        if (createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.startBar] == true) {
            createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.startBar] = false
            startBarArrow.image = UIImage.init(named: "date_panel_right_arrow");
        }
    }
    
    @objc func dateBarPressed() {
        
        if (createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.startBar] == false && createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.endBar] == false) {
            
            //Date Bar is already Press and Predivitve Calendar is visible
            if (createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.dateBar] == true) {
                
                createGatheringDelegate.showHidePreviewGatheringButton(show: true);
                
                dateBarArrow.image = UIImage.init(named: "date_panel_right_arrow")
                createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.dateBar] = false
                createGatheringDelegate.createGathDto.createGatheringRowsVisibility[CreateGatheringRows.predictiveCalendarRow] = false;
                createGatheringDelegate.createGathDto.createGatheringRowsVisibility[CreateGatheringRows.eventInfoPanelRow] = true;
                
                
                createGatheringDelegate.removeBlurredBackgroundView(viewToBlur:    createGatheringDelegate.predictiveCalendarViewTableViewCellDelegate)
                
                
                //If EndBar Opened
                if (createGatheringDelegate.event.eventId != nil) {
                    createGatheringDelegate.createGathDto.trackGatheringDataFilled[CreateGatheringFields.dateField] = true;
                    //createGatheringDelegate.showHidePreviewGatheringButton();
                }
            } else {
                createGatheringDelegate.showHidePreviewGatheringButton(show: false);

                //Date Bar is closed and user pressed it to choose date from Calendar
            createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.dateBar] = true
            createGatheringDelegate.createGathDto.createGatheringRowsVisibility[CreateGatheringRows.predictiveCalendarRow] = true;
            createGatheringDelegate.createGathDto.createGatheringRowsVisibility[CreateGatheringRows.eventInfoPanelRow] = false;
                
                dateBarArrow.image = UIImage.init(named: "date_panel_down_arrow")
                
                if (createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.startBar] == true || createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.endBar] == true) {
                    
                    createGatheringDelegate.addBlurBackgroundView(viewToBlur:   createGatheringDelegate.predictiveCalendarViewTableViewCellDelegate)
                }
                
                //If EndBar Opened
                if (createGatheringDelegate.event.eventId != nil) {
                    createGatheringDelegate.createGathDto.trackGatheringDataFilled[CreateGatheringFields.dateField] = false;
                    //createGatheringDelegate.showHidePreviewGatheringButton();
                }
            }
            createGatheringDelegate.createGathTableView.reloadData();
        }
    }
    
    func timePickerDoneButtonPressed(timeInMillis: Int) {
        
        if (createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.startBar] == true) {
            startTimeLabel.isHidden = false;
            startTimeLabel.text = Date(milliseconds: timeInMillis).hmma();
            startBarArrow.image = UIImage.init(named: "date_panel_right_arrow")
            
            //Setting start time in event
            createGatheringDelegate.event.startTime = Int64(timeInMillis);
            
            //If user has not set end time then we will set default time to 1 hour next to start time
            if (createGatheringDelegate.event.endTime == nil || createGatheringDelegate.event.endTime == 0) {
                //Incrementing End Date to next hour from current hour
                let calendar = Calendar.current;
                var components = calendar.dateComponents(in: TimeZone.current, from: Date(milliseconds: timeInMillis));
                components.hour = components.hour! + 1;
                let endDate = calendar.date(from: components);
                endTimeLabel.isHidden = false;
                endTimeLabel.text = endDate!.hmma();
                
                //Setting end time in event
                createGatheringDelegate.event.endTime = endDate!.millisecondsSince1970;
            } else {
                if (createGatheringDelegate.event.endTime < createGatheringDelegate.event.startTime) {
                    var dateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: Date(milliseconds: Int(createGatheringDelegate.event.endTime)));
                    dateComponents.day = dateComponents.day! + 1;
                    
                    print(Calendar.current.date(from: dateComponents)!.millisecondsSince1970)
                    createGatheringDelegate.event.endTime = Calendar.current.date(from: dateComponents)!.millisecondsSince1970;
                }
            }
            
            //Code to show hide Event Preview Button.
            createGatheringDelegate.createGathDto.trackGatheringDataFilled[CreateGatheringFields.startTimeField] = true;
            createGatheringDelegate.createGathDto.trackGatheringDataFilled[CreateGatheringFields.endTimeField] = true;
            //createGatheringDelegate.showHidePreviewGatheringButton();
            
        }
        
        //If EndTime Bar was opened.
        if (createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.endBar] == true) {
            endTimeLabel.isHidden = false;
            endTimeLabel.text = Date(milliseconds: timeInMillis).hmma();
            endBarArrow.image = UIImage.init(named: "date_panel_right_arrow")
            
            
            var datePickerDateComponets = Calendar.current.dateComponents(in: TimeZone.current, from: Date(milliseconds: timeInMillis))
            
            var startTimeDateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: Date(milliseconds: Int(createGatheringDelegate.event.startTime)));
            
            //It means if start time hour is greater that selected time in date piccker.
            //Like start time is 5pm and timepicker time is 1pm
            //Then we will make end time the next day
            print("Hour of end time : ", datePickerDateComponets.hour, datePickerDateComponets.day)
            let startTimeHour: Int = startTimeDateComponents.hour!;
            let timePickerHour: Int = datePickerDateComponets.hour!;
            
            if (startTimeHour > timePickerHour) {
                createGatheringDelegate.event.endTime = Calendar.current.date(byAdding: .day, value: 1, to: Date(milliseconds: timeInMillis))!.millisecondsSince1970;
                            } else {
                datePickerDateComponets.day = startTimeDateComponents.day!;
                createGatheringDelegate.event.endTime = Calendar.current.date(from: datePickerDateComponets)!.millisecondsSince1970;
            }
            //createGatheringDelegate.event.endTime = Calendar.current.date(from: datePickerDateComponets)!.millisecondsSince1970;
            print("End Time : ", createGatheringDelegate.event.endTime);
            //Code to show hide Event Preview Button.
            createGatheringDelegate.createGathDto.trackGatheringDataFilled[CreateGatheringFields.endTimeField] = true;
            //createGatheringDelegate.showHidePreviewGatheringButton();
        }
        
        //This is the case if Predictive calendar is also opened behind Date Picker.
        if (createGatheringDelegate.createGathDto.createGatheringRowsVisibility[CreateGatheringRows.predictiveCalendarRow] == true) {
            
            createGatheringDelegate.showHidePreviewGatheringButton(show: false);
            createGatheringDelegate.removeBlurredBackgroundView(viewToBlur:  createGatheringDelegate.predictiveCalendarViewTableViewCellDelegate)
            
            createGatheringDelegate.createGathTableView.reloadData();
        } else {
            createGatheringDelegate.showHidePreviewGatheringButton(show: true);
        }
    
        createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.startBar] =  false
        createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.endBar] =  false
        
        //If Predictive was on then, we would have to refesh the predictive calendar
        if (createGatheringDelegate.predictiveCalendarViewTableViewCellDelegate != nil && createGatheringDelegate.event.isPredictiveOn == true) {
            createGatheringDelegate.predictiveCalendarViewTableViewCellDelegate.showPredictions();
        }
        
    }
    
    func timePickerCancelButtonPressed() {
        if (createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.startBar] == true) {
            startBarArrow.image = UIImage.init(named: "date_panel_right_arrow")
            
            //If StartBar Closed
            if (createGatheringDelegate.event.eventId != nil && createGatheringDelegate.event.eventId != 0) {
                createGatheringDelegate.createGathDto.trackGatheringDataFilled[CreateGatheringFields.startTimeField] = true;
                //createGatheringDelegate.showHidePreviewGatheringButton();
            }
        }
        if (createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.endBar] == true) {
            endBarArrow.image = UIImage.init(named: "date_panel_right_arrow");
            
            //If StartBar Closed
            if (createGatheringDelegate.event.eventId != nil && createGatheringDelegate.event.eventId != 0) {
                createGatheringDelegate.createGathDto.trackGatheringDataFilled[CreateGatheringFields.endTimeField] = true;
                //createGatheringDelegate.showHidePreviewGatheringButton();
            }
        }
        
        if (createGatheringDelegate.createGathDto.createGatheringRowsVisibility[CreateGatheringRows.predictiveCalendarRow] == true) {
            
            createGatheringDelegate.showHidePreviewGatheringButton(show: false);
            createGatheringDelegate.removeBlurredBackgroundView(viewToBlur:  createGatheringDelegate.predictiveCalendarViewTableViewCellDelegate)
            
            createGatheringDelegate.createGathTableView.reloadData();
        } else {
            createGatheringDelegate.showHidePreviewGatheringButton(show: true);
        }
        
        createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.startBar] =  false
        createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.endBar] =  false

    }
    
    func predictiveCalendarDatePressed(date: Date) {
        dateLabel.isHidden = false
        
        let currentYearComponent = Calendar.current.component(.year, from: Date());
        
        let startDateYearComponent = Calendar.current.component(.year, from: date);

        if (currentYearComponent > startDateYearComponent || currentYearComponent < startDateYearComponent) {
            dateLabel.text = String(date.EMMMMdyyyy()!);
            
        } else {
            dateLabel.text = String(date.EMMMd()!);
        }
        createGatheringDelegate.createGathDto.createGatheringRowsVisibility[CreateGatheringRows.predictiveCalendarRow] = true;
        
        createGatheringDelegate.createGathDto.createGatheringRowsVisibility[CreateGatheringRows.eventInfoPanelRow] = true
        
        //dateBarArrow.image = UIImage.init(named: "date_panel_right_arrow")
        //createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.dateBar] = true
        
        
        let selectedDateCal = Calendar.current;
        let selectedDateComponents = selectedDateCal.dateComponents(in: TimeZone.current, from: date);
        
        //Incrementing End Date to next hour from current hour
        let calendar = Calendar.current;
        var startComponents = calendar.dateComponents(in: TimeZone.current, from: Date(milliseconds: Int(createGatheringDelegate.event.startTime)));
        
        var startComponentsTemp = DateComponents();
        startComponentsTemp.hour = startComponents.hour
        startComponentsTemp.minute = startComponents.minute
        startComponentsTemp.second = startComponents.second
        startComponentsTemp.nanosecond = 0;
        startComponentsTemp.day = selectedDateComponents.day
        startComponentsTemp.month = selectedDateComponents.month
        startComponentsTemp.year = startDateYearComponent

        let startDateTemp = calendar.date(from: startComponentsTemp);
        createGatheringDelegate.event.startTime = startDateTemp!.millisecondsSince1970;
       print("Start Time After Date Selected : ",createGatheringDelegate.event.startTime);
        
        let endCalendar = Calendar.current;
        var endComponents = endCalendar.dateComponents(in: TimeZone.current, from: Date(milliseconds: Int(createGatheringDelegate.event.endTime)));
        
        
        var endComponentsTemp = DateComponents();
        endComponentsTemp.hour = endComponents.hour
        endComponentsTemp.minute = endComponents.minute
        endComponentsTemp.second = endComponents.second
        endComponentsTemp.nanosecond = 0;
        endComponentsTemp.day = selectedDateComponents.day;
        endComponentsTemp.day = selectedDateComponents.day
        endComponentsTemp.month = selectedDateComponents.month
        endComponentsTemp.year = startDateYearComponent

        var endDate = endCalendar.date(from: endComponentsTemp);
        if ((endComponents.hour!) < (startComponents.hour!)) {
            endDate = Calendar.current.date(byAdding: .day, value: 1, to: endDate!)
        } else if ((endComponents.hour!) == (startComponents.hour!) && (endComponents.minute!) < (startComponents.minute!)) {
            endDate = Calendar.current.date(byAdding: .day, value: 1, to: endDate!)
        }
        createGatheringDelegate.event.endTime = endDate!.millisecondsSince1970;
        print("End Time After Date Selected : ",createGatheringDelegate.event.endTime);
        
        //Code to show hide Event Preview Button.
        createGatheringDelegate.createGathDto.trackGatheringDataFilled[CreateGatheringFields.dateField] = true;
        //createGatheringDelegate.showHidePreviewGatheringButton();
        
        createGatheringDelegate.createGathTableView.reloadData();
        
        
        //If StartBar Closed
        if (createGatheringDelegate.event.eventId != nil && createGatheringDelegate.event.eventId != 0) {
            createGatheringDelegate.createGathDto.trackGatheringDataFilled[CreateGatheringFields.dateField] = true;
            //createGatheringDelegate.showHidePreviewGatheringButton();
        }
        
        //createGatheringDelegate.showHidePreviewGatheringButton(show: true);
    }
}
