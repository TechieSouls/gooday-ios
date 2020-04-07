//
//  TapToChatView.swift
//  Cenes
//
//  Created by Cenes_Dev on 13/03/2020.
//  Copyright © 2020 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class TapToChatView: UIView {

    @IBOutlet weak var chatLikeView: UITextField!;
    @IBOutlet weak var profilePic: UIImageView!;
    @IBOutlet weak var hostGradientCircle: UIImageView!;

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func draw(_ rect: CGRect) {
        
        profilePic.layer.borderWidth = 1.5;
        profilePic.layer.borderColor = UIColor.white.cgColor;
        profilePic.layer.cornerRadius = profilePic.bounds.height/2;
        profilePic.clipsToBounds = true;
        
        chatLikeView.layer.cornerRadius = 10;
        
        chatLikeView.isEnabled = false;
        
        let leftPadding = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 20, height: chatLikeView.frame.height));
        chatLikeView.leftView = leftPadding;
        chatLikeView.leftViewMode = .always

    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "TapToChatView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}
