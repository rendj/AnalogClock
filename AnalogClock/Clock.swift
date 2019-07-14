//
//  Clock.swift
//  AnalogClock
//
//  Created by Andrii on 7/14/19.
//  Copyright © 2019 Andrii. All rights reserved.
//

import UIKit

class Clock {
    
    lazy var dateUtils = DateUtils()
    lazy var geometryUtils = GeometryUtils()

    let clockFaceLayer = CAShapeLayer()
    let secondHandLayer = CAShapeLayer()
    let minutesHandLayer = CAShapeLayer()
    let hoursHandLayer = CAShapeLayer()
    
    var timer: Timer?
    var containerView: UIView!
    
    init(with containerView: UIView) {
        self.containerView = containerView
    }
    
    func draw() {
        drawClockFace()
        drawMainStrokes()
        drawSecondaryStrokes()
        drawDigits()
        drawHoursHand()
        drawMinutesHand()
        drawSecondsHand()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(Clock.updateHandsPosition), userInfo: nil, repeats: true)
    }
    
    @objc func updateHandsPosition() {
        secondHandLayer.transform = CATransform3DMakeRotation(CGFloat(dateUtils.currentValue(for: .second)) * geometryUtils.radianForSecond() - Constants.initialLayerAngle, 0.0, 0.0, 1.0)
        minutesHandLayer.transform = CATransform3DMakeRotation(CGFloat(dateUtils.currentValue(for: .minute)) * geometryUtils.radianForSecond() - Constants.initialLayerAngle, 0.0, 0.0, 1.0)
        hoursHandLayer.transform = CATransform3DMakeRotation(geometryUtils.initialRotationAngle(for: .hour, value:dateUtils.currentValue(for: .hour)) + (CGFloat.pi / 360) * CGFloat(dateUtils.currentValue(for: .minute)), 0.0, 0.0, 1.0)
    }
}

extension Clock {
    func drawClockFace() {
        clockFaceLayer.frame = CGRect(x: 0, y: 0, width: 2 * Constants.clockRadius, height: 2 * Constants.clockRadius)
        clockFaceLayer.path = CGPath(ellipseIn: clockFaceLayer.frame, transform: nil)
        clockFaceLayer.position = containerView.layer.position
        clockFaceLayer.lineWidth = 4.0
        clockFaceLayer.fillColor = UIColor.clear.cgColor
        clockFaceLayer.strokeColor = UIColor.black.cgColor
        containerView.layer.addSublayer(clockFaceLayer)
    }
    
    func drawMainStrokes() {
        for i in 0..<Constants.numberOfMainStrokes {
            let path = CGMutablePath()
            path.move(to: CGPoint(x: Constants.clockRadius - Constants.mainStrokeLength - Constants.mainStrokeOffset, y: 1))
            path.addLine(to: CGPoint(x: Constants.clockRadius - Constants.mainStrokeOffset, y: 1))
            let mainStrokeLayer = CAShapeLayer()
            mainStrokeLayer.frame = CGRect(x: 0, y: 0, width: Constants.clockRadius, height: 2)
            mainStrokeLayer.anchorPoint = CGPoint(x: 0.0, y: 0.5)
            mainStrokeLayer.strokeColor = UIColor.black.cgColor
            mainStrokeLayer.lineWidth = 2.0
            mainStrokeLayer.path = path
            mainStrokeLayer.position = containerView.layer.position
            mainStrokeLayer.transform = CATransform3DMakeRotation(CGFloat(i) * geometryUtils.angleForMainStrokes() - Constants.initialLayerAngle, 0.0, 0.0, 1.0)
            containerView.layer.addSublayer(mainStrokeLayer)
        }
    }
    
    func drawSecondaryStrokes() {
        for i in 1...Constants.numberOfSecondaryStrokes {
            if i % 5 == 0 { continue }
            
            let path = CGMutablePath()
            path.move(to: CGPoint(x: Constants.clockRadius - Constants.secondaryStrokeLength - Constants.mainStrokeOffset, y: 1))
            path.addLine(to: CGPoint(x: Constants.clockRadius - Constants.mainStrokeOffset, y: 1))
            let secondaryStrokeLayer = CAShapeLayer()
            secondaryStrokeLayer.frame = CGRect(x: 0, y: 0, width: Constants.clockRadius, height: 1)
            secondaryStrokeLayer.anchorPoint = CGPoint(x: 0.0, y: 0.5)
            secondaryStrokeLayer.strokeColor = UIColor.black.cgColor
            secondaryStrokeLayer.lineWidth = 1.0
            secondaryStrokeLayer.path = path
            secondaryStrokeLayer.position = containerView.layer.position
            secondaryStrokeLayer.transform = CATransform3DMakeRotation(CGFloat(i) * geometryUtils.angleForSecondaryStrokes() - Constants.initialLayerAngle, 0.0, 0.0, 1.0)
            containerView.layer.addSublayer(secondaryStrokeLayer)
        }
    }
    
    func drawDigits() {
        for i in 1...Constants.numberOfMainStrokes {
            let text = String(i)
            let font = UIFont.systemFont(ofSize: Constants.fontSize, weight: .light)
            let textSize = font.sizeOf(string: String(i))
            let angle = CGFloat(i) * geometryUtils.angleForMainStrokes() - Constants.initialLayerAngle
            let textLayerLocation = CGFloat(Constants.clockRadius - Constants.mainStrokeOffset + Int(textSize.width / 2) + Constants.digitOffset)
            
            let textLayer = CATextLayer()
            textLayer.alignmentMode = .center
            textLayer.frame = CGRect(origin: .zero, size: textSize)
            textLayer.string = text
            textLayer.font = font
            textLayer.fontSize = Constants.fontSize
            textLayer.contentsScale = UIScreen.main.scale
            textLayer.foregroundColor = UIColor.black.cgColor
            
            let xPosition = textLayerLocation * cos(angle) + containerView.layer.position.x
            let yPosition = textLayerLocation * sin(angle) + containerView.layer.position.y
            textLayer.position = CGPoint(x: xPosition, y: yPosition)
            containerView.layer.addSublayer(textLayer)
        }
    }
}

extension Clock {
    func drawSecondsHand() {
        let secondHandFrame = CGRect(origin: .zero, size: geometryUtils.handSize(for: .second))
        let path = CGMutablePath()
        path.addPath(CGPath(rect: secondHandFrame, transform: nil))
        path.addEllipse(in: CGRect(x: 0.1 * secondHandFrame.size.width - Constants.handsCirleRadius , y: secondHandFrame.size.height / 2 - Constants.handsCirleRadius, width: 2 * Constants.handsCirleRadius, height: 2 * Constants.handsCirleRadius))
        secondHandLayer.path = path
        secondHandLayer.frame = secondHandFrame
        secondHandLayer.fillColor = UIColor.red.cgColor
        secondHandLayer.anchorPoint = Constants.handsAnchorPoint
        containerView.layer.addSublayer(secondHandLayer)
        secondHandLayer.position = containerView.layer.position
        secondHandLayer.transform = CATransform3DMakeRotation(-Constants.initialLayerAngle, 0.0, 0.0, 1.0)
        secondHandLayer.transform = CATransform3DMakeRotation(geometryUtils.initialRotationAngle(for: .second, value: dateUtils.currentValue(for: .second)), 0.0, 0.0, 1.0)
    }
    
    func drawMinutesHand() {
        let minutesHandFrame = CGRect(origin: .zero, size: geometryUtils.handSize(for: .minute))
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: minutesHandFrame.size.width, y: minutesHandFrame.size.height / 4))
        path.addLine(to: CGPoint(x: minutesHandFrame.size.width, y:  3 * minutesHandFrame.size.height / 3))
        path.addLine(to: CGPoint(x: 0, y:  minutesHandFrame.size.height))
        path.closeSubpath()
        minutesHandLayer.path = path
        minutesHandLayer.frame = minutesHandFrame
        minutesHandLayer.fillColor = UIColor.darkGray.cgColor
        minutesHandLayer.anchorPoint = Constants.handsAnchorPoint
        containerView.layer.addSublayer(minutesHandLayer)
        minutesHandLayer.position = containerView.layer.position
        minutesHandLayer.transform = CATransform3DMakeRotation(-Constants.initialLayerAngle, 0.0, 0.0, 1.0)
        minutesHandLayer.transform = CATransform3DMakeRotation(geometryUtils.initialRotationAngle(for: .minute, value: dateUtils.currentValue(for: .minute)), 0.0, 0.0, 1.0)
    }
    
    func drawHoursHand() {
        let hoursHandFrame = CGRect(origin: .zero, size: geometryUtils.handSize(for: .hour))
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: hoursHandFrame.size.width, y: hoursHandFrame.size.height / 3))
        path.addLine(to: CGPoint(x: hoursHandFrame.size.width, y:  2 * hoursHandFrame.size.height / 3))
        path.addLine(to: CGPoint(x: 0, y:  hoursHandFrame.size.height))
        path.closeSubpath()
        
        hoursHandLayer.path = path
        hoursHandLayer.frame = hoursHandFrame
        hoursHandLayer.fillColor = UIColor.darkGray.cgColor
        hoursHandLayer.anchorPoint = Constants.handsAnchorPoint
        containerView.layer.addSublayer(hoursHandLayer)
        hoursHandLayer.position = containerView.layer.position
        hoursHandLayer.transform = CATransform3DMakeRotation(-Constants.initialLayerAngle, 0.0, 0.0, 1.0)
        hoursHandLayer.transform = CATransform3DMakeRotation(geometryUtils.initialRotationAngle(for: .hour, value: dateUtils.currentValue(for: .hour)) + (CGFloat.pi / 360) * CGFloat(dateUtils.currentValue(for: .minute)) , 0.0, 0.0, 1.0)
    }
}

