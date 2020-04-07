//
//  AppUpdateAlertView.swift
//  Cenes
//
//  Created by Cenes_Dev on 18/02/2020.
//  Copyright © 2020 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class AppUpdateAlertView: UIView {

    @IBOutlet weak var alertView: UIView!;
    @IBOutlet weak var playStoreButton: UIButton!;
    @IBOutlet weak var alertTitle: UILabel!;
    @IBOutlet weak var alertdescription: UILabel!;

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        alertView.layer.cornerRadius = 8;
        
        playStoreButton.layer.borderWidth = 0.5
        playStoreButton.layer.borderColor = UIColor.init(red: 238/255, green: 155/255, blue: 38/255, alpha: 1).cgColor;
        playStoreButton.layer.cornerRadius = 22;
    }

    
}
