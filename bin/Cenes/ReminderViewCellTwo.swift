//
//  ReminderViewCellTwo.swift
//  Cenes
//
//  Created by Redblink on 26/09/17.
//  Copyright © 2017 Redblink Pvt Ltd. All rights reserved.
//

import UIKit
import  IoniconsSwift

class ReminderViewCellTwo: UITableViewHeaderFooterView {
    
    
    @IBOutlet weak var headerTitle: UILabel!
    
    @IBOutlet weak var headerButton: UIButton!
    
    @IBOutlet weak var colorView: UIView!
    
    var section : Int!
    
    var reminderView : ReminderViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        headerButton.setImage(Ionicons.chevronUp.image(20, color: UIColor.black), for: .selected)
        headerButton.setImage(Ionicons.chevronDown.image(20, color: UIColor.black), for: .normal)
        // Initialization code
    }

    
    @IBAction func headerButtonPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected{
            print("SElected")
        }else{
            print("not slected")
        }
        
        reminderView.sectionPressed(section: self.section, hide: sender.isSelected)
        
    }
    

}
