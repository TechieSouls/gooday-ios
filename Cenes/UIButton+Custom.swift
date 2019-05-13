//
//  UIButton+Custom.swift
//  Deploy
//
//  Created by Cenes_Dev on 12/03/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
extension UIButton {
    
    func btnCircledCorners() -> Void {
        self.layer.cornerRadius = 20;
    }
    
    func selectedBottomBorderBtn() -> Void {
        var lineView = UIView(frame: CGRect(0, self.frame.size.height-2, self.frame.size.width, 2))
        lineView.backgroundColor = UIColor.orange;
        self.addSubview(lineView)
    }
    func unselectedBottomBorderBtn() -> Void {
        var lineView = UIView(frame: CGRect(0, self.frame.size.height-2, self.frame.size.width, 2))
        lineView.backgroundColor = themeColor;
        self.addSubview(lineView)
    }
}
