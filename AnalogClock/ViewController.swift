//
//  ViewController.swift
//  AnalogClock
//
//  Created by Andrii on 7/13/19.
//  Copyright © 2019 Andrii. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    lazy var dateUtils = DateUtils()
    lazy var geometryUtils = GeometryUtils()
    var timer: Timer?
    
    let clockFaceLayer = CAShapeLayer()
    let secondHandLayer = CAShapeLayer()
    let minutesHandLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawClockFace()
        drawMainStrokes()
        drawSecondaryStrokes()
        drawDigits()
        drawSecondsHand()
        drawMinutesHand()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.updateHandsPosition), userInfo: nil, repeats: true)
    }
    //TODo: - move clock to the separate struct!!!
    func drawClockFace() {
        clockFaceLayer.frame = CGRect(x: 0, y: 0, width: 2 * geometryUtils.clockRadius, height: 2 * geometryUtils.clockRadius)
        clockFaceLayer.path = CGPath(ellipseIn: clockFaceLayer.frame, transform: nil)
        clockFaceLayer.position = view.layer.position
        clockFaceLayer.lineWidth = 4.0
        clockFaceLayer.fillColor = UIColor.clear.cgColor
        clockFaceLayer.strokeColor = UIColor.black.cgColor
        view.layer.addSublayer(clockFaceLayer)
    }
    
    func drawMainStrokes() {
        for i in 0..<geometryUtils.numberOfMainStrokes {
            let path = CGMutablePath()
            path.move(to: CGPoint(x: geometryUtils.clockRadius - geometryUtils.mainStrokeLength - geometryUtils.mainStrokeOffset, y: 1))
            path.addLine(to: CGPoint(x: geometryUtils.clockRadius - geometryUtils.mainStrokeOffset, y: 1))
            let mainStrokeLayer = CAShapeLayer()
            mainStrokeLayer.frame = CGRect(x: 0, y: 0, width: geometryUtils.clockRadius, height: 2)
            mainStrokeLayer.anchorPoint = CGPoint(x: 0.0, y: 0.5)
            mainStrokeLayer.strokeColor = UIColor.black.cgColor
            mainStrokeLayer.lineWidth = 2.0
            mainStrokeLayer.path = path
            mainStrokeLayer.position = view.layer.position
            mainStrokeLayer.transform = CATransform3DMakeRotation(CGFloat(i) * geometryUtils.angleForMainStrokes() - geometryUtils.initialLayerAngle, 0.0, 0.0, 1.0)
            view.layer.addSublayer(mainStrokeLayer)
        }
    }
    
    func drawSecondaryStrokes() {
        for i in 1...geometryUtils.numberOfSecondaryStrokes {
            if i % 5 == 0 { continue }
            
            let path = CGMutablePath()
            path.move(to: CGPoint(x: geometryUtils.clockRadius - geometryUtils.secondaryStrokeLength - geometryUtils.mainStrokeOffset, y: 1))
            path.addLine(to: CGPoint(x: geometryUtils.clockRadius - geometryUtils.mainStrokeOffset, y: 1))
            let secondaryStrokeLayer = CAShapeLayer()
            secondaryStrokeLayer.frame = CGRect(x: 0, y: 0, width: geometryUtils.clockRadius, height: 1)
            secondaryStrokeLayer.anchorPoint = CGPoint(x: 0.0, y: 0.5)
            secondaryStrokeLayer.strokeColor = UIColor.black.cgColor
            secondaryStrokeLayer.lineWidth = 1.0
            secondaryStrokeLayer.path = path
            secondaryStrokeLayer.position = view.layer.position
            secondaryStrokeLayer.transform = CATransform3DMakeRotation(CGFloat(i) * geometryUtils.angleForSecondaryStrokes() - geometryUtils.initialLayerAngle, 0.0, 0.0, 1.0)
            view.layer.addSublayer(secondaryStrokeLayer)
        }
    }
    
    func drawDigits() {
        for i in 1...geometryUtils.numberOfMainStrokes {
            let text = String(i)
            let font = UIFont.systemFont(ofSize: geometryUtils.fontSize, weight: .light)
            let textSize = font.sizeOf(string: String(i))
            let angle = CGFloat(i) * geometryUtils.angleForMainStrokes() - geometryUtils.initialLayerAngle
            let targetLocation = CGFloat(geometryUtils.clockRadius - geometryUtils.mainStrokeOffset + Int(textSize.width / 2) + 10)
            
            let textLayer = CATextLayer()
            textLayer.alignmentMode = .center
            textLayer.frame = CGRect(origin: .zero, size: textSize)
            textLayer.string = text
            textLayer.font = font
            textLayer.fontSize = geometryUtils.fontSize
            textLayer.contentsScale = UIScreen.main.scale
            textLayer.foregroundColor = UIColor.black.cgColor
            
            let xPosition = targetLocation * cos(angle) + view.layer.position.x
            let yPosition = targetLocation * sin(angle) + view.layer.position.y
            textLayer.position = CGPoint(x: xPosition, y: yPosition)
            view.layer.addSublayer(textLayer)
        }
    }
    
    @objc func updateHandsPosition() {
         secondHandLayer.transform = CATransform3DMakeRotation(CGFloat(dateUtils.currentValue(for: .second)) * geometryUtils.radianForSecond() - geometryUtils.initialLayerAngle, 0.0, 0.0, 1.0)
        minutesHandLayer.transform = CATransform3DMakeRotation(CGFloat(dateUtils.currentValue(for: .minute)) * geometryUtils.radianForSecond() - geometryUtils.initialLayerAngle, 0.0, 0.0, 1.0)
    }
}

extension ViewController {
    func drawSecondsHand() {
        let secondHandFrame = CGRect(origin: .zero, size: geometryUtils.handSize(for: .second))
        secondHandLayer.path = CGPath(rect: secondHandFrame, transform: nil)
        secondHandLayer.frame = secondHandFrame
        secondHandLayer.fillColor = UIColor.red.cgColor
        secondHandLayer.anchorPoint = CGPoint(x: 0.1, y: 0.5)
        view.layer.addSublayer(secondHandLayer)
        secondHandLayer.position = view.layer.position
        secondHandLayer.transform = CATransform3DMakeRotation(-geometryUtils.initialLayerAngle, 0.0, 0.0, 1.0) //point up
        secondHandLayer.transform = CATransform3DMakeRotation(geometryUtils.initialRadiansFor(seconds: dateUtils.currentValue(for: .second)), 0.0, 0.0, 1.0)
    }
    
    func drawMinutesHand() {
        let minutesHandFrame = CGRect(origin: .zero, size: geometryUtils.handSize(for: .minute))
        minutesHandLayer.path = CGPath(rect: minutesHandFrame, transform: nil)
        minutesHandLayer.frame = minutesHandFrame
        minutesHandLayer.fillColor = UIColor.darkGray.cgColor
        minutesHandLayer.anchorPoint = CGPoint(x: 0.1, y: 0.5)
        view.layer.addSublayer(minutesHandLayer)
        minutesHandLayer.position = view.layer.position
        minutesHandLayer.transform = CATransform3DMakeRotation(-geometryUtils.initialLayerAngle, 0.0, 0.0, 1.0) //point up
        minutesHandLayer.transform = CATransform3DMakeRotation(geometryUtils.initialRadiansFor(seconds: dateUtils.currentValue(for: .minute)), 0.0, 0.0, 1.0)
    }
}

