//
//  AddAlarmViewController+Extensions.swift
//  Cenes
//
//  Created by Chinna Addepally on 11/18/17.
//  Copyright © 2017 Redblink Pvt Ltd. All rights reserved.
//

import Foundation

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
