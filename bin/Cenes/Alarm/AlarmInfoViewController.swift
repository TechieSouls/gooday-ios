//
//  AlarmInfoViewController.swift
//  Cenes
//
//  Created by Chinna Addepally on 10/19/17.
//  Copyright © 2017 Redblink Pvt Ltd. All rights reserved.
//

import UIKit

protocol AlarmInfoUpdate {
    func updateSelectedAlarmInfo(info: String)
}

class AlarmInfoViewController: UIViewController {

    var delegate: AlarmInfoUpdate? = nil
    
    @IBOutlet weak var alarmLabelTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var seperator: UIView!
    @IBOutlet weak var tableViewSeperator: UIView!
    
    var navTitle: String?
    
    enum AlarmInfo: Int {
        case repeatMode = 0
        case alarmLabelMode
        case soundMode
    }
    
    var infoMode = AlarmInfo.repeatMode
    var sounds: [String] = ["Radar", "Apex", "Bells", "Chimes", "Opening", "Signal", "Twinkle"]
    var days: [Int]! = [1,2,3,4,5,6,7]
    var selectedDays: [Int]! = []
    var selectedSound = ""
    
    func switchToSelectedMode() {
        switch infoMode {
        case .repeatMode, .soundMode:
            alarmLabelTextField.isHidden = true
            tableView.isHidden = false
            seperator.isHidden = false
            break
        case .alarmLabelMode:
            alarmLabelTextField.isHidden = false
            tableView.isHidden = true
            seperator.isHidden = true
            break
        }
    }
    
    @IBAction func saveAlarmInfo(_ sender: Any) {
        var savedInfo = ""
        switch infoMode {
        case .repeatMode:
            savedInfo = Util.getTotalWeekdays(weekdays: selectedDays)
            break
        case .soundMode:
            savedInfo = selectedSound
            break
        case .alarmLabelMode:
            savedInfo = alarmLabelTextField.text!
            break
        }
        self.delegate?.updateSelectedAlarmInfo(info: savedInfo)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = navTitle
        
        alarmLabelTextField.addPaddingToTextField()
        alarmLabelTextField.createBorderedTextField()
        alarmLabelTextField.layer.borderColor = Util.colorWithHexString(hexString: lightGreyColor).cgColor
        alarmLabelTextField.clearsOnBeginEditing = true
        alarmLabelTextField.font = UIFont.init(name: "Lato-Regular", size: 15)
        alarmLabelTextField.text = selectedSound

        tableViewSeperator.backgroundColor = Util.colorWithHexString(hexString: lightGreyColor)
        switchToSelectedMode()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension AlarmInfoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if infoMode == .repeatMode {
            return days.count
        }
        else if infoMode == .soundMode {
            return sounds.count
        }
        return 7
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "AlarmInfo", for: indexPath)
        cell.tintColor = UIColor.black
        
        cell.textLabel?.font = UIFont.init(name: "Lato-Regular", size: 15)

        if infoMode == .repeatMode {
            let day = days[indexPath.row]
            switch day {
            case 1:
                cell.textLabel?.text = "Every Sunday"
                break
            case 2:
                cell.textLabel?.text = "Every Monday"
                break
            case 3:
                cell.textLabel?.text = "Every Tuesday"
                break
            case 4:
                cell.textLabel?.text = "Every Wednesday"
                break
            case 5:
                cell.textLabel?.text = "Every Thursday"
                break
            case 6:
                cell.textLabel?.text = "Every Friday"
                break
            case 7:
                cell.textLabel?.text = "Every Saturday"
                break
            default:
                print("No Day")
            }

            if selectedDays.contains(day) {
                cell.accessoryType = .checkmark
            }
            else {
                cell.accessoryType = .none
            }
        }
        else if infoMode == .soundMode {
            let sound = sounds[indexPath.row]
            cell.textLabel?.text = sound
            if selectedSound == sound {
                cell.accessoryType = .checkmark
            }
            else {
                cell.accessoryType = .none
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect(x: 0 , y: 0, width: UIScreen.main.bounds.size.width, height: 0.5))
        view.backgroundColor = Util.colorWithHexString(hexString: lightGreyColor)
        return view
    }
}

extension AlarmInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 43
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if infoMode == .repeatMode {
            let day = days[indexPath.row]
            if !selectedDays.contains(day) {
                selectedDays.append(day)
            }
            else {
                if let index = selectedDays.index(where: {$0 == day}) {
                    selectedDays.remove(at: index)
                }
            }
        }
        else if infoMode == .soundMode {
            selectedSound = sounds[indexPath.row]
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }

}
