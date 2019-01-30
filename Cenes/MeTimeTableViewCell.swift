//
//  MeTimeTableViewCell.swift
//  Cenes
//
//  Created by Redblink on 07/09/17.
//  Copyright © 2017 Sabita Rani Samal. All rights reserved.
//

import UIKit
import IoniconsSwift

protocol MeTimeTableViewCellDelegate : class {
    func addButtonTApped(indexpath:IndexPath)
    func showPickerView(cell:MeTimeTableViewCell ,label:Int)
}



class MeTimeTableViewCell: UITableViewCell ,MeTimeViewControllerCellDelegate{
    
    enum Weekdays : Int {
        case Sunday         = 0
        case Monday         = 1
        case Tuesday        = 2
        case Wednesday      = 3
        case Thrusday       = 4
        case Friday         = 5
        case Saturday       = 6
    }
    
    @IBOutlet weak var buttonStackView: UIStackView!
    
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var expandButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var lowerView: UIView!
    @IBOutlet weak var outerViewFirst: UIView!
    
    var meCellDelegate : MeTimeTableViewCellDelegate!
    var indexPathCell : IndexPath!
    var cellTabbed = false
    var cellDict : NSMutableDictionary!
    var  selectedWeekdaysDict : NSMutableDictionary!
    
    @IBOutlet weak var OuterViewFirstHourLabel: UILabel!
    
    @IBOutlet weak var OuterViewFirstMinuteLabel: UILabel!
    
    
    @IBOutlet weak var OuterViewFirstAMPMToggleButton: UIButton!
    
    @IBOutlet weak var outerViewSecond: UIView!
    
    
    @IBOutlet weak var OuterViewSecondHourLabel: UILabel!
    
    
    @IBOutlet weak var OuterViewSecondMinuteLabel: UILabel!
    
    @IBOutlet weak var OuterViewSecondAMPMToggleButton: UIButton!
    
    @IBOutlet weak var sundayButton: UIButton!
    
    @IBOutlet weak var mondayButton: UIButton!
    
    @IBOutlet weak var TuesdayButton: UIButton!
    
    
    @IBOutlet weak var wednesDayButton: UIButton!
    
    @IBOutlet weak var thrusdayButton: UIButton!
    
    @IBOutlet weak var fridayButton: UIButton!
    
    
    @IBOutlet weak var saturdayButton: UIButton!
    
    override func prepareForReuse() {
        
        
        
//        if self.cellTabbed == true {
//            self.lowerView.isHidden = false
//            self.expandButton.isSelected = true
//        }else{
//            self.lowerView.isHidden = true
//            self.expandButton.isSelected = false
//        }
    }
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        expandButton.setImage(Ionicons.minusCircled.image(45, color: UIColor.red), for: .selected)
        expandButton.setImage(Ionicons.androidAddCircle.image(45, color: UIColor.black), for: .normal)
        outerViewFirst.layer.borderColor = UIColor.lightGray.cgColor
        outerViewSecond.layer.borderColor = UIColor.lightGray.cgColor
        OuterViewFirstAMPMToggleButton.layer.borderColor = UIColor.lightGray.cgColor
        OuterViewSecondAMPMToggleButton.layer.borderColor = UIColor.lightGray.cgColor
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(self.outerFirstPressed(_:)))
        self.outerViewFirst.isUserInteractionEnabled = true
        self.outerViewFirst.addGestureRecognizer(tapGesture1)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(self.outerSecondPressed(_:)))
        self.outerViewSecond.isUserInteractionEnabled = true
        self.outerViewSecond.addGestureRecognizer(tapGesture2)
        
        let dateFormatter = DateFormatter()
        let locale = NSLocale.current
        let formatter : String = DateFormatter.dateFormat(fromTemplate: "j", options:0, locale:locale)!
        if formatter.contains("a") {            //phone is set to 12 hours
            dateFormatter.dateFormat = "h"
            OuterViewFirstHourLabel.text = dateFormatter.string(from: Date())
            dateFormatter.dateFormat = "mm"
            OuterViewFirstMinuteLabel.text = dateFormatter.string(from: Date())
            dateFormatter.dateFormat = "a"
            OuterViewFirstAMPMToggleButton.setTitle(dateFormatter.string(from: Date()), for: .normal)
            
            dateFormatter.dateFormat = "h"
            OuterViewSecondHourLabel.text = dateFormatter.string(from: Date())
            dateFormatter.dateFormat = "mm"
            OuterViewSecondMinuteLabel.text = dateFormatter.string(from: Date())
            dateFormatter.dateFormat = "a"
            OuterViewSecondAMPMToggleButton.setTitle(dateFormatter.string(from: Date()), for: .normal)
        } else {
            //phone is set to 24 hours
            dateFormatter.dateFormat = "HH"
            OuterViewFirstHourLabel.text = dateFormatter.string(from: Date())
            dateFormatter.dateFormat = "mm"
            OuterViewFirstMinuteLabel.text = dateFormatter.string(from: Date())
            dateFormatter.dateFormat = "a"
            OuterViewFirstAMPMToggleButton.setTitle(dateFormatter.string(from: Date()), for: .normal)
            
            dateFormatter.dateFormat = "HH"
            print(" Second date : \(dateFormatter.string(from: Date()))")
            OuterViewSecondHourLabel.text = dateFormatter.string(from: Date())
            dateFormatter.dateFormat = "mm"
            OuterViewSecondMinuteLabel.text = dateFormatter.string(from: Date())
            dateFormatter.dateFormat = "a"
            OuterViewSecondAMPMToggleButton.setTitle(dateFormatter.string(from: Date()), for: .normal)
        }
        
    }
    
    
    @IBAction func toggleButtonFirstPressed(_ sender: UIButton) {
        print("first pressed")
        sender.isSelected = !sender.isSelected
        
        let status = sender.isSelected
        
        print(status)
        
        if status {
            sender.setTitle("PM", for: .normal)
        }else{
            sender.setTitle("AM", for: .normal)
        }
        self.setWeekDaysValues()
    }
    
    
    @IBAction func toggleButtonSecondPressed(_ sender: UIButton) {
        print("Second pressed")
        sender.isSelected = !sender.isSelected
        
        let status = sender.isSelected
        
        print(status)
        
        if status {
            sender.setTitle("PM", for: .normal)
        }else{
            sender.setTitle("AM", for: .normal)
        }
        self.setWeekDaysValues()
    }
    
    
    
    @IBAction func outerFirstPressed(_ sender: Any) {
        print("Outer first Pressed")
        meCellDelegate.showPickerView(cell: self,label: 0)
    }
    
    @IBAction func outerSecondPressed(_ sender: Any) {
        print("Outer Second Pressed")
        meCellDelegate.showPickerView(cell: self,label: 1)
    }
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        
        
        
        sender.isSelected = !sender.isSelected
        
        self.cellTabbed = !cellTabbed
        
        
//        UIView.animate(withDuration: 0.3, animations: {
        
            self.lowerView.isHidden  = !self.lowerView.isHidden
            
//        }) { (true) in
//
//        }
        
        meCellDelegate.addButtonTApped(indexpath: self.indexPathCell)
        
        
        
    }
    
    @IBAction func WeekdayButtonPressed(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        let status = sender.isSelected
        
        print(status)
        
        
        let key = "\(sender.tag)"
        if status {
        
            self.ChangeButtonBackground(button: sender, status: true)
            selectedWeekdaysDict.setValue(self.getStartEndTime(), forKey: key)
        }else{
            
            self.ChangeButtonBackground(button: sender, status: false)
            selectedWeekdaysDict.removeObject(forKey: key)
        }
        
        print(selectedWeekdaysDict)
        
    }
    
    func ChangeButtonBackground(button:UIButton , status : Bool){
        if status {
            button.isSelected = true
            button.layer.borderColor = UIColor.darkGray.cgColor
            button.layer.borderWidth = 0.0
            button.backgroundColor = commonColor
        }else{
            button.isSelected = false
            button.layer.borderColor = UIColor.darkGray.cgColor
            button.layer.borderWidth = 0.7
            button.backgroundColor = UIColor.clear
        }
    }
    
    
    
    func setWeekDaysValues(){
        for key in selectedWeekdaysDict.allKeys {
            selectedWeekdaysDict.setValue(self.getStartEndTime(), forKey: key as! String)
        }
    }
    
    
    func setTimeForStartEnd(label:Int,timeArray :[String]){
        if label == 0 {
            OuterViewFirstHourLabel.text = timeArray[0]
            OuterViewFirstMinuteLabel.text = timeArray[1]
            OuterViewFirstAMPMToggleButton.setTitle(timeArray[2].uppercased(), for: .normal)
            self.setWeekDaysValues()
        }else{
            OuterViewSecondHourLabel.text = timeArray[0];
            OuterViewSecondMinuteLabel.text = timeArray[1]
            OuterViewSecondAMPMToggleButton.setTitle(timeArray[2].uppercased(), for: .normal)
            self.setWeekDaysValues()
        }
    }
    
    func getStartEndTime()-> String {
        
        var returnStr = ""
       returnStr = returnStr+OuterViewFirstHourLabel.text!+":"+OuterViewFirstMinuteLabel.text!+(OuterViewFirstAMPMToggleButton.titleLabel?.text?.uppercased())!
       returnStr = returnStr+"/"+OuterViewSecondHourLabel.text!+":"+OuterViewSecondMinuteLabel.text!+(OuterViewSecondAMPMToggleButton.titleLabel?.text?.uppercased())!
        
        print(returnStr)
        return returnStr
    }
    
    func setDataFromDictionary(dict:NSMutableDictionary){
        
        self.ChangeButtonBackground(button: self.sundayButton, status: false)
        self.ChangeButtonBackground(button: self.mondayButton, status: false)
        self.ChangeButtonBackground(button: self.TuesdayButton, status: false)
        self.ChangeButtonBackground(button: self.wednesDayButton, status: false)
        self.ChangeButtonBackground(button: self.thrusdayButton, status: false)
        self.ChangeButtonBackground(button: self.fridayButton, status: false)
        self.ChangeButtonBackground(button: self.saturdayButton, status: false)
        
        
        
        if dict.allKeys.count > 0 {
            let timeString = dict.value(forKey: dict.allKeys.first as! String) as! String
            
            let firstTimeString = timeString.components(separatedBy: "/").first
            let secondTimeString = timeString.components(separatedBy: "/").last
            
            self.setTimeForStartEnd(label: 0, timeArray:self.parseTimeString(strTime: firstTimeString!))
            self.setTimeForStartEnd(label: 1, timeArray:self.parseTimeString(strTime: secondTimeString!))
            
        }
        
        
        for key in dict.allKeys{
            
            let intKey = Int(key as! String)
            
            switch intKey! {
            case 1:
               self.ChangeButtonBackground(button: self.sundayButton, status: true)
            case 2:
                self.ChangeButtonBackground(button: self.mondayButton, status: true)
            case 3:
                self.ChangeButtonBackground(button: self.TuesdayButton, status: true)
            case 4:
                self.ChangeButtonBackground(button: self.wednesDayButton, status: true)
            case 5:
                self.ChangeButtonBackground(button: self.thrusdayButton, status: true)
            case 6:
                self.ChangeButtonBackground(button: self.fridayButton, status: true)
            case 7:
                self.ChangeButtonBackground(button: self.saturdayButton, status: true)
                
            default:
                print("All done")
            }
        }
        
        if self.cellTabbed == true {
            self.lowerView.isHidden = false
        }else{
            self.lowerView.isHidden = true
        }
 
    }
    
    func parseTimeString(strTime:String) -> [String]{
        
        let first = strTime.components(separatedBy: ":").first
        
        let last = strTime.components(separatedBy: ":").last
        
        let index = last?.index((last?.startIndex)!, offsetBy: 2)
        let second =   last?.substring(to: index!)
        let third =   last?.substring(from: index!)
        
        let returnArray = [first!,second!,third!]
        print(returnArray)
        return returnArray
    }
    
}
