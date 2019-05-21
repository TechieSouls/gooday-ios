//
//  DeleteAccountTableViewCell.swift
//  Deploy
//
//  Created by Cenes_Dev on 18/05/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class DeleteAccountTableViewCell: UITableViewCell {

    @IBOutlet weak var countryBar: UIView!
    
    @IBOutlet weak var countryLabel: UILabel!
    
    @IBOutlet weak var countryCode: UILabel!
    
    @IBOutlet weak var phoneNumber: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var deleteAccountButton: UIButton!
    
    var appSettingsEditViewControllerDelegate: AppSettingsEditViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let countryBarTap = UITapGestureRecognizer.init(target: self, action: #selector(countryBarPressed));
        countryBar.addGestureRecognizer(countryBarTap);
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func deleteAccountButtonPressed(_ sender: Any) {
    }
    
    @objc func countryBarPressed() {
        appSettingsEditViewControllerDelegate.navigateToCountryList();
    }
}
