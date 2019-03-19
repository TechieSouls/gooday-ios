
//
//  GatheringTableViewCellFive.swift
//  Cenes
//
//  Created by Redblink on 05/09/17.
//  Copyright © 2017 Sabita Rani Samal. All rights reserved.
//

import UIKit
import FSCalendar
import NVActivityIndicatorView


protocol GatheringTableViewCellFiveDelegate : class {
    func setCase(caseHeight : CellHeight , cellIndex : IndexPath)
    func timePick(cell:GatheringDateTableViewCell,tag:Int)
}

class GatheringDateTableViewCell: UITableViewCell,CreateGatheringViewControllerDelegate ,NVActivityIndicatorViewable{
    
    var nactvityIndicatorView = NVActivityIndicatorView.init(frame: cgRectSizeLoading, type: NVActivityIndicatorType.lineScaleParty, color: UIColor.white, padding: 0.0);
    
    let timePicker = UIDatePicker();
    
    @IBOutlet weak var firstView: UIView!
    
    @IBOutlet weak var timeView: UIView!
    
    @IBOutlet weak var predictiveTimeView: UIView!
    
    var cellDelegate : GatheringTableViewCellFiveDelegate!
    
    @IBOutlet weak var predictiveButtonView: UIView!
    
    @IBOutlet weak var suggestedTimeView: UIView!
    
    @IBOutlet weak var calendarOuterView: UIView!
    
    var minDate : Date!
    var maxDate : Date!
    var cellHeight : CellHeight!
    
    var cellIndex : IndexPath!
    
    var gatheringView : CreateGatheringViewController!
    
    
    @IBOutlet weak var chooseTimingAgainButton: UIButton!
    
    @IBOutlet weak var startTimeDateLabel: UILabel!
    
    @IBOutlet weak var startTimeLabel: UILabel!
    
    @IBOutlet weak var endTimeDateLabel: UILabel!
    
    @IBOutlet weak var endTimeLabel: UILabel!
    
    @IBOutlet weak var thirdViewTimeLabel: UILabel!
    
    @IBOutlet weak var thirdViewONOFFLabel: UILabel!
    
    @IBOutlet weak var suggestedTimeLabel: UILabel!
    @IBOutlet weak var suggestedDateLabel: UILabel!
    
    @IBOutlet weak var calendarView: FSCalendar!
    
    @IBOutlet weak var switchPredictive: UISwitch!
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"//"MM/dd/yyyy"
        return formatter
    }()
    
    var fillDefaultColors =  NSMutableDictionary()
    let colorRed = UIColor(red: 255/255, green: 34/255, blue: 21/255, alpha: 0.9)
    let commonOrange = UIColor(red: 255/255, green: 143/255, blue: 21/255, alpha: 0.9)
    let commonYellow = UIColor(red: 254/255, green: 255/255, blue: 21/255, alpha: 0.9)
    let commonLime = UIColor(red: 154/255, green: 255/255, blue: 21/255, alpha: 0.9)
    let commonGreen = UIColor(red: 21/255, green: 255/255, blue: 21/255, alpha: 0.9)
    
    var arrayColor : [UIColor]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        calendarView.tintColor = commonColor
        calendarView.appearance.headerTitleColor = commonColor
        calendarView.appearance.weekdayTextColor = commonColor
        //calendarView.appearance.todaySelectionColor = commonColor
        
        calendarView.delegate = self
        //self.calendarView.app
        self.calendarView.scope = .month
        
        
        calendarView.appearance.headerMinimumDissolvedAlpha = 0
        calendarView.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesSingleUpperCase]
        calendarView.clipsToBounds = true
        calendarView.appearance.borderRadius = 0
        
        calendarView.placeholderType = FSCalendarPlaceholderType.none
        arrayColor = [self.colorRed,self.commonOrange,self.commonYellow,self.commonLime,self.commonGreen]
        
        let dateFormatterNew = DateFormatter()
        
            dateFormatterNew.dateFormat = "MMM dd, YYYY"
        
            //self.setDateTimeValues(tag: .StartDate, value: dateFormatterNew.string(from: Date()))
            
        var datecomponent: DateComponents! = DateComponents()
        
            //Getting minutes from current date to check if its multiple of 5
            let minute = Calendar.current.component(.minute, from: Date())
            var minutesToAddForMakingMultipleOfFive = 0;
            if (minute % 5 != 0) {
                datecomponent.minute = (5 - minute % 5);
                minutesToAddForMakingMultipleOfFive = (5 - minute % 5);
            }
        
        print("minutesToAddForMakingMultipleOfFive :\(minutesToAddForMakingMultipleOfFive)")
            let startDate = Calendar.current.date(byAdding: datecomponent, to: Date().clampedDate)
        //print(startDate?.clampedDate.addingTimeInterval(60.0 * Double(minutesToAddForMakingMultipleOfFive)));

        
            startDate?.clampedDate.addingTimeInterval(60.0 * Double(minutesToAddForMakingMultipleOfFive));
        //gatheringView.startTime = "\(startDate?.millisecondsSince1970 ?? Date().millisecondsSince1970)" ;
            datecomponent.minute = 60;
            let endDate = Calendar.current.date(byAdding: datecomponent, to: startDate!)
        
            //if ((endDate?.millisecondsSince1970)! < (startDate?.millisecondsSince1970)!) {
              //  let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: startDate!)
                //gatheringView.endTime = "\(tomorrow?.millisecondsSince1970 ?? Date().millisecondsSince1970)";
            //}
        
            //self.setDateTimeValues(tag: .EndDate, value: dateFormatterNew.string(from: Date()))
        
            dateFormatterNew.dateFormat = "h:mm a"
        self.setDateTimeValues(tag: .StartTime, value: dateFormatterNew.string(from: startDate!))
        
        self.setDateTimeValues(tag: .EndTime, value: dateFormatterNew.string(from: endDate!))
        
        self.setMinMaxDate()
        self.calendarView.dataSource = self
        
        
    }
    
    
    
    func setUpdatedDate(){
        
        print("[setUpdatedDate] : Inside Function");
        if self.gatheringView != nil {
        //if self.gatheringView.FirstDate >= self.gatheringView.SecondDate{
         if self.gatheringView.event.startTime >= self.gatheringView.event.endTime{
            let dateFormatterNew = DateFormatter()
            
            dateFormatterNew.dateFormat = "MMM dd, YYYY"
            var datecomponent = DateComponents()
            datecomponent.minute = 1
            let startDate = Calendar.current.date(byAdding: datecomponent, to: Date(timeIntervalSince1970: TimeInterval(self.gatheringView.event.startTime/1000)))
            
            dateFormatterNew.dateFormat = "h:mm a"
             self.endTimeLabel.text = dateFormatterNew.string(from: startDate!)
             self.gatheringView.SecondDate = startDate
            }
        }
    }
    
    
     func setFirstDateSecondDate() {
        /*self.gatheringView.FirstDate = self.getFirstDateLastDate(first: true)
        self.gatheringView.SecondDate = self.getFirstDateLastDate(first: false)*/
        
        self.gatheringView.event.startTime = self.getFirstDateLastDate(first: true).millisecondsSince1970;
        self.gatheringView.event.endTime = self.getFirstDateLastDate(first: false).millisecondsSince1970;
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setFirstCase(){
        
        self.firstView.isHidden = false
        self.timeView.isHidden = true
        self.predictiveTimeView.isHidden = true
        self.predictiveButtonView.isHidden = true
        self.suggestedTimeView.isHidden = true
        self.calendarOuterView.isHidden = true
        self.cellHeight = CellHeight.First
        
    }
    
    func setSecondCase(){
        self.firstView.isHidden = true
        self.timeView.isHidden = false
        self.predictiveTimeView.isHidden = true
        self.predictiveButtonView.isHidden = false
        self.suggestedTimeView.isHidden = true
        self.calendarOuterView.isHidden = true
        self.cellHeight = CellHeight.Second
    }
    
    func setThirdCase(){
        minDate = Date()
        self.firstView.isHidden = true
        self.timeView.isHidden = false
        self.predictiveTimeView.isHidden = true
        self.predictiveButtonView.isHidden = false
        self.suggestedTimeView.isHidden = true
        self.calendarOuterView.isHidden = false
        self.cellHeight = CellHeight.Third
        self.calendarView.reloadData()
        self.calendarView.isUserInteractionEnabled = true
        self.chooseTimingAgainButton.isUserInteractionEnabled = true
        self.switchPredictive.isUserInteractionEnabled = true
    }
    
    func setFourthCase(){
        self.firstView.isHidden = true
        self.timeView.isHidden = true
        self.predictiveTimeView.isHidden = false
        self.predictiveButtonView.isHidden = true
        self.suggestedTimeView.isHidden = true
        self.calendarOuterView.isHidden = true
        self.cellHeight = CellHeight.Fourth
    }
    
    func setFifthCase(){
        self.firstView.isHidden = true
        self.timeView.isHidden = true
        self.predictiveTimeView.isHidden = false
        self.predictiveButtonView.isHidden = false
        self.suggestedTimeView.isHidden = false
        self.calendarOuterView.isHidden = false
        self.cellHeight = CellHeight.Fifth
        
        self.switchPredictive.isOn = self.gatheringView.event.isPredictiveOn
        self.switchPredictive.isUserInteractionEnabled = false
        self.calendarView.isUserInteractionEnabled = false
        self.chooseTimingAgainButton.isUserInteractionEnabled = false
        self.calendarView.select(self.gatheringView.selectedDate)
        
        if self.gatheringView.event.isPredictiveOn {
            self.ParseResult(returnedArray: self.gatheringView.predictiveData)
        }
        
        
    }
    
    @IBAction func firstViewButtonPressed(_ sender: Any) {
        
        self.setThirdCase()
        self.cellDelegate.setCase(caseHeight: .Third, cellIndex: self.cellIndex)
        
    }
    
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        
        if sender.isOn {
            self.gatheringView.event.isPredictiveOn = true
            self.getPreditveData()
            
        }else{
            self.gatheringView.event.isPredictiveOn = false
            self.fillDefaultColors = NSMutableDictionary()
            self.calendarView.reloadData()
        }
    }
    
    
    
    
    func getSelectedFirstDate(first:Bool,dateFrom:Date) -> Date {
        
        let dateFormatterNew = DateFormatter()
        
        
        dateFormatterNew.dateFormat = "MMM dd, yyyy"
        let newDateString = dateFormatterNew.string(from: dateFrom)
        
        
        dateFormatterNew.dateFormat = "MMM dd, yyyy h:mm a"
        
        if first {
            
            let startTime = self.startTimeLabel.text
            let startDateString = newDateString+" "+startTime!
            return dateFormatterNew.date(from: startDateString)!
            
        }else{
            
            let endTime = self.endTimeLabel.text
            
            let endDateString = newDateString+" "+endTime!
            return dateFormatterNew.date(from: endDateString)!
        }
    }
    
    
    func setMinMaxDate(){
        
        minDate = Date()
        var datecomponent = DateComponents()
        datecomponent.year = 1
        let dateMax = Calendar.current.date(byAdding: datecomponent, to: Date())
        maxDate = dateMax
        
    }
    
    func getFirstDateLastDate(first:Bool) -> Date{
        
        let dateFormatterNew = DateFormatter()
        
        dateFormatterNew.dateFormat = "h:mm a"
        
        if first {
            
            
            let startTime = self.startTimeLabel.text
            let date = dateFormatterNew.date(from: startTime!)
            var datecomponent = NSCalendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: self.calendarView.selectedDate != nil ? self.calendarView.selectedDate! : Date())
            datecomponent.hour = NSCalendar.current.component(.hour, from: date!)
            datecomponent.minute  = NSCalendar.current.component(.minute, from: date!)
            let startDateReturn = Calendar.current.date(from: datecomponent)
            
            return startDateReturn!
            
        }else{
            let endTime = self.endTimeLabel.text
            let date = dateFormatterNew.date(from: endTime!)
            
            var datecomponent = NSCalendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: self.calendarView.selectedDate != nil ? self.calendarView.selectedDate! : Date())
            datecomponent.hour = NSCalendar.current.component(.hour, from: date!)
            datecomponent.minute  = NSCalendar.current.component(.minute, from: date!)
            let endDateReturn = Calendar.current.date(from: datecomponent)
            
            return endDateReturn!
        }
    }
    
    
    
    
    func getPreditveData(){
        
        let dateFormatterNew = DateFormatter()
        
//        print("millisecond Starts =\(startDateNew?.millisecondsSince1970)")
//        
//        print("milliseconds End =\(endDateNew?.millisecondsSince1970)")
        self.gatheringView.startAnimating(loadinIndicatorSize, message: "Loading...", type: self.nactvityIndicatorView.type)
        
        
        var friendsStr = ""
        var friendStrArray = [String]()
        if self.gatheringView.FriendArray.count > 0 {
            for user in self.gatheringView.FriendArray {
                
                friendStrArray.append(user.userId)
            }
            
            friendsStr = friendStrArray.joined(separator: ",")
        }
        
        
        
        
        /*var datecomponent = NSCalendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: self.gatheringView.FirstDate)*/
        var datecomponent = NSCalendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: Date(timeIntervalSince1970: TimeInterval(self.gatheringView.event.startTime)));
        datecomponent.month = NSCalendar.current.component(.month, from: self.calendarView.currentPage)
        datecomponent.year = NSCalendar.current.component(.year, from: self.calendarView.currentPage)
        let firstDate = Calendar.current.date(from: datecomponent)
        
        /*datecomponent = NSCalendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: self.gatheringView.SecondDate)*/
        datecomponent = NSCalendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: Date(timeIntervalSince1970: TimeInterval(self.gatheringView.event.endTime)));
        datecomponent.month = NSCalendar.current.component(.month,from: self.calendarView.currentPage)
        datecomponent.year = NSCalendar.current.component(.year, from: self.calendarView.currentPage)
        let secondDate = Calendar.current.date(from: datecomponent)
        let startTime = "\((firstDate?.millisecondsSince1970)!)"
        let endTime = "\((secondDate?.millisecondsSince1970)!)"
        
        WebService().getPredictiveData(startTime: startTime, endTime: endTime, friends: friendsStr) { (returnedDict) in
            print("Called data executed")
            
            self.gatheringView.stopAnimating()
            
            if returnedDict.value(forKey: "Error") as? Bool == true {
                
                (self.cellDelegate as? GatheringViewController)? .showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                
            }else{
                let returnedArray = returnedDict["data"] as? NSArray
                
                
                if ((returnedArray?.count) != nil) {
                    print(returnedArray!)
                    
                    self.gatheringView.predictiveData = NSMutableArray(array: returnedArray!)
                    
                    self.ParseResult(returnedArray: self.gatheringView.predictiveData)
                    
                }
            }

        }
        
        
    }
    
    func ParseResult(returnedArray: NSMutableArray){
        
        let dateFormatterNew = DateFormatter()
        
        dateFormatterNew.dateFormat = "yyyy/MM/dd"
        
        for i : Int in 0..<(returnedArray.count){
            let dict = returnedArray[i] as! NSDictionary
            
            let date =  dict.value(forKey: "date") as? Int
            
            let dateNew = Date(milliseconds: date!)
            
            let key = dateFormatterNew.string(from: dateNew)
            print(key)
            let dataColor : Int = (dict.value(forKey: "predictivePercentage") as? Int)!
            
            switch dataColor {
            
            case _ where dataColor < 0:
                print(dataColor)
                self.fillDefaultColors[key] = self.colorRed
            case 0 ... 24:
                print(dataColor)
                self.fillDefaultColors[key] = self.colorRed
                
            case 25 ... 49:
                self.fillDefaultColors[key] = self.commonOrange
                print(dataColor)
            case 50 ... 74:
                self.fillDefaultColors[key] = self.commonYellow
                print(dataColor)
            case 75 ... 99:
                self.fillDefaultColors[key] = self.commonLime
                print(dataColor)
            case 100:
                self.fillDefaultColors[key] = self.commonGreen
                print(dataColor)
                
            default:
                print("failure")
            }
            
            
            
        }
        self.calendarView.reloadData()
    }
    
    
    func setDateTimeValues(tag:PickerType, value:String){
        
        switch tag {
        case PickerType.StartDate:
            print("")
            //self.startTimeDateLabel.text = value
            
        case PickerType.EndDate :
            print("")
           // self.endTimeDateLabel.text = value
        case PickerType.StartTime :
           self.startTimeLabel.text = value
        case PickerType.EndTime :
            self.endTimeLabel.text = value
        
        }
        
        if self.gatheringView != nil {
            self.setFirstDateSecondDate()
            //self.setUpdatedDate()
            
        }
        
        self.setMinMaxDate()
        self.calendarView.reloadData()
        
        if self.switchPredictive.isOn {
            self.getPreditveData()
        }
    }
    
    
    
    @IBAction func timePickerButtonPressed(_ sender: UIButton) {
        
        print("TimePicker TAG : \(sender.tag)");
        self.cellDelegate.timePick(cell: self, tag: sender.tag)
        
        switch sender.tag {
        case 0 :
            print("start date pressed")
            
        case 1 :
            print("end date pressed")
        case 2 :
            print("start Time Pressed")
        case 3:
            print("end time pressed")
        default:
            print("Nothing happend")
        }
        
    }
    
    func loadSummary(startTime:String,endTime : String){
        
        let startTimeinterval : TimeInterval = Double(startTime)! / 1000
        let startDate = NSDate(timeIntervalSince1970:startTimeinterval)
        minDate = startDate as Date
        let endTimeinterval : TimeInterval = Double(endTime)! / 1000
        let endDate = NSDate(timeIntervalSince1970:endTimeinterval)
        
        let dateformatter = DateFormatter()
        
        dateformatter.dateFormat = "MMMM dd"
        
        var dateString = dateformatter.string(from: startDate as Date)
        
        dateformatter.dateFormat = "h:mm a"
        
        dateString += " at "
        dateString += dateformatter.string(from: startDate as Date)
        
        self.startTimeLabel.text = dateformatter.string(from: startDate as Date)
        
        dateString += " to "
        dateString += dateformatter.string(from: endDate as Date)
        
        self.endTimeLabel.text = dateformatter.string(from: endDate as Date)
        self.thirdViewTimeLabel.text = dateString
        
        var suggestedTime = dateformatter.string(from: startDate as Date)
        
        suggestedTime += " to "
        suggestedTime += dateformatter.string(from: endDate as Date)
        
        dateformatter.dateFormat = "MMMM dd, yyyy"
        
        let suggestedDate = dateformatter.string(from: startDate as Date)
        
        self.suggestedDateLabel.text = suggestedDate
        self.suggestedTimeLabel.text = suggestedTime
        
        
//        if self.switchPredictive.isOn {
//
//            self.thirdViewONOFFLabel.text = "Predictive Calendar : ON"
//        }else{
//            self.thirdViewONOFFLabel.text = "Predictive Calendar : OFF"
//        }
        var datecomponent = DateComponents()
        datecomponent.year = 1
        let dateMax = Calendar.current.date(byAdding: datecomponent, to: Date())
         maxDate = dateMax
        calendarView.reloadData()
        self.calendarView.select(startDate as Date)
    }
    
}


    extension GatheringDateTableViewCell: FSCalendarDelegate , FSCalendarDelegateAppearance ,FSCalendarDataSource
    {
        
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            print("did select date \(self.dateFormatter.string(from: date))")
            let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
            print("selected dates is \(selectedDates)")
            
            
            
            self.setFourthCase()
            
            self.cellDelegate.setCase(caseHeight: .Fourth, cellIndex: self.cellIndex)
            
            self.gatheringView.selectedDate = calendar.selectedDates.map({$0}).first!
            self.setDateTimeValues(tag: .EndDate, value: "")
            
            
            /* Duni Code */
            /* self.gatheringView.startTime = "\((self.getSelectedFirstDate(first: true, dateFrom: self.gatheringView.selectedDate).millisecondsSince1970))"
            
            
            self.gatheringView.endTime = "\((self.getSelectedFirstDate(first: false, dateFrom: self.gatheringView.selectedDate).millisecondsSince1970))" */
            
            self.gatheringView.event.startTime = Int64("\((self.getSelectedFirstDate(first: true, dateFrom: self.gatheringView.selectedDate).millisecondsSince1970))")!;
            
            self.gatheringView.event.endTime = Int64("\((self.getSelectedFirstDate(first: false, dateFrom: self.gatheringView.selectedDate).millisecondsSince1970))")!;
            
            
            
            //Checking if end time is next day time, then get next day milli seconds.
            if (self.gatheringView.event.endTime <  self.gatheringView.event.startTime) {
                
                let dateTemp = Date(timeIntervalSince1970: (Double(self.gatheringView.event.endTime) / 1000.0))
                let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: dateTemp)
                self.gatheringView.event.endTime = Int64("\(tomorrow?.millisecondsSince1970 ?? Date().millisecondsSince1970)")!;
            }
            
            let dateformatter = DateFormatter()
            
            dateformatter.dateFormat = "MMMM dd"
            
            var dateString = dateformatter.string(from: calendar.selectedDates.map({$0}).first!)
            
            dateformatter.dateFormat = "h:mm a"
            
            dateString += " at "
            dateString += dateformatter.string(from: self.getFirstDateLastDate(first: true))
            dateString += " to "
            dateString += dateformatter.string(from: self.getFirstDateLastDate(first: false))
            self.thirdViewTimeLabel.text = dateString
            
            
            var suggestedTime = dateformatter.string(from: self.getFirstDateLastDate(first: true))
            
            suggestedTime += " to "
            suggestedTime += dateformatter.string(from: self.getFirstDateLastDate(first: false))
            
            dateformatter.dateFormat = "MMMM dd, yyyy"
            
            let suggestedDate = dateformatter.string(from: calendar.selectedDates.map({$0}).first!)
            
            self.suggestedDateLabel.text = suggestedDate
            self.suggestedTimeLabel.text = suggestedTime
            
            
            
            
            if monthPosition == .next || monthPosition == .previous {
                calendar.setCurrentPage(date, animated: true)
            }
            calendar.reloadData()
        }
        
        func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
            //self.calendarHeight.constant = bounds.height
            self.layoutIfNeeded()
        }
        
        
        func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
            calendar.reloadData()
            let currentmonth = NSCalendar.current.component(.month, from: calendar.currentPage)
            print(currentmonth)
            if self.switchPredictive.isOn {
            self.getPreditveData()
            }
        }
        
        
        
        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor fillDefaultColorForDate:Date)-> UIColor?  {
            
            
            if fillDefaultColorForDate < Date() {
                if Calendar.current.isDateInToday(fillDefaultColorForDate){
                   // return UIColor.clear
                }else{
                    return UIColor.clear
                }
                
            }
            let dateFormatter = DateFormatter()
            //.dateFormat = "h:mm a"
            dateFormatter.dateFormat = "yyyy/MM/dd"
            let dateKey = dateFormatter.string(from: fillDefaultColorForDate)
            
            if fillDefaultColors.allKeys .contains(where: { (dateKey) -> Bool in
                return true }) {
                return fillDefaultColors[dateKey] as? UIColor
                
            } else {
                if Calendar.current.isDateInToday(fillDefaultColorForDate){
                    return commonColor
                }
                return UIColor.clear
                
            }
            
            
            
            
//        dateFormatter.dateFormat = "MM"
//            
//            
//            
//        let dateMonth = Int(dateFormatter.string(from: fillDefaultColorForDate))
//            
//        let currentmonth = NSCalendar.current.component(.month, from: calendar.currentPage)
//            
//         if currentmonth == dateMonth {
//            dateFormatter.dateFormat = "yyyy/MM/dd"
//            let dateKey = dateFormatter.string(from: fillDefaultColorForDate)
//            
//            if fillDefaultColors.allKeys .contains(where: { (dateKey) -> Bool in
//                return true }) {
//                return fillDefaultColors[dateKey] as? UIColor
//                
//            } else {
//                
//                return UIColor.clear
//                
//            }
//            
//         }else{
//            return UIColor.clear
//        }
        
    }

        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor titleDefaultColorForDate:Date)-> UIColor?  {
            
            if titleDefaultColorForDate < Date() {
                if Calendar.current.isDateInToday(titleDefaultColorForDate){
                    // return UIColor.clear
                }else{
                    return UIColor.lightGray
                }
            }
            return UIColor.black
            
            
        }
        
        func maximumDate(for calendar: FSCalendar) -> Date {
            return self.maxDate
        }
        
        func minimumDate(for calendar: FSCalendar) -> Date {
            return self.minDate
        }
        
        
        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderRadiusFor date: Date) -> CGFloat {
            if Calendar.current.isDateInToday(date){
                return 1
            }else{
                return 0
            }
        }
}
