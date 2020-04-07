//
//  AttendeeChatView.swift
//  Cenes
//
//  Created by Cenes_Dev on 11/03/2020.
//  Copyright © 2020 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class AttendeeChatView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet weak var chatLblView: UIView!;
    @IBOutlet weak var chatLbl: UILabel!;
    @IBOutlet weak var chatTime: UILabel!;
    @IBOutlet weak var profilePic: UIImageView!;
    @IBOutlet weak var hostGradientColor: UIImageView!;

    override func draw(_ rect: CGRect) {
        
        chatLblView.layer.cornerRadius = 10
        profilePic.layer.cornerRadius = profilePic.bounds.height/2;
        profilePic.clipsToBounds = true;
        
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "AttendeeChatView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }

}
