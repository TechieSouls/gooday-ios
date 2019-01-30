//
//  MeTimeViewController.swift
//  Cenes
//
//  Created by Ashutosh Tiwari on 8/24/17.
//  Copyright © 2017 Sabita Rani Samal. All rights reserved.
//

import UIKit
import NVActivityIndicatorView


protocol MeTimeViewControllerCellDelegate : class {
    func setTimeForStartEnd(label:Int,timeArray :[String])
    
}



class MeTimeViewController: UIViewController,MeTimeTableViewCellDelegate,NVActivityIndicatorViewable {
    
    @IBOutlet weak var separatorView : UIView!

    
    @IBOutlet weak var meTableView: UITableView!
    
    var dataArray = [NSMutableDictionary]()
    
    
    var baseView : BaseOnboardingViewController!
    
    
    @IBOutlet weak var tableOuterView: UIView!
    
    @IBOutlet weak var pickerOuterView: UIView!
    
    var TVCCellDelegate : MeTimeViewControllerCellDelegate!
    
    @IBOutlet weak var picker: UIDatePicker!
    var selectedLabel = 0
    var fromSideMenu = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        separatorView.layer.shadowOffset = CGSize(width: 0, height: -1)
        separatorView.layer.shadowRadius = 1;
        separatorView.layer.shadowOpacity = 0.5;
        separatorView.layer.masksToBounds = false
        
        meTableView.register(UINib(nibName: "MeTimeTableViewCell", bundle: nil), forCellReuseIdentifier: "MeTimeTableViewCell")
        meTableView.rowHeight = UITableViewAutomaticDimension
        meTableView.estimatedRowHeight = 194
        // Do any additional setup after loading the view.
        tableOuterView.layer.borderColor = UIColor.lightGray.cgColor
        pickerOuterView.isHidden = true
        picker.isHidden = true
        var dict1 = NSMutableDictionary()
        dict1 = ["title":"Bedtime","isSelected":false,"data":NSMutableDictionary()]
        var dict2 = NSMutableDictionary()
        dict2 = ["title":"Workout","isSelected":false,"data":NSMutableDictionary()]
        var dict3 = NSMutableDictionary()
        dict3 = ["title":"Family Time","isSelected":false,"data":NSMutableDictionary()]
        
        dataArray.append(dict1)
        dataArray.append(dict2)
        dataArray.append(dict3)
        
        if fromSideMenu {
            self.navigationItem.hidesBackButton = true
            let backButton = UIButton.init(type: .custom)
            backButton.setTitle("Cancel", for: UIControlState.normal)
            backButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
            backButton.layer.cornerRadius = backButton.frame.height/2
            backButton.clipsToBounds = true
            backButton.addTarget(self, action: #selector(backButtonPressed(_:)), for: .touchUpInside)
            
            let barButton = UIBarButtonItem.init(customView: backButton)
            self.navigationItem.leftBarButtonItem = barButton
            
            let nextButton = UIButton.init(type: .custom)
            
            nextButton.setTitle("Save", for: .normal)
            nextButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
            nextButton.layer.cornerRadius = nextButton.frame.height/2
            nextButton.clipsToBounds = true
            nextButton.addTarget(self, action: #selector(userDidSelectNext), for: .touchUpInside)
            let rightButton = UIBarButtonItem.init(customView: nextButton)
            
            self.navigationItem.rightBarButtonItem = rightButton
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.getStatus()
            }
            
            self.separatorView.isHidden = true
        }
        
        
    }
    
    
    
    func getStatus(){
        
        startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))
        
        WebService().meTimeStatus() { [weak self] (jsonDict) in
            self?.stopAnimating()
            print(jsonDict)
            
           let resultArray = jsonDict["data"] as? NSArray
            
            for val in resultArray! {
                
                let result = val as? [String:Any]
                
                let title = result?["title"] as? String
                
                //let day = result?["recurringPattersn"] as?  [String: Any]
                
                let recurringPatterns = result?["recurringPatterns"] as! NSArray
                
                let startTime = result?["startTime"] as? NSNumber
                var startTimeStr = ""
                if startTime != nil {
                    startTimeStr = "\(startTime!)"
                }else{
                    break
                }
                
                let endTime = result?["endTime"] as? NSNumber
                var endTimeStr = ""
                if endTime != nil {
                    endTimeStr = "\(endTime!)"
                }else{
                    break
                }
                
                
                
                if recurringPatterns.count > 0 {
                    
                    for record in recurringPatterns {
                        
                        var keyNumber = (record as! NSDictionary)["dayOfWeekTimestamp"]! as? Int
                        
                        let date = Date(milliseconds: keyNumber!)
                        
                        var components = Calendar.current.dateComponents(in: .current, from: date)
                        
                        keyNumber = components.weekday
                        
                        if keyNumber == nil {
                            break
                        }
                        let key = "\(keyNumber!)"
                        
                        if let dataDict = self?.dataArray.first(where: { $0["title"] as? String == title}){
                            print(dataDict)
                            let dict = dataDict.value(forKey: "data") as! NSMutableDictionary
                            dict[key] = self?.getStringFromTimeStamp(startTime: startTimeStr, endTime: endTimeStr)
                            dataDict["data"] = dict
                        }else{
                            var dict = NSMutableDictionary()
                            
                            let dictInner =  NSMutableDictionary()
                            dictInner[key] = self?.getStringFromTimeStamp(startTime: startTimeStr, endTime: endTimeStr)
                            
                            dict = ["title":title!,"isSelected":false,"data":dictInner]
                            self?.dataArray.append(dict)
                        }
                        
                    }
                    
                    
                    
                    
                }else{
                    break
                }
                
               
                
            }
            print((self?.dataArray)!)
            self?.meTableView.reloadData()
        }
    }
    
    func getStringFromTimeStamp(startTime: String,endTime : String) -> String {
        
        let startTimeinterval : TimeInterval = Double(startTime)! / 1000
        let startDate = NSDate(timeIntervalSince1970:startTimeinterval)
        let endTimeinterval : TimeInterval = Double(endTime)! / 1000
        let endDate = NSDate(timeIntervalSince1970:endTimeinterval)
        
        let dateFormatter = DateFormatter()
        let locale = NSLocale.current
        let formatter : String = DateFormatter.dateFormat(fromTemplate: "j", options:0, locale:locale)!
        if formatter.contains("a") {
            //phone is set to 12 hours
            dateFormatter.dateFormat = "h:mma"
        } else {
            //phone is set to 24 hours
            dateFormatter.dateFormat = "HH:mma"
        }
        
        
        var value = dateFormatter.string(from: startDate as Date)
        print(value)
        value += "/"
        value += dateFormatter.string(from: endDate as Date)
        
        return value
    }
    
    
    
    @objc func backButtonPressed(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction  func userDidSelectLater(sender:UIButton){
        let calendar = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "calendar") as? AddCalendarViewController
        self.navigationController?.pushViewController(calendar!, animated: true)
    }
    
    @IBAction  func userDidSelectNext(){
        
        
       // print(self.dataArray)
        
        
        var submitArray = [NSMutableDictionary]()
        
        for data in dataArray {
            
            if let values = data["data"]{
                let valuesDict = values as! NSMutableDictionary
                
                
                if valuesDict.allKeys.count > 0 {
                    
                    
                    for key in valuesDict.allKeys {
                        
                        let Weekday = Int(key as! String)!
                        
                        let dictSubmit = NSMutableDictionary()
                       
                        
                        switch Weekday {
                        case 1:
                            dictSubmit["day_of_week"] = "Sunday"
                        case 2:
                            dictSubmit["day_of_week"] = "Monday"
                        case 3:
                            dictSubmit["day_of_week"] = "Tuesday"
                        case 4:
                            dictSubmit["day_of_week"] = "Wednesday"
                        case 5:
                            dictSubmit["day_of_week"] = "Thursday"
                        case 6:
                            dictSubmit["day_of_week"] = "Friday"
                        case 7:
                            dictSubmit["day_of_week"] = "Saturday"
                        default:
                            print("Nothing")
                        }
                        
                        let locale = NSLocale.current
                        let formatter : String = DateFormatter.dateFormat(fromTemplate: "j", options:0, locale:locale)!
                        
                        var startTime = (valuesDict[key as! String] as! String).components(separatedBy: "/").first
                        var endTime =  (valuesDict[key as! String] as! String).components(separatedBy: "/").last
                        if formatter.contains("a") {
                            //phone is set to 12 hours
                        } else {
                            //phone is set to 24 hours
                            startTime = startTime?.replacingOccurrences(of: "AM", with: "").replacingOccurrences(of: "PM", with: "")
                            endTime = endTime?.replacingOccurrences(of: "AM", with: "").replacingOccurrences(of: "PM", with: "")
                        }
                        
                        
                        let dateFormatter = DateFormatter()
                        
                        let cDate = Date()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        
                        var startTimeString = dateFormatter.string(from: cDate)
                        var endTimeString = dateFormatter.string(from: cDate)
                        
                        let tempStartDate = dateFormatter.date(from: startTimeString)
                        let tempEndDate = dateFormatter.date(from: endTimeString)
                        
                        
                        if formatter.contains("a") {
                            //phone is set to 12 hours
                            dateFormatter.dateFormat = "yyyy-MM-dd h:mma"
                        } else {
                            //phone is set to 24 hours
                             dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                        }
                        
                        startTimeString += " \(startTime!)"
                        endTimeString += " \(endTime!)"
                        
                        let newStartDate = dateFormatter.date(from: startTimeString)
                        let newEndDate =  dateFormatter.date(from: endTimeString)
                        
                        
                        var components = Calendar.current.dateComponents(in: .current, from: newStartDate!)
                        
                        components.weekday = Weekday
                        
                        var newCom = DateComponents()
                        newCom.weekday = Weekday
                        newCom.minute = components.minute
                        newCom.hour = components.hour
                        
                        var components2 = Calendar.current.dateComponents(in: .current, from: newEndDate!)
                        
                        var newCom2 = DateComponents()
                        newCom2.weekday = Weekday
                        newCom2.minute = components2.minute
                        newCom2.hour = components2.hour
                        
                        
                        let sDate =  Calendar.current.nextDate(after: tempStartDate!, matching: newCom, matchingPolicy: .strict)
                        
                        
                        let eDate = Calendar.current.nextDate(after: tempEndDate!, matching: newCom2, matchingPolicy: .strict)
                        
                        
                        let startMilliseconds = sDate?.millisecondsSince1970
                        let endMilliseconds = eDate?.millisecondsSince1970
 
                        
                        let title = data["title"]
                        let discription = ""
                        
                        dictSubmit.setValue(title, forKey: "title")
                        dictSubmit.setValue("\(startMilliseconds!)", forKey: "start_time")
                        dictSubmit.setValue("\(endMilliseconds!)", forKey: "end_time")
                        dictSubmit.setValue(discription, forKey: "discription")
                        submitArray.append(dictSubmit)
                    }
                    
                    
                }
                
                
            }
            
            
        }
        
        print(submitArray)
        
            let webservice = WebService()
        
       
        
        if fromSideMenu == true {
            startAnimating(loadinIndicatorSize, message: "Loading...", type: NVActivityIndicatorType(rawValue: 15))
            webservice.meTime(submitArray: submitArray){ (success) in
                self.stopAnimating()
                if success == true {
                    self.navigationController?.popViewController(animated: true)
                }else{
                    self.showAlert(title: "Error", message: "Error updating Me time, Please try again.")
                }
            }

        }else{
            if submitArray.count > 0 {
                webservice.meTime(submitArray: submitArray){ (success) in

                }
            }
        }
        //let calendar = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "calendar") as? AddCalendarViewController
        //self.navigationController?.pushViewController(calendar!, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func addButtonTApped(indexpath: IndexPath) {
        print("button TApped")
        
        let dict = self.dataArray[indexpath.row]
        
        dict["isSelected"] = !((dict["isSelected"] as? Bool)!)
        
        self.dataArray[indexpath.row] = dict
        
        self.meTableView.beginUpdates()
        
        self.meTableView.endUpdates()
        
    }
    
    
    func showPickerView(cell:MeTimeTableViewCell,label: Int){
        self.showPicker(show: true)
        self.selectedLabel = label
        self.TVCCellDelegate = cell
    }
    
    
    func showPicker(show:Bool){
        if show{
            
            self.picker.setDate(Date(), animated: false)
            
            self.pickerOuterView.isHidden = false
            
                // your code here
                self.picker.isHidden = false
            
            if self.fromSideMenu == true {
                self.picker.isUserInteractionEnabled = true
            }else{
                self.baseView.bottomOuterView.isHidden = true
                self.picker.isUserInteractionEnabled = true
                self.baseView.pageViewController.dataSource = nil
            }
            
            
            }else{
            if self.fromSideMenu == true{
                self.picker.isHidden = true
                self.pickerOuterView.isHidden = true
            }else{
            self.pickerOuterView.isHidden = true
            self.picker.isHidden = true
            self.baseView.bottomOuterView.isHidden = false
            self.baseView.pageViewController.dataSource = self.baseView
            }
        }
    }
    
    
    
    @IBAction func pickerDoneButtonPressed(_ sender: Any) {
        
        var timeArray = [String]()
        let dateFormatter = DateFormatter()
        
        let locale = NSLocale.current
        let formatter : String = DateFormatter.dateFormat(fromTemplate: "j", options:0, locale:locale)!
        if formatter.contains("a") {
            //phone is set to 12 hours
            dateFormatter.dateFormat = "EEE, MMM dd, YYYY, h:mm a"
        } else {
            //phone is set to 24 hours
            dateFormatter.dateFormat = "EEE, MMM dd, YYYY, HH:mm a"
        }
        
        print(dateFormatter.string(from: self.picker.clampedDate))
        if formatter.contains("a") {
            //phone is set to 12 hours
            dateFormatter.dateFormat = "h"
        } else {
            //phone is set to 24 hours
            dateFormatter.dateFormat = "HH"
        }
        timeArray.insert(dateFormatter.string(from: self.picker.clampedDate), at: 0)
        dateFormatter.dateFormat = "mm"
        timeArray.insert(dateFormatter.string(from: self.picker.clampedDate), at: 1)
        dateFormatter.dateFormat = "a"
        timeArray.insert(dateFormatter.string(from: self.picker.clampedDate).capitalized, at: 2)
        
        
        print(timeArray)
        self.TVCCellDelegate.setTimeForStartEnd(label: self.selectedLabel, timeArray: timeArray)
        
        self.showPicker(show: false)
        
    }
    
    
    @IBAction func pickerCancelButtonPressed(_ sender: Any) {
       
        
        self.showPicker(show: false)
    }
    
    
    @IBAction func datePickerDidChange(_ sender: Any) {
        
        let datePicker = sender as! UIDatePicker
        
        
        let dateFormatter = DateFormatter()
        let locale = NSLocale.current
        let formatter : String = DateFormatter.dateFormat(fromTemplate: "j", options:0, locale:locale)!
        if formatter.contains("a") {
            //phone is set to 12 hours
            dateFormatter.dateFormat = "h:mm a"
        } else {
            //phone is set to 24 hours
            dateFormatter.dateFormat = "HH:mm a"
        }
        print(dateFormatter.string(from: datePicker.date))
        
    }
    
    
    @IBAction func addCategoryButtonPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "Add New Categoary", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            
            print("firstName \(firstTextField.text!)")
            
            if firstTextField.text == "" {
                self.showAlert(title: "Error", message: "Please enter category name")
            }else{
                        var dict = NSMutableDictionary()
                        dict = ["title":firstTextField.text!,"isSelected":false,"data":NSMutableDictionary()]
                        self.dataArray.append(dict)
                        self.meTableView.reloadData()
            }
            
            
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter new category"
        }
       
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)

        
    }
    
    
}





    extension MeTimeViewController :UITableViewDataSource,UITableViewDelegate
    {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.dataArray.count
        }
        
        
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            let isSelected = dataArray[indexPath.row]["isSelected"] as! Bool
            if isSelected == true {
                return 162
            }else{
               return 46
            }
        }
        
        
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            
            let identifier = "MeTimeTableViewCell"
            let cell: MeTimeTableViewCell = (tableView.dequeueReusableCell(withIdentifier: identifier) as? MeTimeTableViewCell)!
            
            cell.cellDict = dataArray[indexPath.row]
            
            cell.meCellDelegate = self
            cell.indexPathCell = indexPath
            
            
            let isSelected = dataArray[indexPath.row]["isSelected"] as! Bool
            
            cell.cellTabbed = isSelected
            
            if isSelected == true {
                cell.lowerView.isHidden = false
                cell.expandButton.isSelected = true
            }else{
                cell.lowerView.isHidden = true
                cell.expandButton.isSelected = false
                
            }
            
            cell.titleLabel.text = dataArray[indexPath.row]["title"] as? String
            
            let dataDict = dataArray[indexPath.row]["data"] as! NSMutableDictionary
            cell.selectedWeekdaysDict = dataDict
            cell.setDataFromDictionary(dict: dataDict)
            
            return cell
        }
        
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
    }
