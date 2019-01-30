//
//  Date+Customs.swift
//  Deploy
//
//  Created by Macbook on 20/12/18.
//  Copyright © 2018 Cenes Pvt Ltd. All rights reserved.
//

import Foundation

extension Date {
    public var clampedDate: Date {
        let referenceTimeInterval = self.timeIntervalSinceReferenceDate
        let remainingSeconds = referenceTimeInterval.truncatingRemainder(dividingBy: TimeInterval(1*60))
        let timeRoundedToInterval = referenceTimeInterval - remainingSeconds
        return Date(timeIntervalSinceReferenceDate: timeRoundedToInterval)
    }
}
