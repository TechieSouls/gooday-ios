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
        
        let roundDotView : UIView = UIView(frame: CGRect(self.view.frame.width - ((self.view.frame.width/3)/2), 5, 10, 10))
        roundDotView.layer.cornerRadius = roundDotView.bounds.size.height/2
        roundDotView.backgroundColor = UIColor.red
        roundDotView.tag = 1001
        self.tabBar.addSubview(roundDotView)
    }
}
