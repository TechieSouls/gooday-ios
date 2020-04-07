//
//  ChatFeatureView.swift
//  Cenes
//
//  Created by Cenes_Dev on 14/03/2020.
//  Copyright © 2020 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class ChatFeatureView: UIView {

    @IBOutlet weak var chatMessageScrollView: UIScrollView!;
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ChatFeatureView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}
