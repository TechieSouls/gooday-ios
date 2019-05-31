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
        self.layer.cornerRadius = 45;
    }
    
    func fadedSeparator() -> Void {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.startPoint = CGPoint(x: 0, y: 0)
        
        gradient.endPoint = CGPoint(x: 0.4, y: 0.4)
        gradient.colors = [UIColor.init(red: 181/255, green: 181/255, blue: 182/255, alpha: 1).cgColor, UIColor.clear]
        
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func roundedUIViewWhiteBorderGreyBackground() {
        self.layer.cornerRadius = (self.frame.width / 2);
        self.layer.masksToBounds = true;
        self.backgroundColor = UIColor(red: 0.86, green: 0.87, blue: 0.87, alpha: 1)
        self.layer.borderColor = UIColor.white.cgColor;
        self.layer.borderWidth = 2;
    }
    
    func roundedUIViewGreyBackground() {
        self.layer.cornerRadius = (self.frame.width / 2);
        self.layer.masksToBounds = true;
        self.backgroundColor = UIColor(red: 0.86, green: 0.87, blue: 0.87, alpha: 1)
    }
    
}
