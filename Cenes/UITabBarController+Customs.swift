//
//  UITabBarController+Customs.swift
//  Deploy
//
//  Created by Cenes_Dev on 08/04/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation

extension UITabBarController {
    
    func setTabBarDotVisible(visible:Bool) {
        
        let tag = 1001
        for subview in self.tabBar.subviews {
            if  (subview.tag == tag) {
                subview.removeFromSuperview();
            }
        }
        
        if (tabBarItem == nil || !visible) {
            return
        }
        
        let roundDotView : UIView = UIView.init(frame: CGRect.init(x: self.view.frame.width - ((self.view.frame.width/4) + ((self.view.frame.width/4)/2)), y: 5, width: 10, height: 10))
        roundDotView.layer.cornerRadius = roundDotView.bounds.size.height/2
        roundDotView.backgroundColor = UIColor.red
        roundDotView.tag = 1001
        self.tabBar.addSubview(roundDotView)
    }
}
