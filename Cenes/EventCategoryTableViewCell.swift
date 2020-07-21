//
//  EventCategoryTableViewCell.swift
//  Cenes
//
//  Created by Cenes_Dev on 30/06/2020.
//  Copyright © 2020 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class EventCategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryIconHolder: UIView!;
    @IBOutlet weak var categoryIcon: UIImageView!;
    @IBOutlet weak var categoryTitle: UILabel!;

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        categoryIconHolder.layer.cornerRadius = categoryIconHolder.frame.height/2;
        categoryIconHolder.layer.borderColor = UIColor.init(red: 151/255, green: 151/255, blue: 151/255, alpha: 1).cgColor;

    }
    
}
