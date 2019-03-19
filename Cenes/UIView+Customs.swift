//
//  UIView+Customs.swift
//  Deploy
//
//  Created by Macbook on 28/01/19.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation

extension UIView {
    
    func roundedView() {
        self.layer.cornerRadius = (self.frame.width / 2);
        self.layer.masksToBounds = true
    }
    
    func viewCircledCorners() -> Void {
        self.layer.cornerRadius = 40;
    }
}
