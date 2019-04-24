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
        
        //If user press the start bar
        if (createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.startBar] == true) {
            createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.startBar] = false
            startBarArrow.image = UIImage.init(named: "date_panel_right_arrow")
            createGatheringDelegate.timePickerView.isHidden = true;

        } else {
            createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.startBar] = true
            startBarArrow.image = UIImage.init(named: "date_panel_down_arrow")
            createGatheringDelegate.timePickerView.isHidden = false;
            
            if (createGatheringDelegate.event.startTime != 0) {
                createGatheringDelegate.timePicker.date = Date(milliseconds: Int(createGatheringDelegate.event.startTime));
            }
        }
       
        //If user presses star when end bar is opened.
        if (createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.endBar] == true) {
            createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.endBar] = false
            endBarArrow.image = UIImage.init(named: "date_panel_right_arrow")
        }
        
    }
    
    @objc func endTimeBarPressed() {
        
        if (createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.endBar] == true) {
            createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.endBar] = false
            endBarArrow.image = UIImage.init(named: "date_panel_right_arrow")
            createGatheringDelegate.timePickerView.isHidden = true;

        } else {
            createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.endBar] = true
            endBarArrow.image = UIImage.init(named: "date_panel_down_arrow")
            createGatheringDelegate.timePickerView.isHidden = false;
            
            //Showing already selected dat in time picker.
            if (createGatheringDelegate.event.endTime != 0) {
                createGatheringDelegate.timePicker.date = Date(milliseconds: Int(createGatheringDelegate.event.endTime));
            }
            

        }
        
        //If user presses end bar when start bar is opened.
        if (createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.startBar] == true) {
            createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.startBar] = false
            startBarArrow.image = UIImage.init(named: "date_panel_right_arrow");
        }
    }
    
    @objc func dateBarPressed() {
        
        if (createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.dateBar] == true) {
            
            dateBarArrow.image = UIImage.init(named: "date_panel_right_arrow")
            createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.dateBar] = false
            createGatheringDelegate.createGathDto.createGatheringRowsVisibility[CreateGatheringRows.predictiveCalendarRow] = false;
        } else {
            createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.dateBar] = true
            createGatheringDelegate.createGathDto.createGatheringRowsVisibility[CreateGatheringRows.predictiveCalendarRow] = true;
            dateBarArrow.image = UIImage.init(named: "date_panel_down_arrow")
        }
        createGatheringDelegate.createGathTableView.reloadData();
    }
    
    func timePickerDoneButtonPressed(timeInMillis: Int) {
        
        
        if (createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.startBar] == true) {
            startTimeLabel.isHidden = false;
            startTimeLabel.text = Date(milliseconds: timeInMillis).hmma();
            startBarArrow.image = UIImage.init(named: "date_panel_right_arrow")
            
            //Setting start time in event
            createGatheringDelegate.event.startTime = Int64(timeInMillis);
            
            //Incrementing End Date to next hour from current hour
            let calendar = Calendar.current;
            var components = calendar.dateComponents(in: TimeZone.current, from: Date(milliseconds: timeInMillis));
            components.hour = components.hour! + 1;
            let endDate = calendar.date(from: components);
            endTimeLabel.isHidden = false;
            endTimeLabel.text = endDate!.hmma();
            
            //Setting end time in event
            createGatheringDelegate.event.endTime = endDate!.millisecondsSince1970;
            
            //Code to show hide Event Preview Button.
            createGatheringDelegate.createGathDto.trackGatheringDataFilled[CreateGatheringFields.startTimeField] = true;
            createGatheringDelegate.createGathDto.trackGatheringDataFilled[CreateGatheringFields.endTimeField] = true;
            createGatheringDelegate.showHidePreviewGatheringButton();
        }
        
        if (createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.endBar] == true) {
            endTimeLabel.isHidden = false;
            endTimeLabel.text = Date(milliseconds: timeInMillis).hmma();
            endBarArrow.image = UIImage.init(named: "date_panel_right_arrow")
            
            //Code to show hide Event Preview Button.
            createGatheringDelegate.createGathDto.trackGatheringDataFilled[CreateGatheringFields.endTimeField] = true;
            createGatheringDelegate.showHidePreviewGatheringButton();
        }
    
        createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.startBar] =  false
        createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.endBar] =  false
    }
    
    func timePickerCancelButtonPressed() {
        if (createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.startBar] == true) {
            startBarArrow.image = UIImage.init(named: "date_panel_right_arrow")
        }
        if (createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.endBar] == true) {
            endBarArrow.image = UIImage.init(named: "date_panel_right_arrow")
        }
        
        createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.startBar] =  false
        createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.endBar] =  false
    }
    
    func predictiveCalendarDatePressed(date: Date) {
        dateLabel.isHidden = false
        dateLabel.text = String(date.EMMMd()!);
        createGatheringDelegate.createGathDto.createGatheringRowsVisibility[CreateGatheringRows.predictiveCalendarRow] = false;
        
        dateBarArrow.image = UIImage.init(named: "date_panel_right_arrow")
        createGatheringDelegate.createGathDto.barSelected[CreateGatheringBars.dateBar] = false
        
        
        let selectedDateCal = Calendar.current;
        let selectedDateComponents = selectedDateCal.dateComponents(in: TimeZone.current, from: date);
        
        //Incrementing End Date to next hour from current hour
        let calendar = Calendar.current;
        var startComponents = calendar.dateComponents(in: TimeZone.current, from: Date(milliseconds: Int(createGatheringDelegate.event.startTime)));
        startComponents.day = selectedDateComponents.day
        let startDate = calendar.date(from: startComponents);
        createGatheringDelegate.event.startTime = startDate!.millisecondsSince1970;
        print(createGatheringDelegate.event.startTime);
        
        let endCalendar = Calendar.current;
        var endComponents = endCalendar.dateComponents(in: TimeZone.current, from: Date(milliseconds: Int(createGatheringDelegate.event.endTime)));
        endComponents.day = selectedDateComponents.day
        let endDate = endCalendar.date(from: endComponents);
        createGatheringDelegate.event.endTime = endDate!.millisecondsSince1970;
        print(createGatheringDelegate.event.endTime);
        
        //Code to show hide Event Preview Button.
        createGatheringDelegate.createGathDto.trackGatheringDataFilled[CreateGatheringFields.dateField] = true;
        createGatheringDelegate.showHidePreviewGatheringButton();
        
        createGatheringDelegate.createGathTableView.reloadData();
    }
}
