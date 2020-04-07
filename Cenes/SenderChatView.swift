//
//  SenderChatView.swift
//  Cenes
//
//  Created by Cenes_Dev on 15/03/2020.
//  Copyright © 2020 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class SenderChatView: UIView {
    
    @IBOutlet weak var senderChatBoxView: UIView!;
    @IBOutlet weak var chatMessage: UILabel!;
    @IBOutlet weak var chatTime: UILabel!;
    @IBOutlet weak var chatMsgStatus: UIImageView!;

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.senderChatBoxView.layer.cornerRadius = 10;
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "SenderChatView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }

}
