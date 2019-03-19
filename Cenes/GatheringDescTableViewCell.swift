//
//  GAtheringTableViewCellFour.swift
//  Cenes
//
//  Created by Redblink on 05/09/17.
//  Copyright © 2017 Sabita Rani Samal. All rights reserved.
//

import UIKit

class GatheringDescTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var eventDetailsField: UITextField!
    var gatheringView : CreateGatheringViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}

extension GatheringDescTableViewCell : UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //self.gatheringView.eventDetails = textField.text!
        self.gatheringView.event.description = textField.text!
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            let textAfterUpdate = text.replacingCharacters(in: range, with: string)
            print(textAfterUpdate)
            //self.gatheringView.eventDetails = textAfterUpdate
            self.gatheringView.event.description = textAfterUpdate

        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        NotificationCenter.default.post(name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
}
