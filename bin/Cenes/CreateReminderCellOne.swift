//
//  CreateReminderCellOne.swift
//  Cenes
//
//  Created by Redblink on 25/09/17.
//  Copyright © 2017 Redblink Pvt Ltd. All rights reserved.
//

import UIKit

class CreateReminderCellOne: UITableViewCell {

    @IBOutlet weak var todoButton: UIButton!
    @IBOutlet weak var importantButton: UIButton!
    @IBOutlet weak var urgentButton: UIButton!
    
    
    @IBOutlet weak var titleTextField: UITextField!
    
    var createReminderView : CreateReminderViewController!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func todoPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            sender.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.bold)
            self.createReminderView.reminderCategory = "todo"
        }else{
            sender.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.medium)
            self.createReminderView.reminderCategory = ""
        }
        
        importantButton.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.medium)
        urgentButton.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.medium)
        importantButton.isSelected = false
        urgentButton.isSelected = false
        
    }
    
    @IBAction func importantPressed(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            sender.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.bold)
             self.createReminderView.reminderCategory = "important"
        }else{
            sender.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.medium)
             self.createReminderView.reminderCategory = ""
        }
        
        todoButton.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.medium)
        urgentButton.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.medium)
        todoButton.isSelected = false
        urgentButton.isSelected = false
       
    }
    
    @IBAction func urgentPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            sender.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.bold)
            self.createReminderView.reminderCategory = "urgent"
        }else{
            sender.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.medium)
            self.createReminderView.reminderCategory = ""
        }
        
        todoButton.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.medium)
        todoButton.isSelected = false
        importantButton.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.medium)
        importantButton.isSelected = false
        
    }
    
}

extension CreateReminderCellOne : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            let textAfterUpdate = text.replacingCharacters(in: range, with: string)
            print(textAfterUpdate)
            self.createReminderView.reminderTitle = textAfterUpdate
            
        }
        return true
    }
}
