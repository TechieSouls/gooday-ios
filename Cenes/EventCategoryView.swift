//
//  EventCategoryView.swift
//  Cenes
//
//  Created by Cenes_Dev on 26/06/2020.
//  Copyright © 2020 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class EventCategoryView: UIView {

    @IBOutlet weak var categoryIconHolder: UIView!;
    @IBOutlet weak var categoryIcon: UIImageView!;
    @IBOutlet weak var categoryTitle: UILabel!;

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        categoryIconHolder.layer.cornerRadius = categoryIconHolder.frame.height/2;
        categoryIconHolder.layer.borderColor = UIColor.init(red: 151/255, green: 151/255, blue: 151/255, alpha: 1).cgColor;
    }

}
