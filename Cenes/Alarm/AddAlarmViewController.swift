//
//  AddAlarmViewController.swift
//  Cenes
//
//  Created by Chinna Addepally on 10/18/17.
//  Copyright © 2017 Redblink Pvt Ltd. All rights reserved.
//

import UIKit
import CoreData

class AddAlarmViewController: UIViewController {
    @IBOutlet weak var alarmInfoTableView: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var deleteAlarmButton: UIButton!
    
    var selectedRow = 0
//    var alarmInfo: [(header: String, info: String)] = [("Repeat","M T W T F"), ("Label", "Alarm"), ("Sound","Bells")]
    var alarmInfo: [(header: String, info: String)] = [("Repeat","M T W T F"), ("Label", "Alarm")]
    var selectedDays: [Int] = [2,3,4,5,6]
  
    var isEditMode = false
    var selectedAlarm: Alarm! = nil
    var alarmVCtitle: String? = nil

    internal var managedObjectContext: NSManagedObjectContext!
    internal var autoIncrementID: Int!
    
    let timesOfTheDay = [["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"], [":"],["00","01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59"]]    // Array for holding the times
    
    var selectedHour: String = "00"   // Initial Hour chosen
    var selectedMin: String = "01"    // Initial Mins chosen
    
    
    //MARK: - Configure UI
    func configureUI() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        let gradient = CAGradientLayer()
        gradient.frame = (self.navigationController?.navigationBar.bounds)!
        gradient.colors = [UIColor(red: 244/255, green: 106/255, blue: 88/255, alpha: 1).cgColor,UIColor(red: 249/255, green: 153/255, blue: 44/255, alpha: 1).cgColor]
        gradient.locations = [1.0,0.3]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.navigationController?.navigationBar.setBackgroundImage(cenesDelegate.creatGradientImage(layer: gradient), for: .default)
        
        self.deleteAlarmButton.layer.borderWidth = 1
        self.deleteAlarmButton.layer.borderColor = UIColor.lightGray.cgColor
        
        if isEditMode {
            self.deleteAlarmButton.isHidden = false
        }
        else {
            self.deleteAlarmButton.isHidden = true
        }
    }
    
    func getCurrentTime() {
        let currentDate = Date()
        
        let calendar = Calendar(identifier: .gregorian)
        
        let currentDateComponents = calendar.dateComponents(in: .current, from: currentDate)
        
        var currentHourString = String(describing: currentDateComponents.hour!)
        var currentMinuteString = String(describing: currentDateComponents.minute!)
        
        if currentDateComponents.minute! < 10 {
            currentMinuteString = String(format:"%@%d","0",currentDateComponents.minute!)
        }
        
        if currentDateComponents.hour! < 10 {
            currentHourString = String(format:"%@%d","0",currentDateComponents.hour!)
        }
        
        selectedHour = currentHourString
        selectedMin = currentMinuteString
        print("Current Hour\(currentHourString) \(currentMinuteString)")
        
        let hours: [String] = timesOfTheDay[0]
        let minutes: [String] = timesOfTheDay[2]
        
        pickerView.selectRow(hours.index(of: selectedHour)!, inComponent: 0, animated: true)
        pickerView.selectRow(minutes.index(of: selectedMin)!, inComponent: 2, animated: true)
    }

    
    //MARK: - Button Actions
    @IBAction func cancelAddingAlarm(_ sender: Any) {
        if isEditMode {
            self.navigationController?.popViewController(animated: true)
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func deleteAlarm(_ sender: Any) {
        deleteAlarm()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addSelectedAlarm(_ sender: Any) {
        if isEditMode {
            editAlarm()
            self.navigationController?.popViewController(animated: true)
        }
        else {
            addAlarm()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = alarmVCtitle
        
        configureUI()
        
        getCurrentTime()
        
        if isEditMode {
            if let alarmTime = selectedAlarm.value(forKey: "alarmTime") as? Date {
                let alarm = Util.getAlarmStringFrom(date: alarmTime)
                let alarmComponents = alarm.components(separatedBy: ":")
                selectedHour = alarmComponents[0]
                selectedMin = alarmComponents[1]
                
                let hours: [String] = timesOfTheDay[0]
                let minutes: [String] = timesOfTheDay[2]
                
                selectedDays = selectedAlarm.weekdays!
                
                pickerView.selectRow(hours.index(of: selectedHour)!, inComponent: 0, animated: true)
                pickerView.selectRow(minutes.index(of: selectedMin)!, inComponent: 2, animated: true)
                
//                alarmInfo = [("Repeat", selectedAlarm.weekdaysName!), ("Label", selectedAlarm.alarmName!), ("Sound",selectedAlarm.sound!)]
                alarmInfo = [("Repeat", selectedAlarm.weekdaysName!), ("Label", selectedAlarm.alarmName!)]

            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "alarmInfo" {
            let alarmInfoVC = segue.destination as? AlarmInfoViewController
            alarmInfoVC?.delegate = self
            
            guard let cell = sender as? AlarmDetailTableViewCell else {
                return
            }
            
            let indexPath = self.alarmInfoTableView!.indexPath(for: cell)
            selectedRow = (indexPath?.row)!

            if selectedRow == 0 {
                alarmInfoVC?.infoMode = .repeatMode
                alarmInfoVC?.navTitle = "Repeat"
                if isEditMode {
                    alarmInfoVC?.selectedDays = selectedDays
                }
                else {
                    alarmInfoVC?.selectedDays = [2,3,4,5,6] //Default Select Weekdays
                }
            }
            else if selectedRow == 1 {
                alarmInfoVC?.infoMode = .alarmLabelMode
                alarmInfoVC?.navTitle = "Label"
            }
            else {
                alarmInfoVC?.infoMode = .soundMode
                alarmInfoVC?.navTitle = "Sound"
                alarmInfoVC?.selectedSound = "Alarm"
            }
        }
    }
}

extension AddAlarmViewController: AlarmInfoUpdate {
    func updateSelectedAlarmInfo(info: String, weekdays: [Int]) {
        if selectedRow == 0 {
            alarmInfo[0].info = info
        }
        else if selectedRow == 1 {
            alarmInfo[1].info = info
        }
//        else {
//            alarmInfo[2].info = info
//        }
        
        selectedDays = weekdays
        self.alarmInfoTableView.reloadData()
    }
}
