//
//  FriendShimmerView.swift
//  Cenes
//
//  Created by Cenes_Dev on 05/03/2020.
//  Copyright © 2020 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class FriendShimmerView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "FriendShimmerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}
