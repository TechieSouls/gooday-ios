//
//  RequestToJoinAlertView.swift
//  Cenes
//
//  Created by Cenes_Dev on 30/06/2020.
//  Copyright © 2020 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class RequestToJoinAlertView: UIView {

    @IBOutlet weak var alertContainerView: UIView!;
    @IBOutlet weak var alertTextField: UITextField!;
    @IBOutlet weak var cancelBtn: UIButton!;
    @IBOutlet weak var sendBtn: UIButton!;

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        alertContainerView.layer.cornerRadius = 12;
    }

}
