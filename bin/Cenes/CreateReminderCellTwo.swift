//
//  CreateReminderCellTwo.swift
//  Cenes
//
//  Created by Redblink on 25/09/17.
//  Copyright © 2017 Redblink Pvt Ltd. All rights reserved.
//

import UIKit
import  IoniconsSwift

protocol CreateReminderCellTwoDelegate : class {
    func expandButtonTApped(indexPath:IndexPath)
    
}


class CreateReminderCellTwo: UITableViewCell {

    
    @IBOutlet weak var upperLabel: UILabel!
    
    
    @IBOutlet weak var expandButton: UIButton!
    
    
    @IBOutlet weak var lowerLabel: UILabel!
    
    @IBOutlet weak var lowerView: UIView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    var delegate : CreateReminderCellTwoDelegate!
    
    var indexPathCell : IndexPath!
    
    var createReminderView : CreateReminderViewController!
    var cellTabbed = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        expandButton.setImage(Ionicons.chevronUp.image(20, color: UIColor.black), for: .selected)
        expandButton.setImage(Ionicons.chevronDown.image(20, color: UIColor.black), for: .normal)
        let dateFormatterNew = DateFormatter()
        
        
        dateFormatterNew.dateFormat = "EEEE, MMM d, h:mm a"
        datePicker.date = Date()
        let newDateString = dateFormatterNew.string(from:datePicker.clampedDate)
        
        self.lowerLabel.text = newDateString
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func expandButtonPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        self.cellTabbed = !cellTabbed
        
        if self.cellTabbed == true {
            self.lowerView.alpha = 0
        }else{
            self.lowerView.alpha = 0.5
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            if self.cellTabbed == false {
                self.lowerView.alpha = 0
            }
            else{
                self.lowerView.alpha = 1
            }
            self.lowerView.isHidden  = !self.lowerView.isHidden
            
        }) { (true) in
            
        }
        
        delegate.expandButtonTApped(indexPath: self.indexPathCell)
    }
    
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        
        
        
        let dateFormatterNew = DateFormatter()
        self.createReminderView.selectedDate = sender.clampedDate
        dateFormatterNew.dateFormat = "EEEE, MMM d, h:mm a"
        let newDateString = dateFormatterNew.string(from: sender.clampedDate)
        
        self.lowerLabel.text = newDateString
    }
    
    
}


