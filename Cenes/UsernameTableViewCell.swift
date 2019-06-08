//
//  UsernameTableViewCell.swift
//  Deploy
//
//  Created by Cenes_Dev on 06/05/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class UsernameTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    
    var editPersonalDetailsViewControllerDelegate: EditPersonalDetailsViewController!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        nameTextField.backgroundColor = UIColor.white;

        let nameLeftView = UIView(frame: CGRect.init(x: 0, y: 0, width: 20, height: nameTextField.frame.height))
        nameTextField.leftView = nameLeftView;
        nameTextField.leftViewMode = .always
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        editPersonalDetailsViewControllerDelegate.showHideSaveButtom(isHidden: true);

        return true;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (textField.text == "") {
            return false;
        }
        
        editPersonalDetailsViewControllerDelegate.username = textField.text!;
        editPersonalDetailsViewControllerDelegate.saveUserDetails();
        return true;
    }
}
