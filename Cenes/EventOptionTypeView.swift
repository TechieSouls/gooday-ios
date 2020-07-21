//
//  EventOptionTypeView.swift
//  Cenes
//
//  Created by Cenes_Dev on 25/06/2020.
//  Copyright © 2020 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class EventOptionTypeView: UIView {

    @IBOutlet weak var privateEventBackdropView: UIView!;
    @IBOutlet weak var privateEventUIView: UIView!;
    @IBOutlet weak var publicEventUIView: UIView!;
    @IBOutlet weak var buyCreditsBtn: UIButton!;

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "EventOptionTypeView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}
