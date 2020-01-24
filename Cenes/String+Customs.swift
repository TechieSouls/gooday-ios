//
//  String+Customs.swift
//  Cenes
//
//  Created by Cenes_Dev on 20/01/2020.
//  Copyright © 2020 Cenes Pvt Ltd. All rights reserved.
//

import Foundation

extension String {
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
}
