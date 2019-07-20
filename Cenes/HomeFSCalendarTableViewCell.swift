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
class HomeFSCalendarTableViewCell: UITableViewCell, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance, HomeFSCalendarCellProtocol{

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
    
    func updateCalendarToTodayMonth() {
        fsCalendar.currentPage = Date();
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(date, monthPosition)
        
        newHomeViewProtocolDelegate.calendarDatePressed(date: date);
    }
    
    
    //This fot number of dots
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
    
    //This is for dots color.
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
            return [UIColor.orange, UIColor(red:0.29, green:0.56, blue:0.89, alpha:1)];
        }
       return [UIColor.clear]
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return UIColor.orange;
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        return [UIColor.orange];
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        
        let cuurentPageDateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: calendar.currentPage.clampedDate);
    
        print("Start Data : ",calendar.currentPage.clampedDate.startOfMonth(), "End of month : ", calendar.currentPage.clampedDate.endOfMonth());
        
        let calendarPageComponents = Calendar.current.dateComponents(in: TimeZone.current, from: calendar.currentPage.clampedDate);
        
        print("Month Scroll : ",cuurentPageDateComponents.year," Month : ",cuurentPageDateComponents.month)
        
        newHomeViewControllerDelegate.homescreenDto.fsCalendarCurrentDateTimestamp = Int(calendar.currentPage.clampedDate.startOfMonth().millisecondsSince1970);
        
        newHomeViewControllerDelegate.getMonthPageEvents(compos: cuurentPageDateComponents, startimeStamp: Int(calendar.currentPage.clampedDate.startOfMonth().millisecondsSince1970), endtimeStamp: Int(calendar.currentPage.clampedDate.endOfMonth().millisecondsSince1970), scrollType: HomeScrollType.CALENDARSCROLL);
        
    }
}
