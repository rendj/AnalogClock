//
//  DateUtils.swift
//  AnalogClock
//
//  Created by Andrii on 7/14/19.
//  Copyright © 2019 Andrii. All rights reserved.
//

import Foundation

enum DateComponetType {
    case second
    case minute
    case hour
    
    var dateFormat: String {
        switch self {
        case .second:
            return "ss"
        case .minute:
            return "mm"
        case .hour:
            return "hh"
        }
    }
}

class DateUtils {

    func currentValue(for type: DateComponetType) -> Int { //TODO: - make CGFloat
        let formatter = DateFormatter()
        formatter.dateFormat = type.dateFormat
        let valueString = formatter.string(from: Date())
        precondition(Int(valueString) != nil)
        return Int(valueString)!
    }
}
