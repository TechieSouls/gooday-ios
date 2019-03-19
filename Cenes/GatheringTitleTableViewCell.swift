//
//  GatheringTableViewCellTwo.swift
//  Cenes
//
//  Created by Redblink on 05/09/17.
//  Copyright © 2017 Sabita Rani Samal. All rights reserved.
//

import UIKit

class GatheringTitleTableViewCell: UITableViewCell  {
    
    
    var gatheringView : CreateGatheringViewController!
    
    @IBOutlet weak var eventTitleTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension GatheringTitleTableViewCell : UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //self.gatheringView.eventName = textField.text!
        self.gatheringView.event.title = textField.text!
        textField.resignFirstResponder()
          return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            let textAfterUpdate = text.replacingCharacters(in: range, with: string)
            print(textAfterUpdate)
            //self.gatheringView.eventName = textAfterUpdate
            self.gatheringView.event.title = textAfterUpdate;
        }
        return true
    }
}
    

