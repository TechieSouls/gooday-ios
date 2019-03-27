//
//  Connectivity.swift
//  Deploy
//
//  Created by Cenes_Dev on 27/03/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
import Alamofire
class Connectivity {
    class var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
