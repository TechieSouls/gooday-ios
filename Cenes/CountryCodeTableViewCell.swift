//
//  CountryCodeTableViewCell.swift
//  Cenes
//
//  Created by Macbook on 29/09/18.
//  Copyright © 2018 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class CountryCodeTableViewCell: UITableViewCell {

    
    @IBOutlet weak var countryFlag: UIImageView!
    
    @IBOutlet weak var countryName: UILabel!
    
    @IBOutlet weak var countryCode: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.countryFlag.layer.masksToBounds = false;
        self.countryFlag.layer.borderColor = UIColor.black.cgColor;
        self.countryFlag.layer.cornerRadius = self.countryFlag.frame.height/2;
        self.countryFlag.clipsToBounds = true;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
