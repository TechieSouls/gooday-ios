//
//  DateDropDownTableViewCell.swift
//  Deploy
//
//  Created by Cenes_Dev on 27/04/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class DateDropDownTableViewCell: UITableViewCell, DateDroDownCellProtocol {
    
    

    
    @IBOutlet weak var topDate: UILabel!
    
    @IBOutlet weak var clanedarToggleArrowVioew: UIView!
    
    @IBOutlet weak var calendarArrow: UIImageView!
    
    var newHomeViewControllerDelegate: NewHomeViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.backgroundColor = themeColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateDate(milliseconds: Int) {
        
        let currentYear = Calendar.current.component(.year, from: Date());
        let scrollYear = Calendar.current.component(.year, from: Date(milliseconds: milliseconds));

        if (currentYear == scrollYear) {
            self.topDate.text = String(Date(milliseconds: Int(milliseconds)).EMMMd()!);

        } else {
            self.topDate.text = String(Date(milliseconds: Int(milliseconds)).EMMMMdyyyy()!);
        }
        self.topDate.frame = CGRect(x: 0, y: 40/2, width: self.topDate.intrinsicContentSize.width, height: 40);

        self.clanedarToggleArrowVioew.frame = CGRect(x: self.topDate.intrinsicContentSize.width+10, y: contentView.frame.height/2, width: 26, height: 32);
    }
}
