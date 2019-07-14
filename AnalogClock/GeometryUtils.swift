//
//  GeometryUtils.swift
//  AnalogClock
//
//  Created by Andrii on 7/14/19.
//  Copyright © 2019 Andrii. All rights reserved.
//

import UIKit

struct GeometryUtils {
    
    func angleForMainStrokes() -> CGFloat {
        return 2 * CGFloat.pi / CGFloat(Constants.numberOfMainStrokes)
    }
    
    func angleForSecondaryStrokes() -> CGFloat {
        return 2 * CGFloat.pi / CGFloat(Constants.numberOfSecondaryStrokes)
    }
    
    func handSize(for type: DateComponetType) -> CGSize {
        switch type {
        case .second: return CGSize(width: Constants.clockRadius - 20, height: 2)
        case .minute: return CGSize(width: Constants.clockRadius - 45, height: 4)
        case .hour: return CGSize(width: Constants.clockRadius - 80, height: 8)
        }
    }
    
    func initialRotationAngle(for type: DateComponetType, value: Int) -> CGFloat {
        switch type {
        case .second:
            fallthrough
        case .minute:
            return (CGFloat.pi / 30) * CGFloat(value) - Constants.initialLayerAngle
        case .hour:
            return (CGFloat.pi / CGFloat(6.0)) * CGFloat(value) - Constants.initialLayerAngle
        }
    }
    
    func radianForSecond() -> CGFloat {
        return CGFloat.pi / CGFloat(30.0)
    }
}
