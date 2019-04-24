//
//  UIImageView+Customs.swift
//  Deploy
//
//  Created by Macbook on 21/01/19.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, UIImage>()

extension UIImageView {
    
    func setRounded() {
        self.layer.cornerRadius = (self.frame.width / 2);
        self.layer.masksToBounds = true
    }
    
    func setRoundedWhiteBorder() {
        self.layer.cornerRadius = (self.frame.width / 2);
        self.layer.masksToBounds = true
        self.layer.borderWidth = 2;
        self.layer.borderColor = UIColor.white.cgColor;
    }
    
    func cacheImage(urlString: String){
        let url = URL(string: urlString)
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url!) {
            data, response, error in
            if let response = data {
                DispatchQueue.main.async {
                    let imageToCache = UIImage(data: data!)
                    if (imageToCache != nil) {
                        imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
                        self.image = imageToCache
                        self.setRounded()
                    } else {
                        self.image = #imageLiteral(resourceName: "profile icon")
                    }
                    
                }
            }
            }.resume()
    }
}
