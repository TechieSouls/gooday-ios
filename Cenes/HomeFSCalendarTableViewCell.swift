//
//  HomeFSCalendarTableViewCell.swift
//  Deploy
//
//  Created by Cenes_Dev on 28/04/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit
import FSCalendar

protocol NewHomeViewProtocol {
    func calendarDatePressed(date: Date);
}
class HomeFSCalendarTableViewCell: UITableViewCell, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    @IBOutlet weak var fsCalendar: FSCalendar!
    
    var newHomeViewProtocolDelegate: NewHomeViewProtocol!;
    var newHomeViewControllerDelegate: NewHomeViewController!;
    let eventDateFormat = DateFormatter();
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        eventDateFormat.dateFormat = "yyyy-MM-dd";
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(date, monthPosition)
        
        newHomeViewProtocolDelegate.calendarDatePressed(date: date);
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        var dotsCount = 0;
        
        let calDateStr: String = eventDateFormat.string(from: date);
        if (newHomeViewControllerDelegate.homescreenDto.calendarEventsData.eventDates.contains(calDateStr)) {
            dotsCount = dotsCount + 1;
        }
        if (newHomeViewControllerDelegate.homescreenDto.calendarEventsData.holidayDates.contains(calDateStr)) {
            dotsCount = dotsCount + 1;
        }
        return dotsCount;
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        
        var dotsCount = 0;
        
        let calDateStr: String = eventDateFormat.string(from: date);
        if (newHomeViewControllerDelegate.homescreenDto.calendarEventsData.eventDates.contains(calDateStr)) {
            dotsCount = dotsCount + 1;
        }
        if (newHomeViewControllerDelegate.homescreenDto.calendarEventsData.holidayDates.contains(calDateStr)) {
            dotsCount = dotsCount + 1;
        }
        
        if (dotsCount == 1) {
             return [UIColor.orange];
        } else if (dotsCount == 2) {
            return [UIColor.orange, UIColor.blue];
        }
       return [UIColor.clear]
    }
}
