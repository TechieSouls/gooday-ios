//
//  UIViewController+Customs.swift
//  Deploy
//
//  Created by Cenes_Dev on 09/05/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation

extension UIViewController {
    
    func errorAlert(message: String) -> Void {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
