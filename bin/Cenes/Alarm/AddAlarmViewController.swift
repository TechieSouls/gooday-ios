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
    
    var selectedRow = 0
    var alarmInfo: [(header: String, info: String)] = [("Repeat","M T W T F"), ("Label", "Alarm"), ("Sound","Bells")]
  
    var isEditMode = false
    var selectedAlarm: Alarm! = nil
    var alarmVCtitle: String? = nil
    
    internal var managedObjectContext: NSManagedObjectContext!
    internal var autoIncrementID: Int!
    
    let timesOfTheDay = [["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"], [":"],["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59", "60"]]    // Array for holding the times
    
    var selectedHour: String = "00"   // Initial Hour chosen
    var selectedMin: String = "01"    // Initial Mins chosen
    
    @IBAction func cancelAddingAlarm(_ sender: Any) {
        if isEditMode {
            self.navigationController?.popViewController(animated: true)
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func addSelectedAlarm(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = NSTimeZone.local
        let date = dateFormatter.date(from: String.init(format: "%@:%@", selectedHour,selectedMin))

        if isEditMode {
            
            selectedAlarm.setValue(alarmInfo[0].info, forKey: "weekdaysName")
            selectedAlarm.setValue(alarmInfo[2].info, forKey: "sound")
            selectedAlarm.setValue(alarmInfo[1].info, forKey: "alarmName")
            selectedAlarm.setValue(date, forKey: "alarmTime")
            
            do {
                try self.managedObjectContext.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }

            self.navigationController?.popViewController(animated: true)
        }
        else {
            
            let newAlarm = NSEntityDescription.entity(forEntityName: "Alarm", in: self.managedObjectContext)
            
            let managedObject = NSManagedObject.init(entity: newAlarm!, insertInto: self.managedObjectContext)
            
            managedObject.setValue(self.autoIncrementID, forKey: "alarmID")
            managedObject.setValue(alarmInfo[0].info, forKey: "weekdaysName")
            managedObject.setValue(alarmInfo[2].info, forKey: "sound")
            managedObject.setValue(alarmInfo[1].info, forKey: "alarmName")
            managedObject.setValue(date, forKey: "alarmTime")
            managedObject.setValue(true, forKey: "enabled")
            
            do {
                try self.managedObjectContext.save()
                Scheduler().setNotificationWithDate(date!, weekdays: [1,2,3,4,5,6,7], sound: "", alarmName: alarmInfo[1].info, identifier: String(self.autoIncrementID))
            } catch {
                fatalError("Failure to save context: \(error)")
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = alarmVCtitle
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white

        let gradient = CAGradientLayer()
        gradient.frame = (self.navigationController?.navigationBar.bounds)!
        gradient.colors = [UIColor(red: 244/255, green: 106/255, blue: 88/255, alpha: 1).cgColor,UIColor(red: 249/255, green: 153/255, blue: 44/255, alpha: 1).cgColor]
        gradient.locations = [1.0,0.3]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.navigationController?.navigationBar.setBackgroundImage(cenesDelegate.creatGradientImage(layer: gradient), for: .default)
        
        if isEditMode {
            if let alarmTime = selectedAlarm.value(forKey: "alarmTime") as? Date {
                let alarm = Util.getAlarmStringFrom(date: alarmTime)
                let alarmComponents = alarm.components(separatedBy: ":")
                selectedHour = alarmComponents[0]
                selectedMin = alarmComponents[1]
                
                let hours: [String] = timesOfTheDay[0]
                let minutes: [String] = timesOfTheDay[2]
                
                pickerView.selectRow(hours.index(of: selectedHour)!, inComponent: 0, animated: true)
                pickerView.selectRow(minutes.index(of: selectedMin)!, inComponent: 2, animated: true)
                
                alarmInfo = [("Repeat", selectedAlarm.weekdaysName!), ("Label", selectedAlarm.alarmName!), ("Sound",selectedAlarm.sound!)]
            }
        }
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
            alarmInfoVC?.selectedDays = [1,2,3,4,5]
            alarmInfoVC?.selectedSound = "Alarm"
            
            if let cell = sender as? AlarmDetailTableViewCell {
                let indexPath = self.alarmInfoTableView!.indexPath(for: cell)
                selectedRow = (indexPath?.row)!
            }

            if selectedRow == 0 {
                alarmInfoVC?.infoMode = .repeatMode
                alarmInfoVC?.navTitle = "Repeat"
            }
            else if selectedRow == 1 {
                alarmInfoVC?.infoMode = .alarmLabelMode
                alarmInfoVC?.navTitle = "Label"
            }
            else {
                alarmInfoVC?.infoMode = .soundMode
                alarmInfoVC?.navTitle = "Sound"
            }
        }
    }
}

extension AddAlarmViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "AlarmInfo", for: indexPath) as? AlarmDetailTableViewCell
        cell?.accessoryType = .disclosureIndicator
        
        cell?.createViews()
        cell?.createConstraints()
        
        let alarmData = alarmInfo[indexPath.row]
        cell?.headerLabel.text = alarmData.header
        cell?.infoLabel.text = alarmData.info

        cell?.headerLabel.font = UIFont.init(name: "Lato-Regular", size: 15)
        cell?.infoLabel.font = UIFont.init(name: "Lato-Regular", size: 15)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect(x: 0 , y: 0, width: UIScreen.main.bounds.size.width, height: 1))
        view.backgroundColor = UIColor.clear
        return view
    }
}

extension AddAlarmViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension AddAlarmViewController: AlarmInfoUpdate {
    func updateSelectedAlarmInfo(info: String) {
        if selectedRow == 0 {
            alarmInfo[0].info = info
        }
        else if selectedRow == 1 {
            alarmInfo[1].info = info
        }
        else {
            alarmInfo[2].info = info
        }
        self.alarmInfoTableView.reloadData()
    }
}

extension AddAlarmViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timesOfTheDay[component].count   // Number of rows = timsOftheDay Array (Scroll)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return timesOfTheDay[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if component == 0 || component == 2 {
            return 120
        }
        else {
            return 20
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 95
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        let data = timesOfTheDay[component][row]
        let string =  NSAttributedString(string: data, attributes: [NSAttributedStringKey.font:UIFont(name: "Lato-Regular", size: 90)!, NSAttributedStringKey.foregroundColor:Util.colorWithHexString(hexString: "004346")])
        pickerLabel.attributedText = string
        pickerLabel.textAlignment = .center
        
        let labelSelected = pickerView.view(forRow: row, forComponent: component) as? UILabel
        labelSelected?.textColor = Util.colorWithHexString(hexString: "F9992C")
        
        return pickerLabel
    }
}

extension AddAlarmViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {      // If the Hours in  timePicker are changed
        case 0:
            selectedHour = timesOfTheDay[component][row]
        case 2:
            selectedMin = timesOfTheDay[component][row]
        default:
            break
        }
    }

}
