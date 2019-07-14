//
//  GeometryUtils.swift
//  AnalogClock
//
//  Created by Andrii on 7/14/19.
//  Copyright © 2019 Andrii. All rights reserved.
//

import UIKit

class GeometryUtils {
    
    let initialLayerAngle = CGFloat.pi / 2.0
    let clockRadius = 150
    let mainStrokeLength = 15
    let mainStrokeOffset = 54
    let secondaryStrokeLength = 5
    let numberOfMainStrokes = 12
    let numberOfSecondaryStrokes = 60
    let fontSize = CGFloat(28)
    let handsCirleRadius = CGFloat(5)
    
    func angleForMainStrokes() -> CGFloat {
        return 2 * CGFloat.pi / CGFloat(numberOfMainStrokes)
    }
    
    func angleForSecondaryStrokes() -> CGFloat {
        return 2 * CGFloat.pi / CGFloat(numberOfSecondaryStrokes)
    }
    
    func handSize(for type: DateComponetType) -> CGSize {
        switch type {
        case .second: return CGSize(width: clockRadius - 20, height: 2)
        case .minute: return CGSize(width: clockRadius - 40, height: 4)
        case .hour: return CGSize(width: clockRadius - 70, height: 6)
        }
    }
    
}

extension GeometryUtils {
    func initialRadiansFor(seconds: Int) -> CGFloat {
        return (2 * CGFloat.pi / 60) * CGFloat(seconds) - initialLayerAngle
    }
    
    func initialRadiansFor(minutes: Int) -> CGFloat {
        return (2 * CGFloat.pi / 60) * CGFloat(minutes) - initialLayerAngle
    }
    
    func initialRadiansFor(hours: Int) -> CGFloat {
        return (2 * CGFloat.pi / CGFloat(12.0)) * CGFloat(hours) - initialLayerAngle
    }
}

extension GeometryUtils {
    //TODO: - imporove naming! use enum DateComponentType
    func radianForSecond() -> CGFloat {
        return 2 * CGFloat.pi / CGFloat(60.0) //it is possible to optimize the expression by removing "2 *" and divide by 30 except of 60. Didnt optimize it for clarity.
    }
    
    func radianForMinute() -> CGFloat {
        return 2 * CGFloat.pi / CGFloat(3600.0) //it is possible to optimize the expression by removing "2 *" and divide by 1800 except of 3600. Didnt optimize it for clarity.
    }
    
    func radianForHour() -> CGFloat {
        return 2 * CGFloat.pi / CGFloat(216000.0) //it is possible to optimize the expression by removing "2 *" and divide by 108000.0 except of 216000.0. Didnt optimize it for clarity.
    }
}
