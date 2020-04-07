//
//  ChatBlurbView.swift
//  Cenes
//
//  Created by Cenes_Dev on 19/03/2020.
//  Copyright © 2020 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class ChatBlurbView: UIView {

    @IBOutlet weak var chatBlurbLabel: UILabel!;
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ChatBlurbView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }

}
