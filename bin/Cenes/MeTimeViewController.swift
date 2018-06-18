//
//  MeTimeViewController.swift
//  Cenes
//
//  Created by Ashutosh Tiwari on 8/24/17.
//  Copyright © 2017 Sabita Rani Samal. All rights reserved.
//

import UIKit


protocol MeTimeViewControllerCellDelegate : class {
    func setTimeForStartEnd(label:Int,timeArray :[String])
    
}



class MeTimeViewController: UIViewController,MeTimeTableViewCellDelegate {
    
    @IBOutlet weak var separatorView : UIView!

    
    @IBOutlet weak var meTableView: UITableView!
    
    var dataArray = [NSMutableDictionary]()
    
    
    var baseView : BaseOnboardingViewController!
    
    
    @IBOutlet weak var tableOuterView: UIView!
    
    @IBOutlet weak var pickerOuterView: UIView!
    
    var TVCCellDelegate : MeTimeViewControllerCellDelegate!
    
    @IBOutlet weak var picker: UIDatePicker!
    var selectedLabel = 0
    
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
                        case 0:
                            dictSubmit["day_of_week"] = "Sunday"
                        case 1:
                            dictSubmit["day_of_week"] = "Monday"
                        case 2:
                            dictSubmit["day_of_week"] = "Tuesday"
                        case 3:
                            dictSubmit["day_of_week"] = "Wednesday"
                        case 4:
                            dictSubmit["day_of_week"] = "Thrusday"
                        case 5:
                            dictSubmit["day_of_week"] = "Friday"
                        case 6:
                            dictSubmit["day_of_week"] = "Saturday"
                        default:
                            print("Nothing")
                        }
                        
                        
                        let startTime = (valuesDict[key as! String] as! String).components(separatedBy: "/").first
                        let endTime =  (valuesDict[key as! String] as! String).components(separatedBy: "/").last
                        
                        let title = data["title"]
                        let discription = ""
                        
                        dictSubmit.setValue(title, forKey: "title")
                        dictSubmit.setValue(startTime, forKey: "start_time")
                        dictSubmit.setValue(endTime, forKey: "end_time")
                        dictSubmit.setValue(discription, forKey: "discription")
                        submitArray.append(dictSubmit)
                    }
                    
                    
                }
                
                
            }
            
            
        }
        
        print(submitArray)
        
            let webservice = WebService()
        
        if submitArray.count > 0 {
        webservice.meTime(submitArray: submitArray)
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
        
        self.meTableView.scrollToRow(at: indexpath, at: .top, animated: true)
        
        
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
            self.baseView.bottomOuterView.isHidden = true
            self.picker.isUserInteractionEnabled = true
            self.baseView.pageViewController.dataSource = nil
            }else{
            self.pickerOuterView.isHidden = true
            self.picker.isHidden = true
            self.baseView.bottomOuterView.isHidden = false
            self.baseView.pageViewController.dataSource = self.baseView
        }
    }
    
    
    
    @IBAction func pickerDoneButtonPressed(_ sender: Any) {
        
        var timeArray = [String]()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "EEE, MMM dd, YYYY, h:mm a"
        print(dateFormatter.string(from: self.picker.clampedDate))
        
        
        dateFormatter.dateFormat = "h"
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
        dateFormatter.dateFormat = "h:mm a"
        
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


extension Date {
    public var clampedDate: Date {
        let referenceTimeInterval = self.timeIntervalSinceReferenceDate
        let remainingSeconds = referenceTimeInterval.truncatingRemainder(dividingBy: TimeInterval(15*60))
        let timeRoundedToInterval = referenceTimeInterval - remainingSeconds
        return Date(timeIntervalSinceReferenceDate: timeRoundedToInterval)
    }
}

extension UIDatePicker {
    /// Returns the date that reflects the displayed date clamped to the `minuteInterval` of the picker.
    /// - note: Adapted from [ima747's](http://stackoverflow.com/users/463183/ima747) answer on [Stack Overflow](http://stackoverflow.com/questions/7504060/uidatepicker-with-15m-interval-but-always-exact-time-as-return-value/42263214#42263214})
    public var clampedDate: Date {
        let referenceTimeInterval = self.date.timeIntervalSinceReferenceDate
        let remainingSeconds = referenceTimeInterval.truncatingRemainder(dividingBy: TimeInterval(minuteInterval*60))
        let timeRoundedToInterval = referenceTimeInterval - remainingSeconds
        return Date(timeIntervalSinceReferenceDate: timeRoundedToInterval)
    }
}
